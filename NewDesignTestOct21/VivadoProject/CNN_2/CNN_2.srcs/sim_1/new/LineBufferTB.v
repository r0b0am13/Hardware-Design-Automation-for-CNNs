`timescale 1ns / 1ps

module LineBufferTB;

    parameter KERNEL_SIZE = 3;
    parameter DATA_WIDTH  = 8;
    parameter ROW_SIZE    = 5;

    reg clock;
    reg data_valid;
    reg sreset_n;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire [KERNEL_SIZE*DATA_WIDTH-1:0] kernel_row_out;

    Line_Buffer #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .ROW_SIZE(ROW_SIZE)
    ) dut (
        .clock(clock),
        .data_valid(data_valid),
        .sreset_n(sreset_n),
        .data_in(data_in),
        .data_out(data_out),
        .kernel_row_out(kernel_row_out)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        sreset_n = 0;
        data_valid = 0;
        data_in = 0;
        #20 sreset_n = 1;
        #10 data_valid = 1;

        repeat (20) begin
            data_in = $random;
            #10;
        end

        data_valid = 0;
        #50;
        $finish;
    end

endmodule