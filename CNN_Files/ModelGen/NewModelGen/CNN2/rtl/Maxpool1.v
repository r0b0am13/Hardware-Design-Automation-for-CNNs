    // ------------------------------------------------------------
    // Maxpool1: Max2D
    // ------------------------------------------------------------
    wire [1*DATA_WIDTH-1:0] Maxpool1_out;
    wire Maxpool1_valid;

    // param .KERNEL_SIZE => 2
    // param .DATA_WIDTH => DATA_WIDTH
    // param .COLUMN_NUM => 26
    // param .ROW_NUM => 26
    // param .STRIDE => 2
    // param .CHANNELS => 1
    // param .SIGNED => SIGNED
    Max2D #(
        .KERNEL_SIZE(2),
        .DATA_WIDTH(DATA_WIDTH),
        .COLUMN_NUM(26),
        .ROW_NUM(26),
        .STRIDE(2),
        .CHANNELS(1),
        .SIGNED(SIGNED)
    ) Maxpool1 (
        .clock(clock),
        .sreset_n(sreset_n),
        .data_valid(Conv1_valid),
        .data_in(Conv1_out),
        .maxp_out(Maxpool1_out),
        .maxp_valid(Maxpool1_valid)
    );
