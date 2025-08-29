`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2025 23:56:46
// Design Name: 
// Module Name: Complete_CNN_TestBench_FixedParams
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


module Complete_CNN_TestBench_FixedParams();

reg clock,data_in_valid,reset_n;
reg [7:0] Pixel_In;
wire [15:0] Conv_Debug, Maxpool_Debug;
wire Maxpool_valid_Debug,Conv_valid_Debug;
wire [31:0] out_final;
wire [1023:0] x1_out_d;
wire [511:0] x2_out_d;
wire [159:0] x3_out_d;
wire out_valid_final;
wire [63:0] o1_valid_d;
wire [31:0] o2_valid_d;
wire [9:0] o3_valid_d;


Full_CNN_wrapper
   (Conv_Debug,
    Conv_valid_Debug,
    Maxpool_Debug,
    Maxpool_valid_Debug,
    Pixel_In,
    clock,
    data_in_valid,
    o1_valid_d,
    o2_valid_d,
    o3_valid_d,
    out_final,
    out_valid_final,
    reset_n,
    x1_out_d,
    x2_out_d,
    x3_out_d);
    
    
endmodule
