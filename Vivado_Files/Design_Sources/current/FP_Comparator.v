`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2025 12:04:06
// Design Name: 
// Module Name: FP_Comparator
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


module FP_Comparator#(
    parameter SIGNED = 1,
    parameter INTEGER = 2,
    parameter FRACTION = 14
)
(
    input[INTEGER+FRACTION-1:0] a,b,
    output [INTEGER+FRACTION-1:0] out

);

    assign out = ($signed(a) > $signed(b)) ? a : b;
endmodule
