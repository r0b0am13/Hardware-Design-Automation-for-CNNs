`timescale 1ns / 1ps
module line_buffer_TB();

localparam DATA_WIDTH = 8,ROW_SIZE = 5,KERNEL_SIZE=3;
reg clock,data_valid,sreset_n;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire [3*DATA_WIDTH-1:0] kernel_row_out;

Line_Buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_WIDTH(DATA_WIDTH),.ROW_SIZE(ROW_SIZE)) lb (.sreset_n(sreset_n),.clock(clock),.data_valid(data_valid),.data_in(data_in),.data_out(data_out),.kernel_row_out(kernel_row_out));
integer i = 0;
initial begin
clock = 0;
sreset_n = 1;
#1 sreset_n = 0;
#5 data_valid = 1;
sreset_n = 1;
#4;
for (i=0; i<100; i = i+1) begin
data_in = i; #10;
end
$finish;
end

always
#5 clock = ~clock;

endmodule