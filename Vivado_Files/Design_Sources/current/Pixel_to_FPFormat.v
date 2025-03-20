`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2025 03:22:44
// Design Name: 
// Module Name: Pixel_to_FPFormat
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


module Pixel8_to_FP16Format#(
    parameter IN_DATA_WIDTH = 8,
    parameter OUT_INTEGER = 2,
    parameter OUT_FRACTION = 14
)
(
    input [IN_DATA_WIDTH-1 : 0] Pixel_In ,
    output [OUT_INTEGER+OUT_FRACTION -1 : 0] FP_Out

);
    assign FP_Out = {2'b0,Pixel_In,6'b0};
   
endmodule
