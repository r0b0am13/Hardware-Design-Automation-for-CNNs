`timescale 1ns / 1ps

module image_buffer_TB();

localparam DATA_SIZE = 8,ROW_SIZE = 28,KERNEL_SIZE=4;
reg clock,data_in_valid;
reg [DATA_SIZE-1:0] pixel_data_in;
wire [KERNEL_SIZE*KERNEL_SIZE*DATA_SIZE-1:0] convol_out;
wire out_valid;

image_buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_SIZE(DATA_SIZE),.ROW_SIZE(ROW_SIZE)) ib_tb (clock, pixel_data_in,convol_out,out_valid,data_in_valid);

integer i = 0;
initial begin
clock = 0;
#2 data_in_valid = 1;
for (i=0; i<100; i = i+1) begin
pixel_data_in = i; #10;
end
data_in_valid = 0;#50;
#2 data_in_valid =1;
for (i=0; i<100; i = i+1) begin
pixel_data_in = i; #10;
end
$finish;
end

always
#5 clock = ~clock;

endmodule