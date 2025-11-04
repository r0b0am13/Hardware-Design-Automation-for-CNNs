module Layer_1 #(parameter NN = 30,numWeight=784,dataWidth=16,layerNum=1,sigmoidSize=10,weightIntWidth=4,actType="relu")
    (
    input           clk,
    input           rst,
    input           weightValid,
    input           biasValid,
    input [31:0]    weightValue,
    input [31:0]    biasValue,
    input [31:0]    config_neuron_num,
    input           x_valid,
    input [dataWidth-1:0]    x_in,
    output [NN-1:0]     o_valid,
    output [NN*dataWidth-1:0]  x_out
    );
neuronNew #(.numWeight(numWeight),.neuronNo(0),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_0.mif"),.biasFile("b_1_0.mif"))n_0(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[0*dataWidth+:dataWidth]),
        .outvalid(o_valid[0])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(1),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_1.mif"),.biasFile("b_1_1.mif"))n_1(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[1*dataWidth+:dataWidth]),
        .outvalid(o_valid[1])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(2),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_2.mif"),.biasFile("b_1_2.mif"))n_2(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[2*dataWidth+:dataWidth]),
        .outvalid(o_valid[2])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(3),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_3.mif"),.biasFile("b_1_3.mif"))n_3(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[3*dataWidth+:dataWidth]),
        .outvalid(o_valid[3])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(4),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_4.mif"),.biasFile("b_1_4.mif"))n_4(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[4*dataWidth+:dataWidth]),
        .outvalid(o_valid[4])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(5),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_5.mif"),.biasFile("b_1_5.mif"))n_5(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[5*dataWidth+:dataWidth]),
        .outvalid(o_valid[5])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(6),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_6.mif"),.biasFile("b_1_6.mif"))n_6(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[6*dataWidth+:dataWidth]),
        .outvalid(o_valid[6])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(7),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_7.mif"),.biasFile("b_1_7.mif"))n_7(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[7*dataWidth+:dataWidth]),
        .outvalid(o_valid[7])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(8),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_8.mif"),.biasFile("b_1_8.mif"))n_8(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[8*dataWidth+:dataWidth]),
        .outvalid(o_valid[8])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(9),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_9.mif"),.biasFile("b_1_9.mif"))n_9(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[9*dataWidth+:dataWidth]),
        .outvalid(o_valid[9])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(10),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_10.mif"),.biasFile("b_1_10.mif"))n_10(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[10*dataWidth+:dataWidth]),
        .outvalid(o_valid[10])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(11),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_11.mif"),.biasFile("b_1_11.mif"))n_11(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[11*dataWidth+:dataWidth]),
        .outvalid(o_valid[11])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(12),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_12.mif"),.biasFile("b_1_12.mif"))n_12(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[12*dataWidth+:dataWidth]),
        .outvalid(o_valid[12])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(13),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_13.mif"),.biasFile("b_1_13.mif"))n_13(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[13*dataWidth+:dataWidth]),
        .outvalid(o_valid[13])
        );
neuronNew #(.numWeight(numWeight),.neuronNo(14),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.actType(actType),.weightFile("w_1_14.mif"),.biasFile("b_1_14.mif"))n_14(
        .clk(clk),
        .rst(rst),
        .myinput(x_in),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_neuron_num(config_neuron_num),
        .myinputValid(x_valid),
        .out(x_out[14*dataWidth+:dataWidth]),
        .outvalid(o_valid[14])
        );
endmodule