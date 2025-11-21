`timescale 1ns / 1ps

module Maxpool#(

    parameter KERNEL_SIZE = 2,
    parameter DATA_WIDTH  = 16,
    parameter SIGNED = 1
    
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    output wire [DATA_WIDTH-1:0]    maxp_out,
    output wire                     maxp_valid
    
    );
    
    //Split data into usable chunks within code
    reg [DATA_WIDTH-1:0] inputLayer [0:KERNEL_SIZE*KERNEL_SIZE-1];
              
    genvar i,j,k;
    integer l,m,n;
    generate
        always @(posedge clock) begin
            if(!sreset_n) begin
                for(l=0; l<KERNEL_SIZE*KERNEL_SIZE;l=l+1) begin
                   inputLayer[KERNEL_SIZE*KERNEL_SIZE-l-1] <= 0;                
                end
            end
            else begin
                
                for(l=0; l<KERNEL_SIZE*KERNEL_SIZE;l=l+1) begin
                   inputLayer[KERNEL_SIZE*KERNEL_SIZE-l-1] <= kernel_in[(l+1)*DATA_WIDTH-1-:DATA_WIDTH];
                end
            end
        end
    endgenerate 
    
    //Binary Tree Comparator stage
    
    localparam NUM_INP = KERNEL_SIZE*KERNEL_SIZE;
    localparam STAGES = $clog2(NUM_INP);
    generate
        for(i = 0; i<STAGES; i = i+1) begin : gen_stage
        
            localparam stage_input = STAGE_WIDTH(NUM_INP,i);
            localparam compar_num = stage_input >> 1;
            localparam only_wire = stage_input % 2;
            localparam stage_width = only_wire + compar_num;
            
            wire [DATA_WIDTH-1:0] wire_array [0:stage_width-1];
            reg [DATA_WIDTH-1:0] reg_array [0:stage_width-1];
            
            for(j = 0; j < compar_num+1; j=j+1) begin : gen_comparator
                if(j<compar_num) begin
                    if(i==0) begin
                        FP_Comparator #(
                            .DATA_WIDTH(DATA_WIDTH),
                            .SIGNED(SIGNED)              
                        ) u_FP_Comparator (
                            .A(inputLayer[2*j]),           
                            .B(inputLayer[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                     else begin
                        FP_Comparator #(
                            .DATA_WIDTH(DATA_WIDTH),       
                            .SIGNED(SIGNED)            
                        ) u_FP_Comparator (
                            .A(gen_stage[i-1].reg_array[2*j]),           
                            .B(gen_stage[i-1].reg_array[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                end
                if(j==compar_num) begin
                    if(only_wire ==1) begin
                        if(i==0) begin
                            assign wire_array[j] = inputLayer[2*j];
                        end
                        else begin
                            assign wire_array[j] = gen_stage[i-1].reg_array[2*j];
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
        assign maxp_out = gen_stage[STAGES-1].reg_array[0];
    endgenerate
    
    reg Valid [0 : STAGES];
    assign maxp_valid = Valid[STAGES];
    
    always @(posedge clock) begin
        if(!sreset_n) begin
            for(l=0; l<STAGES+1; l=l+1) begin
               Valid[l] <=0;
            end
        end
        else begin
            Valid[0] <= data_valid;
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
