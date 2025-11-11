`timescale 1ns / 1ps

module Line_Buffer #(
    parameter KERNEL_SIZE = 3,
    parameter DATA_WIDTH  = 8,
    parameter LENGTH    = 5
)(
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [DATA_WIDTH-1:0]    data_in,
    output wire [DATA_WIDTH-1:0]    data_out,
    output wire [KERNEL_SIZE*DATA_WIDTH-1:0] kernel_row_out
);

    wire [DATA_WIDTH-1:0] wiring [0:LENGTH-1];

    assign data_out = wiring[LENGTH-1];
    
    genvar i;
    generate
        for (i = 0; i < LENGTH; i = i + 1) begin : BUFFER_CHAIN
            Data_Buffer #(.DATA_WIDTH(DATA_WIDTH)) pb (
                    .sreset_n(sreset_n),
                    .clock(clock),
                    .data_valid(data_valid),
                    .data_in((i == 0)? data_in : wiring[i-1]),
                    .data_out(wiring[i])
                );
        end

        for (i = 0; i < KERNEL_SIZE; i = i + 1) begin : KERNEL_OUTPUT
            assign kernel_row_out[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH] = wiring[i];
        end
    endgenerate

    

endmodule