`timescale 1ns / 1ps

module Data_Buffer 
    #(
    DATA_WIDTH = 16
    )
    (
    input clock,sreset_n,
    input  data_valid,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out);


always @(posedge clock) 
    if(!sreset_n)
        data_out <= 0;
    else if(data_valid)
        data_out <= data_in;
endmodule
