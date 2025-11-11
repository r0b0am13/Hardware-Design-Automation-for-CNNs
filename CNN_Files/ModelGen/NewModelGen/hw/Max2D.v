`timescale 1ns / 1ps
//=====================================================
// Module: Max2D
// Description: Combines ImageBufferChnl + MaxpoolChnl
//=====================================================

module Max2D #(
    // ---------------- Image Buffer Parameters ----------------
    parameter KERNEL_SIZE   = 2,    // Pooling window size (usually 2x2)
    parameter DATA_WIDTH    = 16,   // Data bit width per channel
    parameter COLUMN_NUM    = 8,    // Input image width
    parameter ROW_NUM       = 8,    // Input image height
    parameter STRIDE        = 2,    // Pooling stride
    parameter CHANNELS      = 2,    // Number of feature map channels
    parameter SIGNED        = 1     // 1 for signed arithmetic
)(
    // ---------------- I/O Ports ----------------
    input  wire                              clock,
    input  wire                              data_valid,
    input  wire                              sreset_n,
    input  wire [CHANNELS*DATA_WIDTH-1:0]    data_in,

    // Output after 2D max pooling
    output wire [CHANNELS*DATA_WIDTH-1:0]    maxp_out,
    output wire                              maxp_valid
);

    // ---------------- Internal Signals ----------------
    wire [CHANNELS*DATA_WIDTH-1:0] data_out_buffer;
    wire [CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_window;
    wire kernel_valid_signal;

    //=====================================================
    //  Image Buffer for Pooling Window Extraction
    //=====================================================
    ImageBufferChnl #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .COLUMN_NUM(COLUMN_NUM),
        .ROW_NUM(ROW_NUM),
        .STRIDE(STRIDE),
        .CHANNELS(CHANNELS)
    ) ImageBufferChnl_inst (
        .clock(clock),
        .data_valid(data_valid),
        .sreset_n(sreset_n),
        .data_in(data_in),
        .data_out(data_out_buffer),
        .kernel_out(kernel_window),
        .kernel_valid(kernel_valid_signal)
    );

    //=====================================================
    //   Maxpool Channel Block
    //=====================================================
    MaxpoolChnl #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .SIGNED(SIGNED),
        .CHANNELS(CHANNELS)
    ) MaxpoolChnl_inst (
        .clock(clock),
        .data_valid(kernel_valid_signal),
        .sreset_n(sreset_n),
        .kernel_in(kernel_window),
        .maxp_out(maxp_out),
        .maxp_valid(maxp_valid)
    );

endmodule
