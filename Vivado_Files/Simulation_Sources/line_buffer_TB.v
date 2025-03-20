`timescale 1ns / 1ps
module line_buffer_TB();

localparam DATA_SIZE = 8,ROW_SIZE = 28,KERNEL_SIZE=3;
reg clock,data_valid;
reg [DATA_SIZE-1:0] data_in;
wire [DATA_SIZE-1:0] data_out;
wire [3*DATA_SIZE-1:0] kernel_row_out;

Line_Buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_SIZE(DATA_SIZE),.ROW_SIZE(ROW_SIZE)) lb (.clock(clock),.data_valid(data_in_valid),.data_in(data_in),.data_out(data_out),.kernel_row_out(kernel_row_out));
integer i = 0;
initial begin
clock = 0;
#6 data_valid = 1;
#4;
for (i=0; i<100; i = i+1) begin
data_in = i; #10;
end
$finish;
end

always
#5 clock = ~clock;

endmodule