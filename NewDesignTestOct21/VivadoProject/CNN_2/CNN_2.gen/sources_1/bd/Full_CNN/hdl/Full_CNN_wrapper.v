//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Tue Oct 28 12:15:55 2025
//Host        : ROG-STRIX-G16 running 64-bit major release  (build 9200)
//Command     : generate_target Full_CNN_wrapper.bd
//Design      : Full_CNN_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Full_CNN_wrapper
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
  output [15:0]Conv_Debug;
  output Conv_valid_Debug;
  output [15:0]Maxpool_Debug;
  output Maxpool_valid_Debug;
  input [7:0]Pixel_In;
  input clock;
  input data_in_valid;
  output [63:0]o1_valid_d;
  output [31:0]o2_valid_d;
  output [9:0]o3_valid_d;
  output [31:0]out_final;
  output out_valid_final;
  input reset_n;
  output [1023:0]x1_out_d;
  output [511:0]x2_out_d;
  output [159:0]x3_out_d;

  wire [15:0]Conv_Debug;
  wire Conv_valid_Debug;
  wire [15:0]Maxpool_Debug;
  wire Maxpool_valid_Debug;
  wire [7:0]Pixel_In;
  wire clock;
  wire data_in_valid;
  wire [63:0]o1_valid_d;
  wire [31:0]o2_valid_d;
  wire [9:0]o3_valid_d;
  wire [31:0]out_final;
  wire out_valid_final;
  wire reset_n;
  wire [1023:0]x1_out_d;
  wire [511:0]x2_out_d;
  wire [159:0]x3_out_d;

  Full_CNN Full_CNN_i
       (.Conv_Debug(Conv_Debug),
        .Conv_valid_Debug(Conv_valid_Debug),
        .Maxpool_Debug(Maxpool_Debug),
        .Maxpool_valid_Debug(Maxpool_valid_Debug),
        .Pixel_In(Pixel_In),
        .clock(clock),
        .data_in_valid(data_in_valid),
        .o1_valid_d(o1_valid_d),
        .o2_valid_d(o2_valid_d),
        .o3_valid_d(o3_valid_d),
        .out_final(out_final),
        .out_valid_final(out_valid_final),
        .reset_n(reset_n),
        .x1_out_d(x1_out_d),
        .x2_out_d(x2_out_d),
        .x3_out_d(x3_out_d));
endmodule
