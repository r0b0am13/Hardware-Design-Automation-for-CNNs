`timescale 1ns / 1ps

module ImageBufferChnl#(
    parameter KERNEL_SIZE = 3,
    parameter DATA_WIDTH  = 8,
    parameter COLUMN_NUM    = 5,
    parameter ROW_NUM = 5,
    parameter STRIDE = 1,
    parameter CHANNELS = 2
    
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [CHANNELS*DATA_WIDTH-1:0]    data_in,
    output wire [CHANNELS*DATA_WIDTH-1:0]    data_out,
    output wire [CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out,
    output wire                     kernel_valid
    
    );
    
    
   
    wire [DATA_WIDTH-1:0] SeperateInChannels [0:CHANNELS-1];
    wire [DATA_WIDTH-1:0] SeperateOutChannels [0:CHANNELS-1];
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] SeperateKernels [0:CHANNELS-1];
   
    //Seperation and Combination Layer
    genvar i;
    generate
        for(i=0; i<CHANNELS; i=i+1) begin
            assign SeperateInChannels[CHANNELS-i-1] = data_in[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH];
            assign data_out[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = SeperateOutChannels[CHANNELS-i-1];
            assign kernel_out[(i+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 : i*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH] = SeperateKernels[CHANNELS-i-1];
            if(i==0) begin
                ImageBuf_KernelSlider #(
                    .KERNEL_SIZE (KERNEL_SIZE),
                    .DATA_WIDTH  (DATA_WIDTH),
                    .COLUMN_NUM  (COLUMN_NUM),
                    .ROW_NUM     (ROW_NUM),
                    .STRIDE      (STRIDE) 
                ) ChannelBuf (
                    .clock        (clock),
                    .data_valid   (data_valid),
                    .sreset_n     (sreset_n),
                    .data_in      (SeperateInChannels[i]),
                    .data_out     (SeperateOutChannels[i]),
                    .kernel_out   (SeperateKernels[i]),
                    .kernel_valid (kernel_valid)
                );
             end
             else begin
                ImageBuf_KernelSlider #(
                    .KERNEL_SIZE (KERNEL_SIZE),
                    .DATA_WIDTH  (DATA_WIDTH),
                    .COLUMN_NUM  (COLUMN_NUM),
                    .ROW_NUM     (ROW_NUM),
                    .STRIDE      (STRIDE) 
                ) ChannelBuf (
                    .clock        (clock),
                    .data_valid   (data_valid),
                    .sreset_n     (sreset_n),
                    .data_in      (SeperateInChannels[i]),
                    .data_out     (SeperateOutChannels[i]),
                    .kernel_out   (SeperateKernels[i]),
                    .kernel_valid ()
                );
            end
        end
    endgenerate
    
    
endmodule
