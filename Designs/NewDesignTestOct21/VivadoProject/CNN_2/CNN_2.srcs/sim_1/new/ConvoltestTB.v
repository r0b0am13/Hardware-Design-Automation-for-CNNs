`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2025 12:39:31
// Design Name: 
// Module Name: ConvoltestTB
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


module ConvoltestTB();

parameter DATA_WIDTH    = 16;
parameter FRACTION_BITS = 14;
parameter KERNEL_SIZE   = 3;
parameter INPUTS        = 5;
parameter SIGNED_VAL    = 1;
parameter ACTIVATION    = 1;
parameter GUARD_TYPE    = 2;

reg clock;
reg sreset_n;
reg data_valid;
reg [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in;
reg [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] weights;
reg [DATA_WIDTH-1:0] bias;
wire [DATA_WIDTH-1:0] conv_out;
wire conv_valid;
    
Convolution #(
    .KERNEL_SIZE(KERNEL_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .FRACTION_SIZE(FRACTION_BITS),
    .SIGNED(SIGNED_VAL),
    .ACTIVATION(ACTIVATION),
    .GUARD_TYPE(GUARD_TYPE)
) dut (
    .clock(clock),
    .data_valid(data_valid),
    .sreset_n(sreset_n),
    .kernel_in(kernel_in),
    .weights(weights),
    .bias(bias),
    .conv_out(conv_out),
    .conv_valid(conv_valid)
);
   
reg [143:0] data_temp = 144'h040017001b00078037c0348029803b802a80; //0.125(9)
reg [143:0] weights_temp = 144'hfecc089404e701030eaf038cfd59fa1b015a; //0.5(9)
  
always #5 clock = ~clock;

initial begin

    clock = 0;
    sreset_n = 1;
    data_valid = 0;
    kernel_in = 0;
    bias = 16'h0000;
    weights = 0;
    
    #4
    sreset_n = 0;
    
    #10
    sreset_n = 1;
    
    @(negedge clock)
    data_valid = 1;
    kernel_in = data_temp;
    weights = weights_temp;
    bias = 16'hfc8e;
    #10
    data_valid = 0;
    weights = 0;
    kernel_in = 0;
    
    #60 $finish;

end
    
endmodule
