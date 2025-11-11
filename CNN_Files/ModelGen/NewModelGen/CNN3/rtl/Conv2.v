    // ------------------------------------------------------------
    // Conv2: Conv2D
    // ------------------------------------------------------------
    wire [2*DATA_WIDTH-1:0] Conv2_out;
    wire Conv2_valid;

    // param .KERNEL_SIZE => 3
    // param .COLUMN_NUM => 26
    // param .ROW_NUM => 26
    // param .STRIDE => 1
    // param .INPUT_CHANNELS => 2
    // param .OUTPUT_CHANNELS => 2
    // param .DATA_WIDTH => DATA_WIDTH
    // param .FRACTION_SIZE => FRACTION_SIZE
    // param .SIGNED => SIGNED
    // param .ACTIVATION => 1
    // param .GUARD_TYPE => GUARD_TYPE
    // param .WEIGHT_FILE => "c_2_w.mif"
    // param .BIAS_FILE => "c_2_b.mif"
    Conv2D #(
        .KERNEL_SIZE(3),
        .COLUMN_NUM(26),
        .ROW_NUM(26),
        .STRIDE(1),
        .INPUT_CHANNELS(2),
        .OUTPUT_CHANNELS(2),
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_SIZE(FRACTION_SIZE),
        .SIGNED(SIGNED),
        .ACTIVATION(1),
        .GUARD_TYPE(GUARD_TYPE),
        .WEIGHT_FILE("c_2_w.mif"),
        .BIAS_FILE("c_2_b.mif")
    ) Conv2 (
        .clock(clock),
        .sreset_n(sreset_n),
        .data_valid(Conv1_valid),
        .data_in(Conv1_out),
        .conv_out(Conv2_out),
        .conv_valid(Conv2_valid)
    );
