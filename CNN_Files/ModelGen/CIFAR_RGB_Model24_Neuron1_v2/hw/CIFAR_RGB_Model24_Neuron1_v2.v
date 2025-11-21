// =============================================================
// Auto-generated wrapper for CIFAR_RGB_Model24_Neuron1_v2_top
// Includes Data_MIC_Converter to adapt external input format
// =============================================================
module CIFAR_RGB_Model24_Neuron1_v2 (
    input  wire clock,
    input  wire sreset_n,
    input  wire [23:0] data_in,
    input  wire data_valid,
    output wire [3:0] class_idx,
    output wire class_valid
);

    wire [71:0] cnn_input;

    // Data converter
    Data_MIC_Converter #(
        .INPUT_DATAWIDTH(8),
        .INPUT_FRACTION_WIDTH(0),
        .OUTPUT_DATAWIDTH(24),
        .OUTPUT_FRACTION_WIDTH(16),
        .INPUT_SIGNED(0),
        .OUTPUT_SIGNED(1),
        .CHANNELS(3)
    ) converter (
        .data_in(data_in),
        .data_out(cnn_input)
    );

    // CNN core
    CIFAR_RGB_Model24_Neuron1_v2_top core (
        .clock(clock),
        .sreset_n(sreset_n),
        .data_in(cnn_input),
        .data_valid(data_valid),
        .class_idx(class_idx),
        .class_valid(class_valid)
    );

endmodule