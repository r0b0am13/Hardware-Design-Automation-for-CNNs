`timescale 1ns / 1ps


module Pipelined_Convolution#(
    parameter KERNEL_SIZE = 3,
    parameter DATA_WIDTH = 16,
    parameter FRACTION_BITS = 14,
    parameter SIGNED = 1
    )
    (
    input [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] data, weights,
    input [DATA_WIDTH-1:0] bias,
    input clock,
    input valid,
    output [DATA_WIDTH-1:0] convol_out,
    output convol_valid

    );
    localparam NUM_INP = KERNEL_SIZE*KERNEL_SIZE + 1;
    localparam STAGES = $clog2(NUM_INP);
    wire [DATA_WIDTH-1:0] init [0:NUM_INP - 1];


    reg [STAGES-1:0] valid_reg;
    wire [STAGES-2:0] valid_wire;
    //VALID LOGIC
    genvar m;
    generate
        for(m=0; m<STAGES;m=m+1)
            if(m==0) begin
                always @(posedge clock)
                    valid_reg[m] <=valid;
                assign valid_wire[m] = valid_reg[m]; 
            end       
            else if(m==STAGES-1) begin
                always @(posedge clock)
                    valid_reg[m] <=valid_wire[m-1];
                assign convol_valid = valid_reg[m]; 
            end
            else begin
                always @(posedge clock)
                    valid_reg[m] <=valid_wire[m-1];
                assign valid_wire[m] = valid_reg[m]; 
            end       
    endgenerate
    
    //Multiplier Stage
    genvar l;
    generate
        for(l = 0; l<NUM_INP-1; l= l+1) begin       
            FP_Multiplier #(.SIGNED(SIGNED),.INTEGER(DATA_WIDTH - FRACTION_BITS),.FRACTION(FRACTION_BITS)) Mult (.a(data[DATA_WIDTH*(l+1)-1:DATA_WIDTH*l]),.b(weights[DATA_WIDTH*(l+1)-1:DATA_WIDTH*l]),.out(init[l]));
        end
            assign init[NUM_INP-1] = bias;  
    endgenerate

    //Binary Reduction Tree Adder
    genvar i,j,k;
    generate
        for(i = 0; i<STAGES; i = i+1) begin : gen_stage
    
            localparam stage_input = STAGE_WIDTH(NUM_INP,i);
            localparam adder_num = stage_input >> 1;
            localparam only_wire = stage_input % 2;
            localparam stage_width = only_wire + adder_num;
        
            wire [DATA_WIDTH-1:0] wire_array [0:stage_width-1];
            reg [DATA_WIDTH-1:0] reg_array [0:stage_width-1];
        
            for(j = 0; j < adder_num+1; j=j+1) begin : gen_adder
                if(j<adder_num) begin
                    if(i==0) begin
                        FP_Adder #(.SIGNED(SIGNED),.INTEGER(DATA_WIDTH - FRACTION_BITS),.FRACTION(FRACTION_BITS)) adder (.a(init[2*j]),.b(init[2*j+1]),.out(wire_array[j]));
                    end
                    else begin
                        FP_Adder #(.SIGNED(SIGNED),.INTEGER(DATA_WIDTH - FRACTION_BITS),.FRACTION(FRACTION_BITS)) adder (.a(gen_stage[i-1].reg_array[2*j]),.b(gen_stage[i-1].reg_array[2*j+1]),.out(wire_array[j]));
                    end
                end
                if(j==adder_num) begin
                    if(only_wire ==1) begin
                        if(i==0) begin
                            assign wire_array[j] = init[2*j];
                        end
                        else begin
                            assign wire_array[j] = gen_stage[i-1].reg_array[2*j];
                        end
                    end
                end
            end
        
            for(k=0; k<stage_width; k = k+1) begin : gen_reg
            always @(posedge clock)
                reg_array[k] <= wire_array[k];
            end
        end
        assign convol_out = gen_stage[STAGES-1].reg_array[0];
    endgenerate
    
    //Function to find STAGE_WIDTH at each ADDER Stage
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
 