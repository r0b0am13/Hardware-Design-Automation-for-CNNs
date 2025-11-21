`timescale 1ns / 1ps

module Conv_MIC#( //This module just does sum(weights[i]*inputs[i]). No bias is added in this specific block
    
    parameter KERNEL_SIZE = 3,
    parameter INPUT_CHANNELS = 1,
    parameter DATA_WIDTH  = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter ACTIVATION = 1,
    parameter GUARD_TYPE = 3 // 0 - No guard (basically saturates at each stage
                             // 1 - Adder Guard (only saturates at mult stage and final adder stage) //Applicable only to SIC
                             // 2 - Adder + Mult Guard (saturates at the final of one channel only)  //Applicable only to SIC
                             // 3 - Full Guard (saturates at the end of the complete block) //Applicable SIC/MIC
    
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    input  wire [DATA_WIDTH-1:0]    bias,
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] weights,
    output wire [DATA_WIDTH-1:0]    conv_out,
    output wire                     conv_valid
    
    );
    
    localparam SC_STAGES = $clog2(KERNEL_SIZE*KERNEL_SIZE);
    localparam SC_WIDTH = DATA_WIDTH + (GUARD_TYPE==3 ? DATA_WIDTH+SC_STAGES : 0);
    localparam INTEGER_SIZE = DATA_WIDTH-FRACTION_SIZE;
    genvar i,j,k;
    integer l,m,n;
    
    //Seperation (Wire-Only) Stage
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] InputChannels [0:INPUT_CHANNELS-1];
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] WeightChannels [0:INPUT_CHANNELS-1];
    generate
        for(i=0; i<INPUT_CHANNELS; i = i +1) begin
            assign InputChannels[INPUT_CHANNELS-1-i] = kernel_in[(i+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1: i*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH];
            assign WeightChannels[INPUT_CHANNELS-1-i] = weights[(i+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1: i*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH];
        end
    endgenerate
    
    //Convolution SICs stage
    wire [SC_WIDTH-1:0] channel_outputs [0:INPUT_CHANNELS]; //last one for the bias.
    wire [INPUT_CHANNELS-1:0] channel_valid;
     
    generate
        //Bias assignment logic
        if(SIGNED) begin
            assign channel_outputs[INPUT_CHANNELS] = (GUARD_TYPE==3) ?{{(SC_STAGES+INTEGER_SIZE){bias[DATA_WIDTH-1]}},bias,{FRACTION_SIZE{1'b0}}} : bias;
        end
        else begin
            assign channel_outputs[INPUT_CHANNELS] = (GUARD_TYPE==3) ? {{(SC_STAGES+INTEGER_SIZE){1'b0}},bias,{FRACTION_SIZE{1'b0}}} : bias;
        end
        
        //SIC instance generation
        for(i=0; i<INPUT_CHANNELS; i = i +1) begin
            ConvBlock_SIC #(
                .KERNEL_SIZE(KERNEL_SIZE),         
                .DATA_WIDTH(DATA_WIDTH),         
                .FRACTION_SIZE(FRACTION_SIZE),      
                .SIGNED(SIGNED),              
                .GUARD_TYPE(GUARD_TYPE)           
            ) ConvBlock_SIC_inst (
                .clock(clock),                
                .data_valid(data_valid),          
                .sreset_n(sreset_n),             
                .kernel_in(InputChannels[i]),            
                .weights(WeightChannels[i]),              
                .conv_out(channel_outputs[i]),             
                .conv_valid(channel_valid[i])            
            );
        end
    endgenerate
    
    //Binary Tree adder
    localparam NUM_INP = INPUT_CHANNELS + 1;
    localparam STAGES = $clog2(NUM_INP);
    generate
        for(i = 0; i<STAGES; i = i+1) begin : gen_stage
        
            localparam stage_input = STAGE_WIDTH(NUM_INP,i);
            localparam adder_num = stage_input >> 1;
            localparam only_wire = stage_input % 2;
            localparam stage_width = only_wire + adder_num;
            
            wire [DATA_WIDTH + ((GUARD_TYPE==3) ? DATA_WIDTH+SC_STAGES+i : -1) : 0] wire_array [0:stage_width-1];
            reg  [DATA_WIDTH + ((GUARD_TYPE==3) ? DATA_WIDTH+SC_STAGES+i : -1) : 0] reg_array  [0:stage_width-1];
            
            localparam AddStartWidth =  (GUARD_TYPE==3) ? 2*DATA_WIDTH+SC_STAGES : DATA_WIDTH;
            for(j = 0; j < adder_num+1; j=j+1) begin : gen_adder
                if(j<adder_num) begin
                    if(i==0) begin
                        FP_Adder #(
                            .DATA_WIDTH(AddStartWidth),       
                            .FRACTION_SIZE(FRACTION_SIZE),
                            .SIGNED(SIGNED),            
                            .GUARD((GUARD_TYPE==3))    
                        ) u_FP_Adder (
                            .A(channel_outputs[2*j]),           
                            .B(channel_outputs[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                     else begin
                        FP_Adder #(
                            .DATA_WIDTH(AddStartWidth + ((GUARD_TYPE==3) ? i : 0)),       
                            .FRACTION_SIZE(FRACTION_SIZE),
                            .SIGNED(SIGNED),            
                            .GUARD((GUARD_TYPE==3))    
                        ) u_FP_Adder (
                            .A(gen_stage[i-1].reg_array[2*j]),           
                            .B(gen_stage[i-1].reg_array[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                end
                if(j==adder_num) begin
                    if(only_wire ==1) begin
                        if(i==0) begin
                            assign wire_array[j] = (SIGNED == 1) ?  $signed(channel_outputs[2*j]) : channel_outputs[2*j];
                            //assign wire_array[j] = (SIGNED == 1) ?  {channel_outputs[2*j][SC_WIDTH-1],channel_outputs[2*j]} : channel_outputs[2*j];
                        end
                        else begin
                            assign wire_array[j] = (SIGNED == 1) ? $signed(gen_stage[i-1].reg_array[2*j]) : gen_stage[i-1].reg_array[2*j];
                            //assign wire_array[j] = (SIGNED == 1) ? {gen_stage[i-1].reg_array[2*j][DATA_WIDTH + ((GUARD_TYPE==3) ? DATA_WIDTH+SC_STAGES+(i-1) : -1)],
                            //                                    gen_stage[i-1].reg_array[2*j]} : gen_stage[i-1].reg_array[2*j];
                        end
                    end
                end
            end
            
            for(k=0; k<stage_width; k = k+1) begin : gen_reg
            always @(posedge clock)
                if(!sreset_n)
                    reg_array[k] <= 0;
                else
                    reg_array[k] <= wire_array[k];
            end
        end
        
        //Saturation Logics
        wire [DATA_WIDTH-1:0] conv_before_activation;
        
        if(GUARD_TYPE == 3) begin
            wire [2*DATA_WIDTH-1+STAGES+SC_STAGES:0] shifted_val;
            if(SIGNED==1) begin
                assign shifted_val = $signed(gen_stage[STAGES-1].reg_array[0]) >>> FRACTION_SIZE;
                assign conv_before_activation = (shifted_val[2*DATA_WIDTH-1+STAGES+SC_STAGES]) ? 
                  (!(&shifted_val[2*DATA_WIDTH-1+STAGES+SC_STAGES:DATA_WIDTH-1]) ? //condition to check for negative overflow
                  {1'b1,{(DATA_WIDTH-1){1'b0}}} //overflowed if true since top is not completely 1s
                  : shifted_val[DATA_WIDTH-1:0]) : //negative but within bounds
                  (|shifted_val[2*DATA_WIDTH-1+STAGES+SC_STAGES:DATA_WIDTH-1] ? //if true means overflow
                  {1'b0,{(DATA_WIDTH-1){1'b1}}} //overflowed hence saturate
                  : shifted_val[DATA_WIDTH-1:0]); //positive but within bounds;
            end
            else begin
                assign shifted_val = gen_stage[STAGES-1].reg_array[0] >> FRACTION_SIZE;
                assign conv_before_activation = |shifted_val[2*DATA_WIDTH-1+STAGES+SC_STAGES:DATA_WIDTH] ? 
                                {DATA_WIDTH{1'b1}} :
                                shifted_val[DATA_WIDTH-1:0];
            end
        end
        
        else begin
            assign conv_before_activation = gen_stage[STAGES-1].reg_array[0][DATA_WIDTH-1:0];
        end
        
        wire [DATA_WIDTH-1:0] conv_out_wire;
        //ACTIVATION_PART
        if(SIGNED==1) begin
            if(ACTIVATION==1) begin
                assign conv_out_wire = conv_before_activation[DATA_WIDTH-1] ? 0 : conv_before_activation;
            end
            else begin
                assign conv_out_wire = conv_before_activation;
            end
        end
        else begin
            assign conv_out_wire = conv_before_activation;
        end
        
        reg [DATA_WIDTH-1:0] conv_out_reg;
        
        always @(posedge clock) begin
            if(!sreset_n)
                    conv_out_reg <= 0;
                else
                    conv_out_reg <= conv_out_wire;
        end
        
        assign conv_out = conv_out_reg;
        
    endgenerate
    
    //Valid Propagation 
    
    reg Valid [0 : STAGES];
    assign conv_valid = Valid[STAGES];
    
    always @(posedge clock) begin
        if(!sreset_n) begin
            for(l=0; l<STAGES+1; l=l+1) begin
               Valid[l] <=0;
            end
        end
        else begin
            Valid[0] <= channel_valid[0];
            for(l=1; l<STAGES+1; l=l+1) begin
                Valid[l] <=Valid[l-1];
            end
        end
    end
   
    
    function automatic integer STAGE_WIDTH;
        input integer n, stage;
        integer i,x;
        begin
            x=n;
                for(i = 0; i<stage; i=i+1) begin 
                x= x%2 + x/2;
                end
            STAGE_WIDTH = x;
        end
    endfunction
    
endmodule
