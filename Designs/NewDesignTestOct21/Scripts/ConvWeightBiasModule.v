`timescale 1ns / 1ps

module ConvWeightBiasModule #(
    parameter KERNEL_SIZE = 3,
    parameter DATA_WIDTH  = 16
    )(
    output wire [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] Weights,
    output wire [DATA_WIDTH-1:0] Bias
    );

    wire [DATA_WIDTH-1:0] WeightsP [0:KERNEL_SIZE*KERNEL_SIZE-1];

    assign Bias = 16'b1111110010001110; // -0.05383880436420441

    // Weights assignments (Q2.16)
    assign WeightsP[0] = 16'b1111111011001100; // -0.018792975693941116
    assign WeightsP[1] = 16'b0000100010010100; // 0.13401438295841217
    assign WeightsP[2] = 16'b0000010011100111; // 0.07660023123025894
    assign WeightsP[3] = 16'b0000000100000011; // 0.015801195055246353
    assign WeightsP[4] = 16'b0000111010101111; // 0.2294103354215622
    assign WeightsP[5] = 16'b0000001110001100; // 0.05543012171983719
    assign WeightsP[6] = 16'b1111110101011001; // -0.04141935706138611
    assign WeightsP[7] = 16'b1111101000011011; // -0.09211386740207672
    assign WeightsP[8] = 16'b0000000101011010; // 0.021141696721315384

    genvar i;
    generate
        for(i = 0; i < KERNEL_SIZE*KERNEL_SIZE; i = i + 1) begin
            assign Weights[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = WeightsP[KERNEL_SIZE*KERNEL_SIZE-1-i];
        end
    endgenerate

endmodule
