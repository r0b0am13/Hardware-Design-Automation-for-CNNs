`timescale 1ns / 1ps

module ConvolutionTB;

// -----------------------------------------------------------------------------
// Parameters
// -----------------------------------------------------------------------------
parameter DATA_WIDTH    = 16;
parameter FRACTION_BITS = 14;
parameter KERNEL_SIZE   = 3;
parameter INPUTS        = 5;
parameter SIGNED_VAL    = 1;
parameter ACTIVATION    = 1;
parameter GUARD_TYPE    = 2;

// -----------------------------------------------------------------------------
// DUT I/O
// -----------------------------------------------------------------------------
reg clock;
reg sreset_n;
reg data_valid;
reg [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_in;
reg [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] weights;
reg [DATA_WIDTH-1:0] bias;
wire [DATA_WIDTH-1:0] conv_out;
wire conv_valid;

// -----------------------------------------------------------------------------
// Fixed-point conversion functions (Verilog-2001)
// -----------------------------------------------------------------------------
function real fx_to_real;
    input signed [DATA_WIDTH-1:0] fx;
    begin
        fx_to_real = fx / (1.0 * (1 << FRACTION_BITS));
    end
endfunction

function signed [DATA_WIDTH-1:0] real_to_fx;
    input real val;
    begin
        real_to_fx = $rtoi(val * (1 << FRACTION_BITS));
    end
endfunction

// -----------------------------------------------------------------------------
// Absolute value helper
// -----------------------------------------------------------------------------
function real abs_real;
    input real x;
    begin
        if (x < 0.0) abs_real = -x;
        else abs_real = x;
    end
endfunction

// -----------------------------------------------------------------------------
// Instantiate DUT (your Convolution module)
// -----------------------------------------------------------------------------
Convolution #(
    .KERNEL_SIZE(KERNEL_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .FRACTION_SIZE(FRACTION_BITS),
    .SIGNED(SIGNED_VAL),
    .ACTIVATION(ACTIVATION),
    .GUARD_TYPE(GUARD_TYPE)
) dut (
    .clock(clock),
    .data_valid(data_valid),
    .sreset_n(sreset_n),
    .kernel_in(kernel_in),
    .weights(weights),
    .bias(bias),
    .conv_out(conv_out),
    .conv_valid(conv_valid)
);

// -----------------------------------------------------------------------------
// Clock generation
// -----------------------------------------------------------------------------
initial clock = 0;
always #5 clock = ~clock; // 100 MHz

// -----------------------------------------------------------------------------
// Stimulus storage & expected/result queues
// -----------------------------------------------------------------------------
reg signed [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] input_data [0:INPUTS-1];
reg signed [DATA_WIDTH-1:0]                    expected_q  [0:INPUTS-1];
reg signed [DATA_WIDTH-1:0]                    result_q    [0:INPUTS-1];

integer i, j;
integer exp_push_ptr; // next position to push expected value
integer exp_pop_ptr;  // next position to pop when conv_valid
integer stored_count; // number of expected values currently in queue

// -----------------------------------------------------------------------------
// Initialize weights and bias (constant across inputs)
// -----------------------------------------------------------------------------
initial begin
    for (j = 0; j < KERNEL_SIZE*KERNEL_SIZE; j = j + 1)
        weights[j*DATA_WIDTH +: DATA_WIDTH] = real_to_fx(0.05 * (j + 1));
    bias = real_to_fx(0.1);
end

// -----------------------------------------------------------------------------
// Software reference convolution (flattened input)
// -----------------------------------------------------------------------------
task software_conv;
    input  signed [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_flat;
    output signed [DATA_WIDTH-1:0] result;
    integer idx;
    reg signed [DATA_WIDTH-1:0] val, wt;
    real acc, temp;
begin
    acc = 0.0;
    for (idx = 0; idx < KERNEL_SIZE*KERNEL_SIZE; idx = idx + 1) begin
        val = kernel_flat[idx*DATA_WIDTH +: DATA_WIDTH];
        wt  = weights[idx*DATA_WIDTH +: DATA_WIDTH];
        temp = fx_to_real(val) * fx_to_real(wt);
        acc = acc + temp;
    end
    acc = acc + fx_to_real(bias);
    if (ACTIVATION && acc < 0.0) acc = 0.0;
    result = real_to_fx(acc);
end
endtask

// -----------------------------------------------------------------------------
// Test procedure
// -----------------------------------------------------------------------------
initial begin
    // initialize control
    sreset_n = 0;
    data_valid = 0;
    kernel_in = 0;
    exp_push_ptr = 0;
    exp_pop_ptr  = 0;
    stored_count = 0;

    #20 sreset_n = 1;
    #10;

    // Prepare random input kernels and expected outputs
    for (i = 0; i < INPUTS; i = i + 1) begin
        for (j = 0; j < KERNEL_SIZE*KERNEL_SIZE; j = j + 1) begin
            input_data[i][j*DATA_WIDTH +: DATA_WIDTH] =
                real_to_fx(($urandom_range(-100,100)) / 100.0);
        end
        software_conv(input_data[i], expected_q[i]); // store expected in array (will be queued when fed)
    end

    // Feed inputs sequentially, and push expected into queue as we feed
    for (i = 0; i < INPUTS; i = i + 1) begin
        @(posedge clock);
        kernel_in = input_data[i];
        data_valid = 1;

        // On the same cycle we feed data, push expected into queue
        expected_q[exp_push_ptr] = expected_q[i];
        exp_push_ptr = exp_push_ptr + 1;
        stored_count = stored_count + 1;

        @(posedge clock);
        data_valid = 0;
    end

    // After feeding, wait sufficient cycles for all results
    // (module latency depends on implementation; wait generously)
    repeat (20) @(posedge clock);

    $display("--------------------------------------------------------");
    $display(" Convolution Hardware vs Software Verification (Summary) ");
    $display("--------------------------------------------------------");

    // Print stored results captured during conv_valid handling (below)
    for (i = 0; i < exp_push_ptr; i = i + 1) begin
        $display("Input %0d | Expected: %f (fixed:%0d) | Result: %f (fixed:%0d)",
                 i,
                 fx_to_real(expected_q[i]), expected_q[i],
                 fx_to_real(result_q[i]), result_q[i]);
    end

    $finish;
end

// -----------------------------------------------------------------------------
// Capture DUT output when conv_valid asserts and compare with queued expected
// We pop earliest expected (exp_pop_ptr) and store DUT result in result_q[exp_pop_ptr].
// -----------------------------------------------------------------------------
always @(posedge clock) begin
    if (!sreset_n) begin
        exp_pop_ptr <= 0;
    end else begin
        if (conv_valid) begin
            // store result corresponding to oldest expected
            result_q[exp_pop_ptr] <= conv_out;
            // print comparison immediately (helps trace)
            $display("At time %0t: conv_valid asserted for input %0d", $time, exp_pop_ptr);
            $display("  Expected = %f (fixed: %0d)", fx_to_real(expected_q[exp_pop_ptr]), expected_q[exp_pop_ptr]);
            $display("  DUT out  = %f (fixed: %0d)", fx_to_real(conv_out), conv_out);
            if (abs_real(fx_to_real(expected_q[exp_pop_ptr]) - fx_to_real(conv_out)) > 0.002)
                $display("  >>>  MISMATCH for input %0d", exp_pop_ptr);
            else
                $display("  >>>  MATCH for input %0d", exp_pop_ptr);

            // advance pop pointer
            exp_pop_ptr <= exp_pop_ptr + 1;
            stored_count <= stored_count - 1;
        end
    end
end

endmodule
