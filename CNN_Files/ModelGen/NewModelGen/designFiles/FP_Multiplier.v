`timescale 1ns / 1ps
module FP_Multiplier#(
    
    parameter DATA_WIDTH  = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter GUARD = 1 //If guard is 0, it would saturate internally, else would output double the bits of input
    
    )(
    
    input  wire [DATA_WIDTH-1:0]    A,
    input  wire [DATA_WIDTH-1:0]    B,
    output wire [DATA_WIDTH-1+(GUARD==1 ? DATA_WIDTH : 0):0]    Y
    
    );
    
    generate  
        if(GUARD == 1) begin
            if(SIGNED == 1) begin
                assign Y = $signed(A) * $signed(B);
            end
            else begin
                assign Y = A * B;
            end
        end
        else begin 
            
            wire [2*DATA_WIDTH-1:0] mult_full;
            wire [2*DATA_WIDTH-1:0] shifted_val;
            
            if(SIGNED == 1) begin
              assign mult_full = $signed(A) * $signed(B);
              assign shifted_val = $signed(mult_full) >>> FRACTION_SIZE;
              
              assign Y = (mult_full[2*DATA_WIDTH-1]) ? 
              (!(&shifted_val[2*DATA_WIDTH-1:DATA_WIDTH-1]) ? //condition to check for negative overflow
              {1'b1,{(DATA_WIDTH-1){1'b0}}} //overflowed if true since top is not completely 1s
              : shifted_val[DATA_WIDTH-1:0]) : //negative but within bounds
              (|shifted_val[2*DATA_WIDTH-1:DATA_WIDTH-1] ? //if true means overflow
              {1'b0,{(DATA_WIDTH-1){1'b1}}} //overflowed hence saturate
              : shifted_val[DATA_WIDTH-1:0]); //positive within bounds
              
            end
            else begin
               assign mult_full = A * B;
               assign shifted_val = mult_full >> FRACTION_SIZE;
               assign Y = |shifted_val[2*DATA_WIDTH-1:DATA_WIDTH] ? {DATA_WIDTH{1'b1}} :
                           shifted_val[DATA_WIDTH-1:0];
            end  
        end
    endgenerate 
endmodule
