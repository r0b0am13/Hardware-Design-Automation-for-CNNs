`timescale 1ns / 1ps

module pixel_buffer_TB();

localparam DATA_SIZE = 8;
reg clock, data_valid;
reg [DATA_SIZE-1:0] data_in;
wire [DATA_SIZE-1:0] data_out;

Data_Buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.data_in(data_in),.data_out(data_out));

integer i = 0;
initial begin
clock = 0;
#6 data_valid = 1;
#4;
for (i=0; i<10; i = i+1) begin
data_in = i; #10;
data_valid = ~data_valid;
end
$finish;
end

always
#5 clock = ~clock;

endmodule
