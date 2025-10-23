`timescale 1ns / 1ps

module Data_Buffer #(
    parameter DATA_WIDTH = 16
)(
    input  wire                   clock,
    input  wire                   sreset_n,
    input  wire                   data_valid,
    input  wire [DATA_WIDTH-1:0]  data_in,
    output reg  [DATA_WIDTH-1:0]  data_out
);

    always @(posedge clock) begin
        if (!sreset_n)
            data_out <= 0;
        else if (data_valid)
            data_out <= data_in;
    end

endmodule