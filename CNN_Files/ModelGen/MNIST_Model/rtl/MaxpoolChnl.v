`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.11.2025 15:33:02
// Design Name: 
// Module Name: MaxpoolChnl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MaxpoolChnl#(
    parameter KERNEL_SIZE = 2,
    parameter DATA_WIDTH  = 16,
    parameter SIGNED = 1,
    parameter CHANNELS = 2
    
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [CHANNELS*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in,
    output wire [CHANNELS*DATA_WIDTH-1:0]    maxp_out,
    output wire                     maxp_valid
    
    );
    
    wire [DATA_WIDTH-1:0] SeperateOutChannels [0:CHANNELS-1];
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] SeperateKernels [0:CHANNELS-1];
    
    genvar i;
    generate
        for(i=0; i<CHANNELS; i=i+1) begin
            assign SeperateKernels[CHANNELS-i-1] = kernel_in[(i+1)*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1 : i*KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH];
            assign maxp_out[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = SeperateOutChannels[CHANNELS-i-1];
            if(i==0) begin
                Maxpool #(
                    .KERNEL_SIZE(KERNEL_SIZE),
                    .DATA_WIDTH(DATA_WIDTH),
                    .SIGNED(SIGNED)
                ) ChannelMaxpool (
                    .clock        (clock),
                    .data_valid   (data_valid),
                    .sreset_n     (sreset_n),
                    .kernel_in      (SeperateKernels[i]),
                    .maxp_out     (SeperateOutChannels[i]),
                    .maxp_valid (maxp_valid)
                );
            end
            else begin
                Maxpool #(
                    .KERNEL_SIZE(KERNEL_SIZE),
                    .DATA_WIDTH(DATA_WIDTH),
                    .SIGNED(SIGNED)
                ) ChannelMaxpool (
                    .clock        (clock),
                    .data_valid   (data_valid),
                    .sreset_n     (sreset_n),
                    .kernel_in      (SeperateKernels[i]),
                    .maxp_out     (SeperateOutChannels[i]),
                    .maxp_valid ()
                );
            end
        end
    endgenerate
endmodule
