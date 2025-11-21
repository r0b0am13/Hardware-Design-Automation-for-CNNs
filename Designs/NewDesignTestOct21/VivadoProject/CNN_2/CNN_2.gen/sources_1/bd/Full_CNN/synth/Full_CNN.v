//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Tue Oct 28 12:15:55 2025
//Host        : ROG-STRIX-G16 running 64-bit major release  (build 9200)
//Command     : generate_target Full_CNN.bd
//Design      : Full_CNN
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "Full_CNN,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=Full_CNN,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=7,numReposBlks=7,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=7,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=3,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "Full_CNN.hwdef" *) 
module Full_CNN
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK, ASSOCIATED_RESET reset_n, CLK_DOMAIN Full_CNN_clock, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input clock;
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

  wire [143:0]ConvSlider_kernel_out;
  wire ConvSlider_kernel_valid;
  wire [15:0]ConvWeightBiasModule_0_Bias;
  wire [143:0]ConvWeightBiasModule_0_Weights;
  wire [15:0]Convolution_0_conv_out;
  wire Convolution_0_conv_valid;
  wire [15:0]DataConverter_0_out;
  wire [63:0]MaxSlider_kernel_out;
  wire MaxSlider_kernel_valid;
  wire [15:0]Maxpool_0_maxp_out;
  wire Maxpool_0_maxp_valid;
  wire clock_0_1;
  wire data_valid_0_1;
  wire [7:0]in_0_1;
  wire reset_n_1;
  wire [63:0]zyNet_0_o1_valid_d;
  wire [31:0]zyNet_0_o2_valid_d;
  wire [9:0]zyNet_0_o3_valid_d;
  wire [31:0]zyNet_0_out_final;
  wire zyNet_0_out_valid_final;
  wire [1023:0]zyNet_0_x1_out_d;
  wire [511:0]zyNet_0_x2_out_d;
  wire [159:0]zyNet_0_x3_out_d;

  assign Conv_Debug[15:0] = Convolution_0_conv_out;
  assign Conv_valid_Debug = Convolution_0_conv_valid;
  assign Maxpool_Debug[15:0] = Maxpool_0_maxp_out;
  assign Maxpool_valid_Debug = Maxpool_0_maxp_valid;
  assign clock_0_1 = clock;
  assign data_valid_0_1 = data_in_valid;
  assign in_0_1 = Pixel_In[7:0];
  assign o1_valid_d[63:0] = zyNet_0_o1_valid_d;
  assign o2_valid_d[31:0] = zyNet_0_o2_valid_d;
  assign o3_valid_d[9:0] = zyNet_0_o3_valid_d;
  assign out_final[31:0] = zyNet_0_out_final;
  assign out_valid_final = zyNet_0_out_valid_final;
  assign reset_n_1 = reset_n;
  assign x1_out_d[1023:0] = zyNet_0_x1_out_d;
  assign x2_out_d[511:0] = zyNet_0_x2_out_d;
  assign x3_out_d[159:0] = zyNet_0_x3_out_d;
  Full_CNN_ImageBuf_KernelSlider_0_0 ConvSlider
       (.clock(clock_0_1),
        .data_in(DataConverter_0_out),
        .data_valid(data_valid_0_1),
        .kernel_out(ConvSlider_kernel_out),
        .kernel_valid(ConvSlider_kernel_valid),
        .sreset_n(reset_n_1));
  Full_CNN_ConvWeightBiasModule_0_0 ConvWeightBiasModule_0
       (.Bias(ConvWeightBiasModule_0_Bias),
        .Weights(ConvWeightBiasModule_0_Weights));
  Full_CNN_Convolution_0_0 Convolution_0
       (.bias(ConvWeightBiasModule_0_Bias),
        .clock(clock_0_1),
        .conv_out(Convolution_0_conv_out),
        .conv_valid(Convolution_0_conv_valid),
        .data_valid(ConvSlider_kernel_valid),
        .kernel_in(ConvSlider_kernel_out),
        .sreset_n(reset_n_1),
        .weights(ConvWeightBiasModule_0_Weights));
  Full_CNN_DataConverter_0_0 DataConverter_0
       (.data_in(in_0_1),
        .data_out(DataConverter_0_out));
  Full_CNN_ConvSlider_0 MaxSlider
       (.clock(clock_0_1),
        .data_in(Convolution_0_conv_out),
        .data_valid(Convolution_0_conv_valid),
        .kernel_out(MaxSlider_kernel_out),
        .kernel_valid(MaxSlider_kernel_valid),
        .sreset_n(reset_n_1));
  Full_CNN_Maxpool_0_0 Maxpool_0
       (.clock(clock_0_1),
        .data_valid(MaxSlider_kernel_valid),
        .kernel_in(MaxSlider_kernel_out),
        .maxp_out(Maxpool_0_maxp_out),
        .maxp_valid(Maxpool_0_maxp_valid),
        .sreset_n(reset_n_1));
  Full_CNN_zyNet_0_0 zyNet_0
       (.axis_in_data(Maxpool_0_maxp_out),
        .axis_in_data_valid(Maxpool_0_maxp_valid),
        .o1_valid_d(zyNet_0_o1_valid_d),
        .o2_valid_d(zyNet_0_o2_valid_d),
        .o3_valid_d(zyNet_0_o3_valid_d),
        .out_final(zyNet_0_out_final),
        .out_valid_final(zyNet_0_out_valid_final),
        .s_axi_aclk(clock_0_1),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_aresetn(reset_n_1),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bready(1'b0),
        .s_axi_rready(1'b0),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wstrb({1'b1,1'b1,1'b1,1'b1}),
        .s_axi_wvalid(1'b0),
        .x1_out_d(zyNet_0_x1_out_d),
        .x2_out_d(zyNet_0_x2_out_d),
        .x3_out_d(zyNet_0_x3_out_d));
endmodule
