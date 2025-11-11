    // ------------------------------------------------------------
    // Maxpool1: Max2D
    // ------------------------------------------------------------
    wire [2*DATA_WIDTH-1:0] Maxpool1_out;
    wire Maxpool1_valid;

    // param .KERNEL_SIZE => 2
    // param .DATA_WIDTH => DATA_WIDTH
    // param .COLUMN_NUM => 24
    // param .ROW_NUM => 24
    // param .STRIDE => 2
    // param .CHANNELS => 2
    // param .SIGNED => SIGNED
    Max2D #(
        .KERNEL_SIZE(2),
        .DATA_WIDTH(DATA_WIDTH),
        .COLUMN_NUM(24),
        .ROW_NUM(24),
        .STRIDE(2),
        .CHANNELS(2),
        .SIGNED(SIGNED)
    ) Maxpool1 (
        .clock(clock),
        .sreset_n(sreset_n),
        .data_valid(Conv2_valid),
        .data_in(Conv2_out),
        .maxp_out(Maxpool1_out),
        .maxp_valid(Maxpool1_valid)
    );
