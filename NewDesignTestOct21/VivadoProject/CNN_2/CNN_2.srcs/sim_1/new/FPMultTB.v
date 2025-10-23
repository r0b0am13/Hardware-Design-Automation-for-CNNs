`timescale 1ns/1ps
module FPMultTB();

    // ===== Parameters =====
    localparam DATA_WIDTH = 16;
    localparam FRACTION_SIZE = 14;
    localparam SIGNED = 1;

    // ===== DUT Inputs =====
    reg [DATA_WIDTH-1:0] A, B;

    // ===== DUT Outputs =====
    wire [(2*DATA_WIDTH - 1):0] Y_guard;
    wire [DATA_WIDTH-1:0]       Y_sat;

    // ===== DUT Instantiations =====
    FP_Multiplier #(
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_SIZE(FRACTION_SIZE),
        .SIGNED(SIGNED),
        .GUARD(1)
    ) DUT_GUARD (
        .A(A),
        .B(B),
        .Y(Y_guard)
    );

    FP_Multiplier #(
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_SIZE(FRACTION_SIZE),
        .SIGNED(SIGNED),
        .GUARD(0)
    ) DUT_SAT (
        .A(A),
        .B(B),
        .Y(Y_sat)
    );

    // ===== Helper Tasks =====
    task display_results;
        real fa, fb, fy_guard, fy_sat;
        begin
            fa = $itor($signed(A)) / (1 << FRACTION_SIZE);
            fb = $itor($signed(B)) / (1 << FRACTION_SIZE);
            fy_guard = $itor($signed(Y_guard)) / (1 << (2*FRACTION_SIZE));
            fy_sat = $itor($signed(Y_sat)) / (1 << FRACTION_SIZE);
            $display("A=%f, B=%f | GUARD=%f | SATURATED=%f", fa, fb, fy_guard, fy_sat);
        end
    endtask

    // ===== Test Stimulus =====
    initial begin
        $display("\n--- Fixed-Point Multiplier Test ---");
        $display("DATA_WIDTH=%0d, FRACTION_SIZE=%0d, SIGNED=%0d\n",
                 DATA_WIDTH, FRACTION_SIZE, SIGNED);

        // Initialize
        A = 0; B = 0; #10;

        // Test 1: Simple positive multiplication (0.5 * 0.5)
        A = $rtoi(0.5 * (1 << FRACTION_SIZE));
        B = $rtoi(0.5 * (1 << FRACTION_SIZE));
        #10 display_results();

        // Test 2: Positive * Negative (-0.75 * 0.5)
        A = $rtoi(-0.75 * (1 << FRACTION_SIZE));
        B = $rtoi(0.5 * (1 << FRACTION_SIZE));
        #10 display_results();

        // Test 3: Negative * Negative (-0.75 * -0.75)
        A = $rtoi(-0.75 * (1 << FRACTION_SIZE));
        B = $rtoi(-0.75 * (1 << FRACTION_SIZE));
        #10 display_results();

        // Test 4: Large magnitude to test saturation
        A = $rtoi(3.0 * (1 << FRACTION_SIZE)); // beyond 1.9999 fixed range
        B = $rtoi(2.0 * (1 << FRACTION_SIZE));
        #10 display_results();

        // Test 5: Small numbers (0.1 * 0.2)
        A = $rtoi(0.1 * (1 << FRACTION_SIZE));
        B = $rtoi(0.2 * (1 << FRACTION_SIZE));
        #10 display_results();

        // Test 6: Edge case (max positive * max positive)
        A = {1'b0, {(DATA_WIDTH-1){1'b1}}};
        B = {1'b0, {(DATA_WIDTH-1){1'b1}}};
        #10 display_results();

        // Test 7: Edge case (min negative * min negative)
        A = {1'b1, {(DATA_WIDTH-1){1'b0}}};
        B = {1'b1, {(DATA_WIDTH-1){1'b0}}};
        #10 display_results();
        
        //Test 8 : One other test it is
        A = $rtoi(-0.5 * (1 << FRACTION_SIZE));
        B = $rtoi(-0.5 * (1 << FRACTION_SIZE));
        #10 display_results();
        //Test 9 : One other test it is
        A = $rtoi(0.25 * (1 << FRACTION_SIZE));
        B = $rtoi(0.25 * (1 << FRACTION_SIZE));
        #10 display_results();
        //Test 10 : One other test it is
        A = $rtoi(1.875 * (1 << FRACTION_SIZE));
        B = $rtoi(-1.875 * (1 << FRACTION_SIZE));
        #10 display_results();

        $display("\n--- Simulation complete ---");
        $finish;
    end

endmodule
