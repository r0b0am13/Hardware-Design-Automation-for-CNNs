`timescale 1ns / 1ps

module ConvolChnl#(

    parameter KERNEL_SIZE = 3,
    parameter INPUT_CHANNELS = 3,
    parameter OUTPUT_CHANNELS = 2,
    parameter WEIGHT_FILE = "c0_weights.mif",
    parameter BIAS_FILE = "c0_bias.mif",
    parameter DATA_WIDTH  = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter ACTIVATION = 1,
    parameter GUARD_TYPE =  3// 0 - No guard (basically saturates at each stage
                             // 1 - Adder Guard (only saturates at mult stage and final adder stage) //Applicable only to SIC
                             // 2 - Adder + Mult Guard (saturates at the final of one channel only)  //Applicable only to SIC
                             // 3 - Full Guard (saturates at the end of the complete block) //Applicable SIC/MIC
    
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
    
    
    //Seperation/Joining (Wire-Only) Stage
    wire [KERNEL_SIZE*KERNEL_SIZE*INPUT_CHANNELS*DATA_WIDTH-1:0] WeightChannels [0:OUTPUT_CHANNELS-1];
    wire [DATA_WIDTH-1:0] BiasChannels [0:OUTPUT_CHANNELS-1];
    wire [DATA_WIDTH-1:0] ChannelOuts [0:OUTPUT_CHANNELS-1];
    wire [DATA_WIDTH-1:0] Channel_Valids [0:OUTPUT_CHANNELS-1];
    
    genvar i;
    
    generate
        //Seperation (Wire only) Layer
        for(i=0; i<OUTPUT_CHANNELS; i=i+1) begin
             assign WeightChannels[OUTPUT_CHANNELS-1-i] = Weights[(i+1)*INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1: i*INPUT_CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH];
             assign BiasChannels[OUTPUT_CHANNELS-1-i] = Biases[(i+1)*DATA_WIDTH-1: i*DATA_WIDTH];
        end
        //SIC Layer        
        for(i=0; i<OUTPUT_CHANNELS; i=i+1) begin
            Conv_MIC #(
                .KERNEL_SIZE(KERNEL_SIZE),          
                .INPUT_CHANNELS(INPUT_CHANNELS),       
                .DATA_WIDTH(DATA_WIDTH),          
                .FRACTION_SIZE(FRACTION_SIZE),       
                .SIGNED(SIGNED),               
                .ACTIVATION(ACTIVATION),           
                .GUARD_TYPE(GUARD_TYPE)            
            ) Conv_MIC_inst (
                .clock(clock),                 
                .data_valid(data_valid),            
                .sreset_n(sreset_n),              
                .kernel_in(kernel_in),             
                .bias(BiasChannels[i]),                  
                .weights(WeightChannels[i]),               
                .conv_out(ChannelOuts[i]),              
                .conv_valid(Channel_Valids[i])             
            );
        end
        //Joining Layer
        for(i=0; i<OUTPUT_CHANNELS; i=i+1) begin
             assign conv_out[(i+1)*DATA_WIDTH-1: i*DATA_WIDTH] = ChannelOuts[OUTPUT_CHANNELS-1-i];
        end
        assign conv_valid = Channel_Valids[0];
    endgenerate
      
endmodule
