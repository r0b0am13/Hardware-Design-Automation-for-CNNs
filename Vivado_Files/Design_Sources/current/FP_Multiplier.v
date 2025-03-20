`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2025 03:04:30
// Design Name: 
// Module Name: FP_Multiplier
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


module FP_Multiplier#(
    parameter SIGNED = 1,
    parameter INTEGER = 2,
    parameter FRACTION = 14
)
(
    input[INTEGER+FRACTION-1:0] a,b,
    output [INTEGER+FRACTION-1:0] out

);

wire [2*(INTEGER+FRACTION)-1:0] out_middle;  

assign out_middle =  SIGNED ? ($signed(a) * $signed(b)) : a*b ;
assign out = out_middle>>(FRACTION);

endmodule
