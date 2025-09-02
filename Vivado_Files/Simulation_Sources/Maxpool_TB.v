`timescale 1ns / 1ps

module maxpool_tb();

    // Parameters
    localparam STRIDE_SIZE   = 2;
    localparam DATA_WIDTH    = 16;
    localparam FRACTION_BITS = 14;
    localparam ROW_SIZE      = 4;
    localparam COLUMN_SIZE   = 4;
    localparam CLK_PERIOD    = 10;

    // DUT signals
    reg clock, sreset_n, data_in_valid;
    reg signed [STRIDE_SIZE*STRIDE_SIZE*DATA_WIDTH-1:0] data_in;
    wire signed [DATA_WIDTH-1:0] maxpool_out;
    wire out_valid;

    // Instantiate DUT
    Maxpool #(
        .STRIDE_SIZE(STRIDE_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_BITS(FRACTION_BITS),
        .SIGNED(1),
        .ROW_SIZE(ROW_SIZE),
        .COLUMN_SIZE(COLUMN_SIZE)
    ) dut (
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .clock(clock),
        .sreset_n(sreset_n),
        .maxpool_out(maxpool_out),
        .out_valid(out_valid)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clock = ~clock;

    integer i;

    initial begin
        clock = 0;
        sreset_n = 0;
        data_in_valid = 0;
        data_in = 0;

        // Release reset
        #(2*CLK_PERIOD);
        sreset_n = 1;

        // Send values 1 to 15 (Q2.14 scaling: << FRACTION_BITS)
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clock);
            data_in_valid = 1;
            data_in = i;
            
           
        end

        @(posedge clock);
        data_in_valid = 0;

        #(10*CLK_PERIOD);
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | out_valid=%b | maxpool_out=%0d (Q2.14)",
                  $time, out_valid, maxpool_out);
    end

endmodule