`timescale 1ns / 1ps

module DataBufferTB;

    parameter DATA_WIDTH = 16;

    reg clock;
    reg sreset_n;
    reg data_valid;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;

    Data_Buffer #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clock(clock),
        .sreset_n(sreset_n),
        .data_valid(data_valid),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        sreset_n = 0;
        data_valid = 0;
        data_in = 0;
        #15 sreset_n = 1;
        #10 data_valid = 1;

        repeat (10) begin
            data_in = $random;
            #10;
        end

        data_valid = 0;
        #20;
        $finish;
    end

endmodule
