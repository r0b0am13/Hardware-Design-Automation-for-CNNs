// =============================================================
// Layer_2 — dense_L2, act=relu, neurons=32
// =============================================================
module Layer_2 #(
    parameter NN = 32,
    parameter numWeight = 64,
    parameter dataWidth = 32,
    parameter layerNum = 2,
    parameter sigmoidSize = 10,
    parameter weightIntWidth = 12,
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
        .layerNo(2),
        .neuronNo(0),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_0.mif"),
        .biasFile("b_2_0.mif")
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
        .layerNo(2),
        .neuronNo(1),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_1.mif"),
        .biasFile("b_2_1.mif")
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
        .layerNo(2),
        .neuronNo(2),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_2.mif"),
        .biasFile("b_2_2.mif")
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
        .layerNo(2),
        .neuronNo(3),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_3.mif"),
        .biasFile("b_2_3.mif")
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
        .layerNo(2),
        .neuronNo(4),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_4.mif"),
        .biasFile("b_2_4.mif")
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
        .layerNo(2),
        .neuronNo(5),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_5.mif"),
        .biasFile("b_2_5.mif")
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
        .layerNo(2),
        .neuronNo(6),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_6.mif"),
        .biasFile("b_2_6.mif")
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
        .layerNo(2),
        .neuronNo(7),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_7.mif"),
        .biasFile("b_2_7.mif")
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
        .layerNo(2),
        .neuronNo(8),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_8.mif"),
        .biasFile("b_2_8.mif")
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
        .layerNo(2),
        .neuronNo(9),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_9.mif"),
        .biasFile("b_2_9.mif")
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
        .layerNo(2),
        .neuronNo(10),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_10.mif"),
        .biasFile("b_2_10.mif")
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
        .layerNo(2),
        .neuronNo(11),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_11.mif"),
        .biasFile("b_2_11.mif")
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
        .layerNo(2),
        .neuronNo(12),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_12.mif"),
        .biasFile("b_2_12.mif")
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
        .layerNo(2),
        .neuronNo(13),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_13.mif"),
        .biasFile("b_2_13.mif")
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
        .layerNo(2),
        .neuronNo(14),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_14.mif"),
        .biasFile("b_2_14.mif")
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
        .layerNo(2),
        .neuronNo(15),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_15.mif"),
        .biasFile("b_2_15.mif")
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
        .layerNo(2),
        .neuronNo(16),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_16.mif"),
        .biasFile("b_2_16.mif")
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
        .layerNo(2),
        .neuronNo(17),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_17.mif"),
        .biasFile("b_2_17.mif")
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
        .layerNo(2),
        .neuronNo(18),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_18.mif"),
        .biasFile("b_2_18.mif")
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
        .layerNo(2),
        .neuronNo(19),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_19.mif"),
        .biasFile("b_2_19.mif")
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
        .layerNo(2),
        .neuronNo(20),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_20.mif"),
        .biasFile("b_2_20.mif")
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
        .layerNo(2),
        .neuronNo(21),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_21.mif"),
        .biasFile("b_2_21.mif")
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
        .layerNo(2),
        .neuronNo(22),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_22.mif"),
        .biasFile("b_2_22.mif")
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
        .layerNo(2),
        .neuronNo(23),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_23.mif"),
        .biasFile("b_2_23.mif")
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
        .layerNo(2),
        .neuronNo(24),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_24.mif"),
        .biasFile("b_2_24.mif")
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
        .layerNo(2),
        .neuronNo(25),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_25.mif"),
        .biasFile("b_2_25.mif")
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
        .layerNo(2),
        .neuronNo(26),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_26.mif"),
        .biasFile("b_2_26.mif")
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
        .layerNo(2),
        .neuronNo(27),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_27.mif"),
        .biasFile("b_2_27.mif")
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
        .layerNo(2),
        .neuronNo(28),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_28.mif"),
        .biasFile("b_2_28.mif")
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
        .layerNo(2),
        .neuronNo(29),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_29.mif"),
        .biasFile("b_2_29.mif")
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
        .layerNo(2),
        .neuronNo(30),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_30.mif"),
        .biasFile("b_2_30.mif")
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
        .layerNo(2),
        .neuronNo(31),
        .dataWidth(dataWidth),
        .sigmoidSize(sigmoidSize),
        .weightIntWidth(weightIntWidth),
        .actType(actType),
        .weightFile("w_2_31.mif"),
        .biasFile("b_2_31.mif")
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

endmodule