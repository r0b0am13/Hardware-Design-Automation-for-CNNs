`timescale 1ns / 1ps

module DataConverter#(
    
    parameter INPUT_DATAWIDTH = 8,
    parameter INPUT_FRACTION_WIDTH = 0,
    parameter OUTPUT_DATAWIDTH = 16,
    parameter OUTPUT_FRACTION_WIDTH = 14,
    parameter INPUT_SIGNED  = 0,
    parameter OUTPUT_SIGNED = 1
    
    )(
    
    input [INPUT_DATAWIDTH-1:0] data_in,
    output [OUTPUT_DATAWIDTH-1:0] data_out
    );
    
    
    assign data_out = {{(OUTPUT_DATAWIDTH-OUTPUT_FRACTION_WIDTH){1'b0}},data_in,{(INPUT_DATAWIDTH-(OUTPUT_DATAWIDTH-OUTPUT_FRACTION_WIDTH)){1'b0}}};
endmodule
