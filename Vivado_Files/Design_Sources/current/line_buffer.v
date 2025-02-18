`timescale 1ns / 1ps

module line_buffer#(KERNEL_SIZE = 3,DATA_SIZE = 8,ROW_SIZE = 28)(clock,data_valid,pixel_in,pixel_out,conv_row_out);

input clock,data_valid;
input [DATA_SIZE-1:0] pixel_in;
output [DATA_SIZE-1:0] pixel_out;
output [KERNEL_SIZE*DATA_SIZE-1:0] conv_row_out;

wire [DATA_SIZE-1:0] wiring [0:ROW_SIZE-2];


genvar i;
generate 

for(i=0;i<ROW_SIZE;i=i+1) begin
    if(i==0) begin
        pixel_buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.pixel_in_data(pixel_in),.pixel_out_data(wiring[i]));
        end
    else if(i==ROW_SIZE-1) begin
        pixel_buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.pixel_in_data(wiring[i-1]),.pixel_out_data(pixel_out));
        end
    else
        pixel_buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.pixel_in_data(wiring[i-1]),.pixel_out_data(wiring[i]));
    end
for(i=0; i<KERNEL_SIZE;i = i+1) begin
    assign conv_row_out[(i+1)*DATA_SIZE-1:i*DATA_SIZE] = wiring[KERNEL_SIZE-i-1];
end

endgenerate



endmodule
