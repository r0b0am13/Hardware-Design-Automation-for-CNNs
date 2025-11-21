`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2025 11:03:26
// Design Name: 
// Module Name: FP_Comparator
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


module FP_Comparator#( //returns bigger values
    
    parameter DATA_WIDTH  = 16,
    parameter SIGNED = 1
    
    )(
    
    input  wire [DATA_WIDTH-1:0]    A,
    input  wire [DATA_WIDTH-1:0]    B,
    output wire [DATA_WIDTH-1:0]    Y
    
    );
    
    generate
        if(SIGNED==1) begin
            assign Y = ($signed(A) > $signed(B)) ? A : B;
        end
        else begin
            assign Y = (A > B) ? A : B;
        end
    endgenerate
    
endmodule
