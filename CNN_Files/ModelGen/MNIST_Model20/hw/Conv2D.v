//=====================================================
// Module: Conv2D
// Description: Combines ImageBufferChnl + ConvolChnl
//=====================================================
module Conv2D #(
    // ---------------- Image Buffer Parameters ----------------
    parameter KERNEL_SIZE     = 3,
    parameter COLUMN_NUM      = 5,
    parameter ROW_NUM         = 5,
    parameter STRIDE          = 1,

    // ---------------- Convolution Parameters ----------------
    parameter INPUT_CHANNELS  = 3,  // Should match CHANNELS_IN
    parameter OUTPUT_CHANNELS = 2,
    parameter DATA_WIDTH = 16,
    parameter FRACTION_SIZE   = 14,
    parameter SIGNED          = 1,
    parameter ACTIVATION      = 1,
    parameter GUARD_TYPE      = 3,
    parameter WEIGHT_FILE     = "c0_weights.mif",
    parameter BIAS_FILE       = "c0_bias.mif"
)(
    // ---------------- I/O Ports ----------------
    input  wire                              clock,
    input  wire                              data_valid,
    input  wire                              sreset_n,
    input  wire [INPUT_CHANNELS*DATA_WIDTH-1:0] data_in,

    // Output: From convolution
    output wire [OUTPUT_CHANNELS*DATA_WIDTH-1:0] conv_out,
    output wire                                       conv_valid
);

    // ---------------- Internal Signals ----------------
    wire [INPUT_CHANNELS*DATA_WIDTH-1:0] data_out_buffer;
    wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_window;
    wire kernel_valid_signal;

    //=====================================================
    // Image Buffer Instantiation
    //=====================================================
    ImageBufferChnl #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .COLUMN_NUM(COLUMN_NUM),
        .ROW_NUM(ROW_NUM),
        .STRIDE(STRIDE),
        .CHANNELS(INPUT_CHANNELS)
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
    // Convolution Channel Instantiation
    //=====================================================
    ConvolChnl #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .INPUT_CHANNELS(INPUT_CHANNELS),
        .OUTPUT_CHANNELS(OUTPUT_CHANNELS),
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_SIZE(FRACTION_SIZE),
        .SIGNED(SIGNED),
        .ACTIVATION(ACTIVATION),
        .GUARD_TYPE(GUARD_TYPE),
        .WEIGHT_FILE(WEIGHT_FILE),
        .BIAS_FILE(BIAS_FILE)
    ) ConvolChnl_inst (
        .clock(clock),
        .data_valid(kernel_valid_signal), // Trigger convolution when buffer ready
        .sreset_n(sreset_n),
        .kernel_in(kernel_window),
        .conv_out(conv_out),
        .conv_valid(conv_valid)
    );

endmodule
