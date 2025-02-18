`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.02.2025 08:07:57
// Design Name: 
// Module Name: 16bitFixedPointMult
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


module Conv_Multi_Add#(Convol_Size=9)(A,B,Out,Cin);

localparam Size = $clog2(Convol_Size+1);
input [15:0] A,B;
input [31+Size:0] Cin;
output [31+Size:0] Out;
assign Out = $signed(A) * $signed(B)+$signed(Cin);

endmodule
