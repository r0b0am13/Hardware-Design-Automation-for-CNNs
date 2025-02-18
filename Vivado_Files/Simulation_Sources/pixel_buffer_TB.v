`timescale 1ns / 1ps

module pixel_buffer_TB();

localparam DATA_SIZE = 8;
reg clock, data_valid;
reg [DATA_SIZE-1:0] pixel_in_data;
wire [DATA_SIZE-1:0] pixel_out_data;

pixel_buffer #(DATA_SIZE) pb_tb (clock, data_valid, pixel_in_data, pixel_out_data);

integer i = 0;
initial begin
clock = 0;
#6 data_valid = 1;
#4;
for (i=0; i<10; i = i+1) begin
pixel_in_data = i; #10;
data_valid = ~data_valid;
end
$finish;
end

always
#5 clock = ~clock;

endmodule
