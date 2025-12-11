`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2025 14:59:10
// Design Name: 
// Module Name: Data_MIC_Converter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_MIC_Converter#(
    
    parameter INPUT_DATAWIDTH = 8,
    parameter INPUT_FRACTION_WIDTH = 0,
    parameter OUTPUT_DATAWIDTH = 16,
    parameter OUTPUT_FRACTION_WIDTH = 14,
    parameter INPUT_SIGNED = 0,
    parameter OUTPUT_SIGNED = 1,
    parameter CHANNELS = 1
    
    )(
    
    input [CHANNELS*INPUT_DATAWIDTH-1:0] data_in,
    output [CHANNELS*OUTPUT_DATAWIDTH-1:0] data_out
    );
    
    genvar i;
    generate
        for(i=0; i<CHANNELS; i=i+1) begin :data_converter_loop
            DataConverter #(
                .INPUT_DATAWIDTH       (INPUT_DATAWIDTH),        // e.g., 8
                .INPUT_FRACTION_WIDTH  (INPUT_FRACTION_WIDTH),   // e.g., 0
                .OUTPUT_DATAWIDTH      (OUTPUT_DATAWIDTH),       // e.g., 16  (CNN DATA_WIDTH)
                .OUTPUT_FRACTION_WIDTH (OUTPUT_FRACTION_WIDTH),  // e.g., 14  (CNN FRACTION_SIZE)
                .INPUT_SIGNED          (INPUT_SIGNED),           // e.g., 0
                .OUTPUT_SIGNED         (OUTPUT_SIGNED)           // e.g., 1
            ) data_converter_inst (
                .data_in   (data_in[(i+1)*INPUT_DATAWIDTH-1:i*INPUT_DATAWIDTH]),   // [INPUT_DATAWIDTH-1:0]
                .data_out  (data_out[(i+1)*OUTPUT_DATAWIDTH-1:i*OUTPUT_DATAWIDTH])    // [OUTPUT_DATAWIDTH-1:0]
            );
       end
    endgenerate 
    
    
endmodule
