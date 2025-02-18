`timescale 1ns / 1ps

module pixel_buffer #(DATA_SIZE = 8)(clock, data_valid, pixel_in_data, pixel_out_data);

input clock,data_valid;
input [DATA_SIZE-1:0] pixel_in_data;
output reg [DATA_SIZE-1:0] pixel_out_data;

always @(posedge clock) 
    if(data_valid)
        pixel_out_data <= pixel_in_data;
endmodule
