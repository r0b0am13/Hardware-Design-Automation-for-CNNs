`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2025 00:24:49
// Design Name: 
// Module Name: Weight_Bias
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


module Weight_Bias #(
    parameter DATA_WIDTH = 16,
    parameter KERNEL_SIZE = 3,
    parameter FILE_NAME = "conv_2d_w.mem"
    )
    (
    output [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] weights,
    output [DATA_WIDTH-1:0] bias
    );
    
    assign bias = 16'b0000000010111001;
    
    assign weights = {16'b1111101110100010,
16'b1111100101010010,
16'b1111111100011000,
16'b1111100101001000,
16'b1111110101110011,
16'b1111011000100011,
16'b1111100011111001,
16'b1111011011101100,
16'b1111110000100000}; 
    
     
    
endmodule
