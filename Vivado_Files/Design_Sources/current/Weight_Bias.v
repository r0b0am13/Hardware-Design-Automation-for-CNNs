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
    parameter KERNEL_SIZE = 3
    )
    (
    output [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] weights,
    output [DATA_WIDTH-1:0] bias
    );
    
    assign weights = {16'b1110101011011000,  //-0.33056640625
                      16'b0000010101101010,  //0.0845947265625
                      16'b0000111101001011,  //0.23895263671875
                      16'b0000110110111101,  //0.21466064453125
                      16'b0000110101010100,  //0.208251953125
                      16'b0001000010101111,  //0.26068115234375
                      16'b0000001011001110,  //0.0438232421875
                      16'b0001111011111111,  //0.48431396484375
                      16'b1110011100100000}; //-0.388671875
    assign bias = 16'b1111011011010110; //-0.1431884765625
endmodule
