`timescale 1ns / 1ps
module line_buffer_TB();

localparam DATA_SIZE = 8,ROW_SIZE = 28,KERNEL_SIZE=3;
reg clock,data_valid;
reg [DATA_SIZE-1:0] pixel_in;
wire [DATA_SIZE-1:0] pixel_out;
wire [3*DATA_SIZE-1:0] conv_row_out;

line_buffer #(KERNEL_SIZE,DATA_SIZE,ROW_SIZE) lb_tb (clock,data_valid,pixel_in,pixel_out,conv_row_out);
integer i = 0;
initial begin
clock = 0;
#6 data_valid = 1;
#4;
for (i=0; i<100; i = i+1) begin
pixel_in = i; #10;
end
$finish;
end

always
#5 clock = ~clock;

endmodule