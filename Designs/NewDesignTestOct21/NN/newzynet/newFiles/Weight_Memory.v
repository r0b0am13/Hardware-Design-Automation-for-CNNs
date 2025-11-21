`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2019 17:25:12
// Design Name: 
// Module Name: Weight_Memory
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
`include "include.v"

module Weight_Memory #(parameter numWeight = 3, neuronNo=5,addressWidth=10,dataWidth=16,weightFile="w_1_15.mif") 
    ( 
    input                     clk,
    input                     wen,
    input  [addressWidth-1:0] wadd,
    input  [addressWidth-1:0] radd,
    input  [dataWidth-1:0]    win,
    output [dataWidth-1:0]    wout);
    
    reg [dataWidth-1:0] mem [numWeight-1:0];
    
    initial
	begin
	    $readmemb(weightFile, mem);
	end

	always @(posedge clk)
	begin
		if (wen)
		begin
			mem[wadd] <= win;
		end
	end 
    

    assign  wout = mem[radd];

 
endmodule
