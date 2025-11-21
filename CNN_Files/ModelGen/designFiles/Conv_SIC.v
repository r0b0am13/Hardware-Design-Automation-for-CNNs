`timescale 1ns / 1ps

module ConvBlock_SIC#( //This module just does sum(weights[i]*inputs[i]). No bias is added in this specific block
    
    parameter KERNEL_SIZE = 3,
    parameter DATA_WIDTH  = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter GUARD_TYPE =3 // 0 - No guard (basically saturates at each stage
                             // 1 - Adder Guard (only saturates at mult stage and final adder stage)
                             // 2 - Adder + Mult Guard (saturates at the final stage only)
                             // 3 - Guard and dont saturate.(External saturation)
    
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    input  wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] weights,
    output wire [(GUARD_TYPE == 3)?(2*DATA_WIDTH-1+$clog2(KERNEL_SIZE*KERNEL_SIZE)):(DATA_WIDTH-1):0]    conv_out,
    output wire                     conv_valid
    
    );
    
    localparam INTEGER_SIZE = DATA_WIDTH - FRACTION_SIZE;
    localparam MULT_GUARD = (GUARD_TYPE == 2 || GUARD_TYPE == 3);
    localparam ADDER_GUARD = (GUARD_TYPE == 1 || GUARD_TYPE == 2 || GUARD_TYPE == 3);
       
    //Split into usable chunks
    reg [DATA_WIDTH-1:0] inputLayer [0:KERNEL_SIZE*KERNEL_SIZE-1];
    reg [DATA_WIDTH-1:0] weightLayer [0:KERNEL_SIZE*KERNEL_SIZE-1];
    genvar i,j,k;
    integer l,m,n;
    generate
        always @(posedge clock) begin
            if(!sreset_n) begin
                for(l=0; l<KERNEL_SIZE*KERNEL_SIZE;l=l+1) begin
                   inputLayer[KERNEL_SIZE*KERNEL_SIZE-l-1] <= 0;
                   weightLayer[KERNEL_SIZE*KERNEL_SIZE-l-1] <= 0;
                end
            end
            else begin
                for(l=0; l<KERNEL_SIZE*KERNEL_SIZE;l=l+1) begin
                   inputLayer[KERNEL_SIZE*KERNEL_SIZE-l-1] <= kernel_in[(l+1)*DATA_WIDTH-1-:DATA_WIDTH];
                   weightLayer[KERNEL_SIZE*KERNEL_SIZE-l-1] <= weights[(l+1)*DATA_WIDTH-1-:DATA_WIDTH];
                   
                end
            end
        end
    endgenerate 
   
    //Multiplier stage
   
    wire [DATA_WIDTH-1 + (MULT_GUARD==1 ? DATA_WIDTH : 0) :0] MultWire [0:KERNEL_SIZE*KERNEL_SIZE-1];
    reg [DATA_WIDTH-1 + (MULT_GUARD==1 ? DATA_WIDTH : 0) :0] MultReg [0:KERNEL_SIZE*KERNEL_SIZE-1];
   
    generate
   
        for( i =0; i < KERNEL_SIZE*KERNEL_SIZE; i=i+1) begin
            FP_Multiplier #(
                .DATA_WIDTH(DATA_WIDTH),
                .FRACTION_SIZE(FRACTION_SIZE),
                .SIGNED(SIGNED),
                .GUARD(MULT_GUARD)
            ) uut (
                .A(inputLayer[i]),
                .B(weightLayer[i]),
                .Y(MultWire[i])
            );
        end
        
    endgenerate
   
    always @(posedge clock) begin
        if(!sreset_n) begin
            for(l=0; l<KERNEL_SIZE*KERNEL_SIZE; l=l+1) begin
                MultReg[l] <=0;
            end
        end
        else begin
            for(l=0; l<KERNEL_SIZE*KERNEL_SIZE; l=l+1) begin
                MultReg[l] <=MultWire[l];
            end
        end
    end
    
   //Binary Adder Stage
   localparam NUM_INP = KERNEL_SIZE*KERNEL_SIZE; //No bias
   localparam STAGES = $clog2(NUM_INP);
   generate
        for(i = 0; i<STAGES; i = i+1) begin : gen_stage
            localparam stage_input = STAGE_WIDTH(NUM_INP,i);
            localparam adder_num = stage_input >> 1;
            localparam only_wire = stage_input % 2;
            localparam stage_width = only_wire + adder_num;
            
            wire [DATA_WIDTH + (ADDER_GUARD ==1 ? (MULT_GUARD == 1 ? DATA_WIDTH+i : i) : -1):0] wire_array [0:stage_width-1];
            reg [DATA_WIDTH + (ADDER_GUARD ==1 ? (MULT_GUARD == 1 ? DATA_WIDTH+i : i) : -1):0] reg_array [0:stage_width-1];
            
            localparam AddStartWidth =  (MULT_GUARD == 1) ? 2*DATA_WIDTH : DATA_WIDTH;
            for(j = 0; j < adder_num+1; j=j+1) begin : gen_adder
                if(j<adder_num) begin
                    if(i==0) begin
                        FP_Adder #(
                            .DATA_WIDTH(AddStartWidth),       
                            .FRACTION_SIZE(FRACTION_SIZE),
                            .SIGNED(SIGNED),            
                            .GUARD(ADDER_GUARD)    
                        ) u_FP_Adder (
                            .A(MultReg[2*j]),           
                            .B(MultReg[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                     else begin
                        FP_Adder #(
                            .DATA_WIDTH(AddStartWidth + (ADDER_GUARD==1 ? i : 0)),       
                            .FRACTION_SIZE(FRACTION_SIZE),
                            .SIGNED(SIGNED),            
                            .GUARD(ADDER_GUARD)    
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
                             assign wire_array[j] = (SIGNED == 1) ? $signed(MultReg[2*j]) :MultReg[2*j];
                            //assign wire_array[j] = (SIGNED == 1) ? {MultReg[2*j][DATA_WIDTH-1 + (MULT_GUARD==1 ? DATA_WIDTH : 0)],MultReg[2*j]} : MultReg[2*j];
                        end
                        else begin
                            assign wire_array[j] = (SIGNED == 1) ? $signed(gen_stage[i-1].reg_array[2*j]) : gen_stage[i-1].reg_array[2*j];
                            //assign wire_array[j] = (SIGNED == 1) ? {gen_stage[i-1].reg_array[2*j][DATA_WIDTH + (ADDER_GUARD ==1 ? (MULT_GUARD == 1 ? DATA_WIDTH+(i-1) : (i-1)) : -1)],
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
        
        //Saturation Logics (should only happen if guard is not 3 (since 3 means send it out and saturate externally)
        
        wire [(GUARD_TYPE == 3)?(2*DATA_WIDTH-1+STAGES):(DATA_WIDTH-1):0] conv_before_activation;
        
        if(GUARD_TYPE == 3) begin 
            assign conv_before_activation = $signed(gen_stage[STAGES-1].reg_array[0]);
        end
        
        else if(GUARD_TYPE == 2) begin
            wire [2*DATA_WIDTH-1+STAGES:0] shifted_val;
            if(SIGNED==1) begin
                assign shifted_val = $signed(gen_stage[STAGES-1].reg_array[0]) >>> FRACTION_SIZE;
                assign conv_before_activation = (shifted_val[2*DATA_WIDTH-1+STAGES]) ? 
                  (!(&shifted_val[2*DATA_WIDTH-1+STAGES:DATA_WIDTH-1]) ? //condition to check for negative overflow
                  {1'b1,{(DATA_WIDTH-1){1'b0}}} //overflowed if true since top is not completely 1s
                  : shifted_val[DATA_WIDTH-1:0]) : //negative but within bounds
                  (|shifted_val[2*DATA_WIDTH-1+STAGES:DATA_WIDTH-1] ? //if true means overflow
                  {1'b0,{(DATA_WIDTH-1){1'b1}}} //overflowed hence saturate
                  : shifted_val[DATA_WIDTH-1:0]); //positive but within bounds;
            end
            else begin
                assign shifted_val = gen_stage[STAGES-1].reg_array[0] >> FRACTION_SIZE;
                assign conv_before_activation = |shifted_val[2*DATA_WIDTH-1+STAGES:DATA_WIDTH] ? 
                                {DATA_WIDTH{1'b1}} :
                                shifted_val[DATA_WIDTH-1:0];
            end
        end
        else if(GUARD_TYPE == 1) begin
            wire [DATA_WIDTH-1+STAGES:0] shifted_val;
            if(SIGNED==1) begin
                assign shifted_val = $signed(gen_stage[STAGES-1].reg_array[0]) >>> FRACTION_SIZE;
                assign conv_before_activation = (shifted_val[DATA_WIDTH-1+STAGES]) ? 
                  (!(&shifted_val[DATA_WIDTH-1+STAGES:DATA_WIDTH-1]) ? //condition to check for negative overflow
                  {1'b1,{(DATA_WIDTH-1){1'b0}}} //overflowed if true since top is not completely 1s
                  : shifted_val[DATA_WIDTH-1:0]) : //negative but within bounds
                  (|shifted_val[DATA_WIDTH-1+STAGES:DATA_WIDTH-1] ? //if true means overflow
                  {1'b0,{(DATA_WIDTH-1){1'b1}}} //overflowed hence saturate
                  : shifted_val[DATA_WIDTH-1:0]); //positive but within bounds;
            end
            else begin
                assign shifted_val = gen_stage[STAGES-1].reg_array[0] >> FRACTION_SIZE;
                assign conv_before_activation = |shifted_val[DATA_WIDTH-1+STAGES:DATA_WIDTH] ? 
                                {DATA_WIDTH{1'b1}} :
                                shifted_val[DATA_WIDTH-1:0];
           end
        end
        else begin
            assign conv_before_activation = gen_stage[STAGES-1].reg_array[0][DATA_WIDTH-1:0];
        end
        
        reg [(GUARD_TYPE == 3)?(2*DATA_WIDTH-1+STAGES):(DATA_WIDTH-1):0] conv_out_reg;
        
        always @(posedge clock) begin
            if(!sreset_n)
                    conv_out_reg <= 0;
                else
                    conv_out_reg <= conv_before_activation;
        end

        assign conv_out = conv_out_reg;
        
    endgenerate
    
    //Valid Propagation 
    
    reg Valid [0 : STAGES+2];
    assign conv_valid = Valid[STAGES+2];
    
    always @(posedge clock) begin
        if(!sreset_n) begin
            for(l=0; l<STAGES+3; l=l+1) begin
               Valid[l] <=0;
            end
        end
        else begin
            Valid[0] <= data_valid;
            for(l=1; l<STAGES+3; l=l+1) begin
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