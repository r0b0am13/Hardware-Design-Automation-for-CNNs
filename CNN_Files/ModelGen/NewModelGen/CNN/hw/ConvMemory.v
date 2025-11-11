`timescale 1ns / 1ps

module ConvMemory#(
    
    parameter KERNEL_SIZE = 3,
    parameter INPUT_CHANNELS = 1,
    parameter OUTPUT_CHANNELS = 1,
    parameter DATA_WIDTH  = 16,
    parameter WEIGHT_FILE = "c0_weights.mif",
    parameter BIAS_FILE = "c0_bias.mif"
    )(
        output [KERNEL_SIZE*KERNEL_SIZE*INPUT_CHANNELS*OUTPUT_CHANNELS*DATA_WIDTH-1:0] Weights,
        output [OUTPUT_CHANNELS*DATA_WIDTH-1:0] Biases
    );
    
    reg [DATA_WIDTH-1:0] Weight_Regs [0:KERNEL_SIZE*KERNEL_SIZE*INPUT_CHANNELS*OUTPUT_CHANNELS-1];
    reg [DATA_WIDTH-1:0] Bias_Regs [0:OUTPUT_CHANNELS-1];
    
    initial begin
        $readmemb(WEIGHT_FILE,Weight_Regs);
        $readmemb(BIAS_FILE,Bias_Regs);
    end
    
    //how the outputs will be ordered
    //weights will be in the form weight1,weight2,weight3 etc weight1 being msb.
    //weights of first filter, and first input channel will be also msb
    //next would be weights of first filter, and second input channel etc etc.
    //slice accordinly while giving to the respective conv blocks.
    genvar i;
    generate
        for(i=0; i<KERNEL_SIZE*KERNEL_SIZE*INPUT_CHANNELS*OUTPUT_CHANNELS; i=i+1) begin
            assign Weights[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] = Weight_Regs[KERNEL_SIZE*KERNEL_SIZE*INPUT_CHANNELS*OUTPUT_CHANNELS-1-i];
        end
        for(i=0; i<OUTPUT_CHANNELS; i=i+1) begin
            assign Biases[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH] = Bias_Regs[OUTPUT_CHANNELS-1-i];
        end
    endgenerate
endmodule
