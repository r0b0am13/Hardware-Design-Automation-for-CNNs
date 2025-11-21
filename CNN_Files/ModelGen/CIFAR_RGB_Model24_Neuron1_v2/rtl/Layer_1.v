// =============================================================
// Layer_1 — dense_L1, act=relu, neurons=128
// =============================================================
module Layer_1 #(
    parameter NN = 128,
    parameter numWeight = 25,
    parameter dataWidth = 24,
    parameter layerNum = 1,
    parameter sigmoidSize = 10,
    parameter weightIntWidth = 8,
    parameter input_channels = 1,
    parameter actType = "relu"
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
        .layerNo(1),
        .neuronNo(0),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_0.mif"),
        .biasFile("b_1_0.mif")
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
        .layerNo(1),
        .neuronNo(1),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_1.mif"),
        .biasFile("b_1_1.mif")
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
        .layerNo(1),
        .neuronNo(2),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_2.mif"),
        .biasFile("b_1_2.mif")
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
        .layerNo(1),
        .neuronNo(3),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_3.mif"),
        .biasFile("b_1_3.mif")
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
        .layerNo(1),
        .neuronNo(4),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_4.mif"),
        .biasFile("b_1_4.mif")
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
        .layerNo(1),
        .neuronNo(5),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_5.mif"),
        .biasFile("b_1_5.mif")
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
        .layerNo(1),
        .neuronNo(6),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_6.mif"),
        .biasFile("b_1_6.mif")
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
        .layerNo(1),
        .neuronNo(7),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_7.mif"),
        .biasFile("b_1_7.mif")
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
        .layerNo(1),
        .neuronNo(8),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_8.mif"),
        .biasFile("b_1_8.mif")
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
        .layerNo(1),
        .neuronNo(9),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_9.mif"),
        .biasFile("b_1_9.mif")
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

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(10),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_10.mif"),
        .biasFile("b_1_10.mif")
    ) n_10 (
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
        .out(x_out[10*dataWidth +: dataWidth]),
        .outvalid(o_valid[10])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(11),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_11.mif"),
        .biasFile("b_1_11.mif")
    ) n_11 (
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
        .out(x_out[11*dataWidth +: dataWidth]),
        .outvalid(o_valid[11])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(12),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_12.mif"),
        .biasFile("b_1_12.mif")
    ) n_12 (
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
        .out(x_out[12*dataWidth +: dataWidth]),
        .outvalid(o_valid[12])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(13),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_13.mif"),
        .biasFile("b_1_13.mif")
    ) n_13 (
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
        .out(x_out[13*dataWidth +: dataWidth]),
        .outvalid(o_valid[13])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(14),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_14.mif"),
        .biasFile("b_1_14.mif")
    ) n_14 (
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
        .out(x_out[14*dataWidth +: dataWidth]),
        .outvalid(o_valid[14])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(15),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_15.mif"),
        .biasFile("b_1_15.mif")
    ) n_15 (
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
        .out(x_out[15*dataWidth +: dataWidth]),
        .outvalid(o_valid[15])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(16),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_16.mif"),
        .biasFile("b_1_16.mif")
    ) n_16 (
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
        .out(x_out[16*dataWidth +: dataWidth]),
        .outvalid(o_valid[16])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(17),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_17.mif"),
        .biasFile("b_1_17.mif")
    ) n_17 (
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
        .out(x_out[17*dataWidth +: dataWidth]),
        .outvalid(o_valid[17])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(18),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_18.mif"),
        .biasFile("b_1_18.mif")
    ) n_18 (
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
        .out(x_out[18*dataWidth +: dataWidth]),
        .outvalid(o_valid[18])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(19),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_19.mif"),
        .biasFile("b_1_19.mif")
    ) n_19 (
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
        .out(x_out[19*dataWidth +: dataWidth]),
        .outvalid(o_valid[19])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(20),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_20.mif"),
        .biasFile("b_1_20.mif")
    ) n_20 (
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
        .out(x_out[20*dataWidth +: dataWidth]),
        .outvalid(o_valid[20])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(21),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_21.mif"),
        .biasFile("b_1_21.mif")
    ) n_21 (
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
        .out(x_out[21*dataWidth +: dataWidth]),
        .outvalid(o_valid[21])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(22),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_22.mif"),
        .biasFile("b_1_22.mif")
    ) n_22 (
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
        .out(x_out[22*dataWidth +: dataWidth]),
        .outvalid(o_valid[22])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(23),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_23.mif"),
        .biasFile("b_1_23.mif")
    ) n_23 (
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
        .out(x_out[23*dataWidth +: dataWidth]),
        .outvalid(o_valid[23])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(24),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_24.mif"),
        .biasFile("b_1_24.mif")
    ) n_24 (
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
        .out(x_out[24*dataWidth +: dataWidth]),
        .outvalid(o_valid[24])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(25),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_25.mif"),
        .biasFile("b_1_25.mif")
    ) n_25 (
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
        .out(x_out[25*dataWidth +: dataWidth]),
        .outvalid(o_valid[25])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(26),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_26.mif"),
        .biasFile("b_1_26.mif")
    ) n_26 (
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
        .out(x_out[26*dataWidth +: dataWidth]),
        .outvalid(o_valid[26])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(27),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_27.mif"),
        .biasFile("b_1_27.mif")
    ) n_27 (
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
        .out(x_out[27*dataWidth +: dataWidth]),
        .outvalid(o_valid[27])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(28),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_28.mif"),
        .biasFile("b_1_28.mif")
    ) n_28 (
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
        .out(x_out[28*dataWidth +: dataWidth]),
        .outvalid(o_valid[28])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(29),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_29.mif"),
        .biasFile("b_1_29.mif")
    ) n_29 (
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
        .out(x_out[29*dataWidth +: dataWidth]),
        .outvalid(o_valid[29])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(30),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_30.mif"),
        .biasFile("b_1_30.mif")
    ) n_30 (
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
        .out(x_out[30*dataWidth +: dataWidth]),
        .outvalid(o_valid[30])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(31),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_31.mif"),
        .biasFile("b_1_31.mif")
    ) n_31 (
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
        .out(x_out[31*dataWidth +: dataWidth]),
        .outvalid(o_valid[31])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(32),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_32.mif"),
        .biasFile("b_1_32.mif")
    ) n_32 (
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
        .out(x_out[32*dataWidth +: dataWidth]),
        .outvalid(o_valid[32])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(33),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_33.mif"),
        .biasFile("b_1_33.mif")
    ) n_33 (
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
        .out(x_out[33*dataWidth +: dataWidth]),
        .outvalid(o_valid[33])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(34),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_34.mif"),
        .biasFile("b_1_34.mif")
    ) n_34 (
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
        .out(x_out[34*dataWidth +: dataWidth]),
        .outvalid(o_valid[34])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(35),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_35.mif"),
        .biasFile("b_1_35.mif")
    ) n_35 (
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
        .out(x_out[35*dataWidth +: dataWidth]),
        .outvalid(o_valid[35])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(36),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_36.mif"),
        .biasFile("b_1_36.mif")
    ) n_36 (
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
        .out(x_out[36*dataWidth +: dataWidth]),
        .outvalid(o_valid[36])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(37),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_37.mif"),
        .biasFile("b_1_37.mif")
    ) n_37 (
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
        .out(x_out[37*dataWidth +: dataWidth]),
        .outvalid(o_valid[37])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(38),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_38.mif"),
        .biasFile("b_1_38.mif")
    ) n_38 (
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
        .out(x_out[38*dataWidth +: dataWidth]),
        .outvalid(o_valid[38])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(39),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_39.mif"),
        .biasFile("b_1_39.mif")
    ) n_39 (
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
        .out(x_out[39*dataWidth +: dataWidth]),
        .outvalid(o_valid[39])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(40),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_40.mif"),
        .biasFile("b_1_40.mif")
    ) n_40 (
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
        .out(x_out[40*dataWidth +: dataWidth]),
        .outvalid(o_valid[40])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(41),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_41.mif"),
        .biasFile("b_1_41.mif")
    ) n_41 (
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
        .out(x_out[41*dataWidth +: dataWidth]),
        .outvalid(o_valid[41])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(42),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_42.mif"),
        .biasFile("b_1_42.mif")
    ) n_42 (
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
        .out(x_out[42*dataWidth +: dataWidth]),
        .outvalid(o_valid[42])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(43),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_43.mif"),
        .biasFile("b_1_43.mif")
    ) n_43 (
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
        .out(x_out[43*dataWidth +: dataWidth]),
        .outvalid(o_valid[43])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(44),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_44.mif"),
        .biasFile("b_1_44.mif")
    ) n_44 (
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
        .out(x_out[44*dataWidth +: dataWidth]),
        .outvalid(o_valid[44])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(45),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_45.mif"),
        .biasFile("b_1_45.mif")
    ) n_45 (
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
        .out(x_out[45*dataWidth +: dataWidth]),
        .outvalid(o_valid[45])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(46),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_46.mif"),
        .biasFile("b_1_46.mif")
    ) n_46 (
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
        .out(x_out[46*dataWidth +: dataWidth]),
        .outvalid(o_valid[46])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(47),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_47.mif"),
        .biasFile("b_1_47.mif")
    ) n_47 (
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
        .out(x_out[47*dataWidth +: dataWidth]),
        .outvalid(o_valid[47])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(48),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_48.mif"),
        .biasFile("b_1_48.mif")
    ) n_48 (
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
        .out(x_out[48*dataWidth +: dataWidth]),
        .outvalid(o_valid[48])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(49),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_49.mif"),
        .biasFile("b_1_49.mif")
    ) n_49 (
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
        .out(x_out[49*dataWidth +: dataWidth]),
        .outvalid(o_valid[49])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(50),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_50.mif"),
        .biasFile("b_1_50.mif")
    ) n_50 (
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
        .out(x_out[50*dataWidth +: dataWidth]),
        .outvalid(o_valid[50])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(51),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_51.mif"),
        .biasFile("b_1_51.mif")
    ) n_51 (
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
        .out(x_out[51*dataWidth +: dataWidth]),
        .outvalid(o_valid[51])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(52),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_52.mif"),
        .biasFile("b_1_52.mif")
    ) n_52 (
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
        .out(x_out[52*dataWidth +: dataWidth]),
        .outvalid(o_valid[52])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(53),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_53.mif"),
        .biasFile("b_1_53.mif")
    ) n_53 (
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
        .out(x_out[53*dataWidth +: dataWidth]),
        .outvalid(o_valid[53])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(54),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_54.mif"),
        .biasFile("b_1_54.mif")
    ) n_54 (
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
        .out(x_out[54*dataWidth +: dataWidth]),
        .outvalid(o_valid[54])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(55),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_55.mif"),
        .biasFile("b_1_55.mif")
    ) n_55 (
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
        .out(x_out[55*dataWidth +: dataWidth]),
        .outvalid(o_valid[55])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(56),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_56.mif"),
        .biasFile("b_1_56.mif")
    ) n_56 (
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
        .out(x_out[56*dataWidth +: dataWidth]),
        .outvalid(o_valid[56])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(57),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_57.mif"),
        .biasFile("b_1_57.mif")
    ) n_57 (
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
        .out(x_out[57*dataWidth +: dataWidth]),
        .outvalid(o_valid[57])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(58),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_58.mif"),
        .biasFile("b_1_58.mif")
    ) n_58 (
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
        .out(x_out[58*dataWidth +: dataWidth]),
        .outvalid(o_valid[58])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(59),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_59.mif"),
        .biasFile("b_1_59.mif")
    ) n_59 (
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
        .out(x_out[59*dataWidth +: dataWidth]),
        .outvalid(o_valid[59])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(60),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_60.mif"),
        .biasFile("b_1_60.mif")
    ) n_60 (
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
        .out(x_out[60*dataWidth +: dataWidth]),
        .outvalid(o_valid[60])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(61),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_61.mif"),
        .biasFile("b_1_61.mif")
    ) n_61 (
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
        .out(x_out[61*dataWidth +: dataWidth]),
        .outvalid(o_valid[61])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(62),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_62.mif"),
        .biasFile("b_1_62.mif")
    ) n_62 (
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
        .out(x_out[62*dataWidth +: dataWidth]),
        .outvalid(o_valid[62])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(63),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_63.mif"),
        .biasFile("b_1_63.mif")
    ) n_63 (
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
        .out(x_out[63*dataWidth +: dataWidth]),
        .outvalid(o_valid[63])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(64),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_64.mif"),
        .biasFile("b_1_64.mif")
    ) n_64 (
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
        .out(x_out[64*dataWidth +: dataWidth]),
        .outvalid(o_valid[64])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(65),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_65.mif"),
        .biasFile("b_1_65.mif")
    ) n_65 (
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
        .out(x_out[65*dataWidth +: dataWidth]),
        .outvalid(o_valid[65])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(66),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_66.mif"),
        .biasFile("b_1_66.mif")
    ) n_66 (
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
        .out(x_out[66*dataWidth +: dataWidth]),
        .outvalid(o_valid[66])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(67),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_67.mif"),
        .biasFile("b_1_67.mif")
    ) n_67 (
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
        .out(x_out[67*dataWidth +: dataWidth]),
        .outvalid(o_valid[67])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(68),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_68.mif"),
        .biasFile("b_1_68.mif")
    ) n_68 (
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
        .out(x_out[68*dataWidth +: dataWidth]),
        .outvalid(o_valid[68])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(69),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_69.mif"),
        .biasFile("b_1_69.mif")
    ) n_69 (
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
        .out(x_out[69*dataWidth +: dataWidth]),
        .outvalid(o_valid[69])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(70),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_70.mif"),
        .biasFile("b_1_70.mif")
    ) n_70 (
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
        .out(x_out[70*dataWidth +: dataWidth]),
        .outvalid(o_valid[70])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(71),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_71.mif"),
        .biasFile("b_1_71.mif")
    ) n_71 (
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
        .out(x_out[71*dataWidth +: dataWidth]),
        .outvalid(o_valid[71])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(72),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_72.mif"),
        .biasFile("b_1_72.mif")
    ) n_72 (
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
        .out(x_out[72*dataWidth +: dataWidth]),
        .outvalid(o_valid[72])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(73),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_73.mif"),
        .biasFile("b_1_73.mif")
    ) n_73 (
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
        .out(x_out[73*dataWidth +: dataWidth]),
        .outvalid(o_valid[73])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(74),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_74.mif"),
        .biasFile("b_1_74.mif")
    ) n_74 (
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
        .out(x_out[74*dataWidth +: dataWidth]),
        .outvalid(o_valid[74])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(75),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_75.mif"),
        .biasFile("b_1_75.mif")
    ) n_75 (
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
        .out(x_out[75*dataWidth +: dataWidth]),
        .outvalid(o_valid[75])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(76),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_76.mif"),
        .biasFile("b_1_76.mif")
    ) n_76 (
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
        .out(x_out[76*dataWidth +: dataWidth]),
        .outvalid(o_valid[76])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(77),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_77.mif"),
        .biasFile("b_1_77.mif")
    ) n_77 (
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
        .out(x_out[77*dataWidth +: dataWidth]),
        .outvalid(o_valid[77])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(78),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_78.mif"),
        .biasFile("b_1_78.mif")
    ) n_78 (
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
        .out(x_out[78*dataWidth +: dataWidth]),
        .outvalid(o_valid[78])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(79),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_79.mif"),
        .biasFile("b_1_79.mif")
    ) n_79 (
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
        .out(x_out[79*dataWidth +: dataWidth]),
        .outvalid(o_valid[79])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(80),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_80.mif"),
        .biasFile("b_1_80.mif")
    ) n_80 (
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
        .out(x_out[80*dataWidth +: dataWidth]),
        .outvalid(o_valid[80])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(81),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_81.mif"),
        .biasFile("b_1_81.mif")
    ) n_81 (
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
        .out(x_out[81*dataWidth +: dataWidth]),
        .outvalid(o_valid[81])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(82),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_82.mif"),
        .biasFile("b_1_82.mif")
    ) n_82 (
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
        .out(x_out[82*dataWidth +: dataWidth]),
        .outvalid(o_valid[82])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(83),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_83.mif"),
        .biasFile("b_1_83.mif")
    ) n_83 (
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
        .out(x_out[83*dataWidth +: dataWidth]),
        .outvalid(o_valid[83])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(84),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_84.mif"),
        .biasFile("b_1_84.mif")
    ) n_84 (
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
        .out(x_out[84*dataWidth +: dataWidth]),
        .outvalid(o_valid[84])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(85),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_85.mif"),
        .biasFile("b_1_85.mif")
    ) n_85 (
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
        .out(x_out[85*dataWidth +: dataWidth]),
        .outvalid(o_valid[85])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(86),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_86.mif"),
        .biasFile("b_1_86.mif")
    ) n_86 (
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
        .out(x_out[86*dataWidth +: dataWidth]),
        .outvalid(o_valid[86])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(87),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_87.mif"),
        .biasFile("b_1_87.mif")
    ) n_87 (
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
        .out(x_out[87*dataWidth +: dataWidth]),
        .outvalid(o_valid[87])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(88),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_88.mif"),
        .biasFile("b_1_88.mif")
    ) n_88 (
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
        .out(x_out[88*dataWidth +: dataWidth]),
        .outvalid(o_valid[88])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(89),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_89.mif"),
        .biasFile("b_1_89.mif")
    ) n_89 (
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
        .out(x_out[89*dataWidth +: dataWidth]),
        .outvalid(o_valid[89])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(90),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_90.mif"),
        .biasFile("b_1_90.mif")
    ) n_90 (
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
        .out(x_out[90*dataWidth +: dataWidth]),
        .outvalid(o_valid[90])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(91),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_91.mif"),
        .biasFile("b_1_91.mif")
    ) n_91 (
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
        .out(x_out[91*dataWidth +: dataWidth]),
        .outvalid(o_valid[91])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(92),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_92.mif"),
        .biasFile("b_1_92.mif")
    ) n_92 (
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
        .out(x_out[92*dataWidth +: dataWidth]),
        .outvalid(o_valid[92])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(93),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_93.mif"),
        .biasFile("b_1_93.mif")
    ) n_93 (
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
        .out(x_out[93*dataWidth +: dataWidth]),
        .outvalid(o_valid[93])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(94),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_94.mif"),
        .biasFile("b_1_94.mif")
    ) n_94 (
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
        .out(x_out[94*dataWidth +: dataWidth]),
        .outvalid(o_valid[94])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(95),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_95.mif"),
        .biasFile("b_1_95.mif")
    ) n_95 (
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
        .out(x_out[95*dataWidth +: dataWidth]),
        .outvalid(o_valid[95])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(96),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_96.mif"),
        .biasFile("b_1_96.mif")
    ) n_96 (
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
        .out(x_out[96*dataWidth +: dataWidth]),
        .outvalid(o_valid[96])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(97),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_97.mif"),
        .biasFile("b_1_97.mif")
    ) n_97 (
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
        .out(x_out[97*dataWidth +: dataWidth]),
        .outvalid(o_valid[97])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(98),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_98.mif"),
        .biasFile("b_1_98.mif")
    ) n_98 (
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
        .out(x_out[98*dataWidth +: dataWidth]),
        .outvalid(o_valid[98])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(99),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_99.mif"),
        .biasFile("b_1_99.mif")
    ) n_99 (
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
        .out(x_out[99*dataWidth +: dataWidth]),
        .outvalid(o_valid[99])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(100),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_100.mif"),
        .biasFile("b_1_100.mif")
    ) n_100 (
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
        .out(x_out[100*dataWidth +: dataWidth]),
        .outvalid(o_valid[100])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(101),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_101.mif"),
        .biasFile("b_1_101.mif")
    ) n_101 (
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
        .out(x_out[101*dataWidth +: dataWidth]),
        .outvalid(o_valid[101])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(102),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_102.mif"),
        .biasFile("b_1_102.mif")
    ) n_102 (
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
        .out(x_out[102*dataWidth +: dataWidth]),
        .outvalid(o_valid[102])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(103),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_103.mif"),
        .biasFile("b_1_103.mif")
    ) n_103 (
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
        .out(x_out[103*dataWidth +: dataWidth]),
        .outvalid(o_valid[103])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(104),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_104.mif"),
        .biasFile("b_1_104.mif")
    ) n_104 (
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
        .out(x_out[104*dataWidth +: dataWidth]),
        .outvalid(o_valid[104])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(105),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_105.mif"),
        .biasFile("b_1_105.mif")
    ) n_105 (
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
        .out(x_out[105*dataWidth +: dataWidth]),
        .outvalid(o_valid[105])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(106),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_106.mif"),
        .biasFile("b_1_106.mif")
    ) n_106 (
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
        .out(x_out[106*dataWidth +: dataWidth]),
        .outvalid(o_valid[106])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(107),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_107.mif"),
        .biasFile("b_1_107.mif")
    ) n_107 (
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
        .out(x_out[107*dataWidth +: dataWidth]),
        .outvalid(o_valid[107])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(108),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_108.mif"),
        .biasFile("b_1_108.mif")
    ) n_108 (
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
        .out(x_out[108*dataWidth +: dataWidth]),
        .outvalid(o_valid[108])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(109),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_109.mif"),
        .biasFile("b_1_109.mif")
    ) n_109 (
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
        .out(x_out[109*dataWidth +: dataWidth]),
        .outvalid(o_valid[109])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(110),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_110.mif"),
        .biasFile("b_1_110.mif")
    ) n_110 (
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
        .out(x_out[110*dataWidth +: dataWidth]),
        .outvalid(o_valid[110])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(111),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_111.mif"),
        .biasFile("b_1_111.mif")
    ) n_111 (
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
        .out(x_out[111*dataWidth +: dataWidth]),
        .outvalid(o_valid[111])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(112),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_112.mif"),
        .biasFile("b_1_112.mif")
    ) n_112 (
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
        .out(x_out[112*dataWidth +: dataWidth]),
        .outvalid(o_valid[112])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(113),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_113.mif"),
        .biasFile("b_1_113.mif")
    ) n_113 (
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
        .out(x_out[113*dataWidth +: dataWidth]),
        .outvalid(o_valid[113])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(114),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_114.mif"),
        .biasFile("b_1_114.mif")
    ) n_114 (
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
        .out(x_out[114*dataWidth +: dataWidth]),
        .outvalid(o_valid[114])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(115),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_115.mif"),
        .biasFile("b_1_115.mif")
    ) n_115 (
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
        .out(x_out[115*dataWidth +: dataWidth]),
        .outvalid(o_valid[115])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(116),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_116.mif"),
        .biasFile("b_1_116.mif")
    ) n_116 (
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
        .out(x_out[116*dataWidth +: dataWidth]),
        .outvalid(o_valid[116])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(117),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_117.mif"),
        .biasFile("b_1_117.mif")
    ) n_117 (
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
        .out(x_out[117*dataWidth +: dataWidth]),
        .outvalid(o_valid[117])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(118),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_118.mif"),
        .biasFile("b_1_118.mif")
    ) n_118 (
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
        .out(x_out[118*dataWidth +: dataWidth]),
        .outvalid(o_valid[118])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(119),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_119.mif"),
        .biasFile("b_1_119.mif")
    ) n_119 (
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
        .out(x_out[119*dataWidth +: dataWidth]),
        .outvalid(o_valid[119])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(120),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_120.mif"),
        .biasFile("b_1_120.mif")
    ) n_120 (
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
        .out(x_out[120*dataWidth +: dataWidth]),
        .outvalid(o_valid[120])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(121),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_121.mif"),
        .biasFile("b_1_121.mif")
    ) n_121 (
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
        .out(x_out[121*dataWidth +: dataWidth]),
        .outvalid(o_valid[121])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(122),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_122.mif"),
        .biasFile("b_1_122.mif")
    ) n_122 (
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
        .out(x_out[122*dataWidth +: dataWidth]),
        .outvalid(o_valid[122])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(123),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_123.mif"),
        .biasFile("b_1_123.mif")
    ) n_123 (
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
        .out(x_out[123*dataWidth +: dataWidth]),
        .outvalid(o_valid[123])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(124),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_124.mif"),
        .biasFile("b_1_124.mif")
    ) n_124 (
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
        .out(x_out[124*dataWidth +: dataWidth]),
        .outvalid(o_valid[124])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(125),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_125.mif"),
        .biasFile("b_1_125.mif")
    ) n_125 (
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
        .out(x_out[125*dataWidth +: dataWidth]),
        .outvalid(o_valid[125])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(126),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_126.mif"),
        .biasFile("b_1_126.mif")
    ) n_126 (
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
        .out(x_out[126*dataWidth +: dataWidth]),
        .outvalid(o_valid[126])
    );

    neuron #(
        .input_channels(input_channels),
        .numWeight(numWeight),
        .layerNo(1),
        .neuronNo(127),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_1_127.mif"),
        .biasFile("b_1_127.mif")
    ) n_127 (
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
        .out(x_out[127*dataWidth +: dataWidth]),
        .outvalid(o_valid[127])
    );

endmodule