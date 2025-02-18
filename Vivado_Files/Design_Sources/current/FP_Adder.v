`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2025 11:22:18
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
    parameter SIGNED = 1,
    parameter INTEGER = 2,
    parameter FRACTION = 14
)
(
    input[INTEGER+FRACTION-1:0] a,b,
    output reg [INTEGER+FRACTION-1:0] out
);
always @(*) begin
    if(SIGNED==1) begin
        out <= $signed(a) + $signed(b);
    end
    else
        out <= a+b;
end
endmodule
