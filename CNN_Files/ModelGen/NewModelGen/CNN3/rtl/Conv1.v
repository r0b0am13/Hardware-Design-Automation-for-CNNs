    // ------------------------------------------------------------
    // Conv1: Conv2D
    // ------------------------------------------------------------
    wire [2*DATA_WIDTH-1:0] Conv1_out;
    wire Conv1_valid;

    // param .KERNEL_SIZE => 3
    // param .COLUMN_NUM => 28
    // param .ROW_NUM => 28
    // param .STRIDE => 1
    // param .INPUT_CHANNELS => 3
    // param .OUTPUT_CHANNELS => 2
    // param .DATA_WIDTH => DATA_WIDTH
    // param .FRACTION_SIZE => FRACTION_SIZE
    // param .SIGNED => SIGNED
    // param .ACTIVATION => 1
    // param .GUARD_TYPE => GUARD_TYPE
    // param .WEIGHT_FILE => "c_1_w.mif"
    // param .BIAS_FILE => "c_1_b.mif"
    Conv2D #(
        .KERNEL_SIZE(3),
        .COLUMN_NUM(28),
        .ROW_NUM(28),
        .STRIDE(1),
        .INPUT_CHANNELS(3),
        .OUTPUT_CHANNELS(2),
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_SIZE(FRACTION_SIZE),
        .SIGNED(SIGNED),
        .ACTIVATION(1),
        .GUARD_TYPE(GUARD_TYPE),
        .WEIGHT_FILE("c_1_w.mif"),
        .BIAS_FILE("c_1_b.mif")
    ) Conv1 (
        .clock(clock),
        .sreset_n(sreset_n),
        .data_valid(data_valid),
        .data_in(data_in),
        .conv_out(Conv1_out),
        .conv_valid(Conv1_valid)
    );
