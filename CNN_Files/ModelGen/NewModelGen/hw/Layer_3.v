// =============================================================
// Layer_3 — dense_L3, act=softmax, neurons=10
// =============================================================
module Layer_3 #(
    parameter NN = 10,
    parameter numWeight = 32,
    parameter dataWidth = 16,
    parameter layerNum = 3,
    parameter sigmoidSize = 10,
    parameter weightIntWidth = 2,
    parameter input_channels = 1,
    parameter actType = "softmax"
)(
    input           clk,
    input           rst,
    input           weightValid,
    input           biasValid,
    input  [31:0]   weightValue,
    input  [31:0]   biasValue,
    input  [31:0]   config_layer_num,
    input  [31:0]   config_neuron_num,
    input           x_valid,
    input  [input_channels*dataWidth-1:0] x_in,
    output [NN-1:0] o_valid,
    output [NN*dataWidth-1:0] x_out
);

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(0),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_0.mif"),
        .biasFile("b_3_0.mif")
    ) n_0 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[0*dataWidth +: dataWidth]),
        .outvalid(o_valid[0])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(1),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_1.mif"),
        .biasFile("b_3_1.mif")
    ) n_1 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[1*dataWidth +: dataWidth]),
        .outvalid(o_valid[1])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(2),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_2.mif"),
        .biasFile("b_3_2.mif")
    ) n_2 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[2*dataWidth +: dataWidth]),
        .outvalid(o_valid[2])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(3),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_3.mif"),
        .biasFile("b_3_3.mif")
    ) n_3 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[3*dataWidth +: dataWidth]),
        .outvalid(o_valid[3])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(4),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_4.mif"),
        .biasFile("b_3_4.mif")
    ) n_4 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[4*dataWidth +: dataWidth]),
        .outvalid(o_valid[4])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(5),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_5.mif"),
        .biasFile("b_3_5.mif")
    ) n_5 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[5*dataWidth +: dataWidth]),
        .outvalid(o_valid[5])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(6),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_6.mif"),
        .biasFile("b_3_6.mif")
    ) n_6 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[6*dataWidth +: dataWidth]),
        .outvalid(o_valid[6])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(7),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_7.mif"),
        .biasFile("b_3_7.mif")
    ) n_7 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[7*dataWidth +: dataWidth]),
        .outvalid(o_valid[7])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(8),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_8.mif"),
        .biasFile("b_3_8.mif")
    ) n_8 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[8*dataWidth +: dataWidth]),
        .outvalid(o_valid[8])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(3),
        .neuronNo(9),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_3_9.mif"),
        .biasFile("b_3_9.mif")
    ) n_9 (
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[9*dataWidth +: dataWidth]),
        .outvalid(o_valid[9])
    );

endmodule