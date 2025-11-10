`timescale 1ns / 1ps

module ConvolChnl#(

    parameter KERNEL_SIZE = 3,
    parameter INPUT_CHANNELS = 1,
    parameter OUTPUT_CHANNELS = 1,
    parameter WEIGHT_FILE = "c0_weights.mif",
    parameter BIAS_FILE = "c0_bias.mif",
    parameter DATA_WIDTH  = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter ACTIVATION = 1,
    parameter GUARD_TYPE = 2 // 0 - No guard (basically saturates at each stage
                             // 1 - Adder Guard (only saturates at mult stage and final adder stage)
                             // 2 - Adder + Mult Guard (saturates at the final stage only)
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    output wire [OUTPUT_CHANNELS*DATA_WIDTH-1:0]    conv_out,
    output wire                     conv_valid
    
    );

    wire [KERNEL_SIZE*KERNEL_SIZE*INPUT_CHANNELS*OUTPUT_CHANNELS*DATA_WIDTH-1:0] Weights;
    wire [OUTPUT_CHANNELS*DATA_WIDTH-1:0] Biases;
    
ConvMemory #(
    .KERNEL_SIZE(KERNEL_SIZE),
    .INPUT_CHANNELS(INPUT_CHANNELS),
    .OUTPUT_CHANNELS(OUTPUT_CHANNELS),
    .DATA_WIDTH(DATA_WIDTH),
    .WEIGHT_FILE(WEIGHT_FILE), 
    .BIAS_FILE(BIAS_FILE)       
) ConvMemory_inst (
    .Weights(Weights),
    .Biases(Biases)
);
    
endmodule
