`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2025 11:03:26
// Design Name: 
// Module Name: FP_Adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FP_Adder#(
    
    parameter DATA_WIDTH  = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter GUARD = 1 //If guard is 0, it would saturate internally, else would have a guard bit to prevent that issue
    
    )(
    
    input  wire [DATA_WIDTH-1:0]    A,
    input  wire [DATA_WIDTH-1:0]    B,
    output wire [DATA_WIDTH-1+(GUARD==1 ? 1 : 0):0]    Y
    
    );
    
    wire [DATA_WIDTH:0] internal;
    
    generate
        if(GUARD == 1) begin
            if(SIGNED==1) begin
                assign Y = $signed(A) + $signed(B);
            end
            else begin
                assign Y = A + B;
            end 
        end
        else begin
            if(SIGNED==1) begin
                assign internal = $signed(A) + $signed(B);
                assign Y = ( internal[DATA_WIDTH] != internal[DATA_WIDTH-1] ) ? // overflow if sign bit differs from carry out
                            ( internal[DATA_WIDTH] ? {1'b1, {(DATA_WIDTH-1){1'b0}}}  // most negative
                                                   : {1'b0, {(DATA_WIDTH-1){1'b1}}}  // most positive
                            ) :
                            internal[DATA_WIDTH-1:0];
            end
            else begin
                assign internal = A + B;
                assign Y = internal[DATA_WIDTH] ? {(DATA_WIDTH){1'b1}} : internal[DATA_WIDTH-1:0];
            end
        end
    endgenerate
    
    
endmodule
