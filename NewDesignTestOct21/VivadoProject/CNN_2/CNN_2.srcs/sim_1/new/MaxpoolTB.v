`timescale 1ns / 1ps

module MaxpoolTB;

    // -------------------------------------------------------------------------
    // Parameters
    // -------------------------------------------------------------------------
    parameter DATA_WIDTH    = 16;
    parameter FRACTION_BITS = 14;
    parameter SIGNED_PARAM  = 1;
    parameter KERNEL_SIZE   = 3;
    parameter INPUTS        = 5; // number of test vectors

    // -------------------------------------------------------------------------
    // DUT signals
    // -------------------------------------------------------------------------
    reg clock;
    reg sreset_n;
    reg data_valid;
    reg [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in;
    wire [DATA_WIDTH-1:0] maxp_out;
    wire maxp_valid;

    // -------------------------------------------------------------------------
    // Clock generation
    // -------------------------------------------------------------------------
    initial clock = 0;
    always #5 clock = ~clock; // 100 MHz

    // -------------------------------------------------------------------------
    // Flattened input & expected queues
    // -------------------------------------------------------------------------
    reg signed [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] input_data [0:INPUTS-1];
    reg signed [DATA_WIDTH-1:0] expected_q [0:INPUTS-1];
    reg signed [DATA_WIDTH-1:0] result_q   [0:INPUTS-1];

    integer i, j;
    integer exp_push_ptr;
    integer exp_pop_ptr;

    // -------------------------------------------------------------------------
    // Software max function
    // -------------------------------------------------------------------------
    function signed [DATA_WIDTH-1:0] software_max;
        input [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_flat;
        integer idx;
        reg signed [DATA_WIDTH-1:0] val;
        reg signed [DATA_WIDTH-1:0] max_val;
    begin
        max_val = kernel_flat[DATA_WIDTH-1:0];
        for(idx=1; idx<KERNEL_SIZE*KERNEL_SIZE; idx=idx+1) begin
            val = kernel_flat[idx*DATA_WIDTH +: DATA_WIDTH];
            if ($signed(val) > $signed(max_val))
                max_val = val;
        end
        software_max = max_val;
    end
    endfunction

    // -------------------------------------------------------------------------
    // Random input generation
    // -------------------------------------------------------------------------
    initial begin
        for(i=0; i<INPUTS; i=i+1) begin
            for(j=0; j<KERNEL_SIZE*KERNEL_SIZE; j=j+1) begin
                input_data[i][j*DATA_WIDTH +: DATA_WIDTH] = $random % 100 - 50;
            end
            expected_q[i] = software_max(input_data[i]);
        end
    end

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    Maxpool #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .SIGNED(SIGNED_PARAM)
    ) dut (
        .clock(clock),
        .data_valid(data_valid),
        .sreset_n(sreset_n),
        .kernel_in(kernel_in),
        .maxp_out(maxp_out),
        .maxp_valid(maxp_valid)
    );

    // -------------------------------------------------------------------------
    // Test procedure
    // -------------------------------------------------------------------------
    initial begin
        sreset_n = 0;
        data_valid = 0;
        kernel_in = 0;
        exp_push_ptr = 0;
        exp_pop_ptr  = 0;

        #20 sreset_n = 1;
        #10;

        // Feed inputs sequentially, push expected into queue
        for(i=0; i<INPUTS; i=i+1) begin
            @(posedge clock);
            kernel_in = input_data[i];
            data_valid = 1;

            expected_q[exp_push_ptr] = expected_q[i];
            exp_push_ptr = exp_push_ptr + 1;

            @(posedge clock);
            data_valid = 0;
        end

        // Wait enough cycles for pipeline to flush
        repeat(20) @(posedge clock);

        $display("--------------------------------------------------------");
        $display(" Maxpool Hardware vs Software Verification (Summary) ");
        $display("--------------------------------------------------------");

        for(i=0; i<exp_push_ptr; i=i+1) begin
            $display("Input %0d | Expected: %0d | Result: %0d",
                     i, expected_q[i], result_q[i]);
        end

        $finish;
    end

    // -------------------------------------------------------------------------
    // Capture DUT output when maxp_valid asserts
    // -------------------------------------------------------------------------
    always @(posedge clock) begin
        if (!sreset_n) begin
            exp_pop_ptr <= 0;
        end else begin
            if(maxp_valid) begin
                result_q[exp_pop_ptr] <= maxp_out;
                $display("At time %0t: maxp_valid asserted for input %0d | DUT out=%0d | Expected=%0d",
                         $time, exp_pop_ptr, maxp_out, expected_q[exp_pop_ptr]);
                exp_pop_ptr <= exp_pop_ptr + 1;
            end
        end
    end

endmodule
