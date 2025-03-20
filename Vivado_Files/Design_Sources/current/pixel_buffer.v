`timescale 1ns / 1ps

module Data_Buffer 
    #(
    DATA_SIZE = 8
    )
    (
    input clock,
    input  data_valid,
    input [DATA_SIZE-1:0] data_in,
    output reg [DATA_SIZE-1:0] data_out);


always @(posedge clock) 
    if(data_valid)
        data_out <= data_in;
endmodule
