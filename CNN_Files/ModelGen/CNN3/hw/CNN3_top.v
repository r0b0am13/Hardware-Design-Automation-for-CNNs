// =============================================================
// Auto-generated CNN3_top (readable, JSON-driven)
// =============================================================
module CNN3_top #(
    parameter DATA_WIDTH = 16,
    parameter FRACTION_SIZE = 14,
    parameter SIGNED = 1,
    parameter GUARD_TYPE = 3
)(
    input wire clock,
    input wire sreset_n,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire data_valid,
    output wire [3:0] class_idx,
    output wire class_valid
);

    wire reset = ~sreset_n;

    // ------------------------------------------------------------
    // Conv1: Conv2D
    // ------------------------------------------------------------
    wire [1*DATA_WIDTH-1:0] Conv1_out;
    wire Conv1_valid;
    Conv2D #(
        .KERNEL_SIZE(3),
        .COLUMN_NUM(28),
        .ROW_NUM(28),
        .STRIDE(1),
        .INPUT_CHANNELS(1),
        .OUTPUT_CHANNELS(1),
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

    // ------------------------------------------------------------
    // Maxpool1: Max2D
    // ------------------------------------------------------------
    wire [1*DATA_WIDTH-1:0] Maxpool1_out;
    wire Maxpool1_valid;
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

    // ------------------------------------------------------------
    // Neural Network Layers (with IDLE/SEND FSMs between layers)
    // ------------------------------------------------------------
    localparam IDLE = 1'b0;
    localparam SEND = 1'b1;

    // ------------------------------------------------------------
    // Layer 1 — dense_L1 (RELU, 64 neurons)
    // ------------------------------------------------------------
    wire [63:0] o1_valid;
    wire [64*DATA_WIDTH-1:0] x1_out;
    reg  [64*DATA_WIDTH-1:0] holdData_1;
    reg  [DATA_WIDTH-1:0] out_data_1;
    reg  data_out_valid_1;

    Layer_1 #(
        .NN(64),
        .numWeight(169),
        .dataWidth(DATA_WIDTH),
        .layerNum(1),
        .sigmoidSize(10),
        .weightIntWidth(2),
        .input_channels(1),
        .actType("relu")
    ) L1 (
        .clk(clock),
        .rst(reset),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .x_valid(Maxpool1_valid),
        .x_in(Maxpool1_out),
        .o_valid(o1_valid),
        .x_out(x1_out)
    );

    reg state_1;
    integer count_1;
    always @(posedge clock) begin
        if (reset) begin
            state_1 <= IDLE;
            count_1 <= 0;
            data_out_valid_1 <= 0;
        end else begin
            case (state_1)
                IDLE: begin
                    count_1 <= 0;
                    data_out_valid_1 <= 0;
                    if (o1_valid[0] == 1'b1) begin
                        holdData_1 <= x1_out;
                        state_1 <= SEND;
                    end
                end
                SEND: begin
                    out_data_1 <= holdData_1[DATA_WIDTH-1:0];
                    holdData_1 <= holdData_1 >> DATA_WIDTH;
                    count_1 <= count_1 + 1;
                    data_out_valid_1 <= 1;
                    if (count_1 == 64) begin
                        state_1 <= IDLE;
                        data_out_valid_1 <= 0;
                    end
                end
            endcase
        end
    end

    // ------------------------------------------------------------
    // Layer 2 — dense_L2 (RELU, 32 neurons)
    // ------------------------------------------------------------
    wire [31:0] o2_valid;
    wire [32*DATA_WIDTH-1:0] x2_out;
    reg  [32*DATA_WIDTH-1:0] holdData_2;
    reg  [DATA_WIDTH-1:0] out_data_2;
    reg  data_out_valid_2;

    Layer_2 #(
        .NN(32),
        .numWeight(64),
        .dataWidth(DATA_WIDTH),
        .layerNum(2),
        .sigmoidSize(10),
        .weightIntWidth(2),
        .input_channels(1),
        .actType("relu")
    ) L2 (
        .clk(clock),
        .rst(reset),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .x_valid(data_out_valid_1),
        .x_in(out_data_1),
        .o_valid(o2_valid),
        .x_out(x2_out)
    );

    reg state_2;
    integer count_2;
    always @(posedge clock) begin
        if (reset) begin
            state_2 <= IDLE;
            count_2 <= 0;
            data_out_valid_2 <= 0;
        end else begin
            case (state_2)
                IDLE: begin
                    count_2 <= 0;
                    data_out_valid_2 <= 0;
                    if (o2_valid[0] == 1'b1) begin
                        holdData_2 <= x2_out;
                        state_2 <= SEND;
                    end
                end
                SEND: begin
                    out_data_2 <= holdData_2[DATA_WIDTH-1:0];
                    holdData_2 <= holdData_2 >> DATA_WIDTH;
                    count_2 <= count_2 + 1;
                    data_out_valid_2 <= 1;
                    if (count_2 == 32) begin
                        state_2 <= IDLE;
                        data_out_valid_2 <= 0;
                    end
                end
            endcase
        end
    end

    // ------------------------------------------------------------
    // Layer 3 — dense_L3 (SOFTMAX, 10 neurons)
    // ------------------------------------------------------------
    wire [9:0] o3_valid;
    wire [10*DATA_WIDTH-1:0] x3_out;
    reg  [10*DATA_WIDTH-1:0] holdData_3;
    reg  [DATA_WIDTH-1:0] out_data_3;
    reg  data_out_valid_3;

    Layer_3 #(
        .NN(10),
        .numWeight(32),
        .dataWidth(DATA_WIDTH),
        .layerNum(3),
        .sigmoidSize(10),
        .weightIntWidth(2),
        .input_channels(1),
        .actType("softmax")
    ) L3 (
        .clk(clock),
        .rst(reset),
        .weightValid(weightValid),
        .biasValid(biasValid),
        .weightValue(weightValue),
        .biasValue(biasValue),
        .config_layer_num(config_layer_num),
        .config_neuron_num(config_neuron_num),
        .x_valid(data_out_valid_2),
        .x_in(out_data_2),
        .o_valid(o3_valid),
        .x_out(x3_out)
    );

    reg state_3;
    integer count_3;
    always @(posedge clock) begin
        if (reset) begin
            state_3 <= IDLE;
            count_3 <= 0;
            data_out_valid_3 <= 0;
        end else begin
            case (state_3)
                IDLE: begin
                    count_3 <= 0;
                    data_out_valid_3 <= 0;
                    if (o3_valid[0] == 1'b1) begin
                        holdData_3 <= x3_out;
                        state_3 <= SEND;
                    end
                end
                SEND: begin
                    out_data_3 <= holdData_3[DATA_WIDTH-1:0];
                    holdData_3 <= holdData_3 >> DATA_WIDTH;
                    count_3 <= count_3 + 1;
                    data_out_valid_3 <= 1;
                    if (count_3 == 10) begin
                        state_3 <= IDLE;
                        data_out_valid_3 <= 0;
                    end
                end
            endcase
        end
    end

    // ------------------------------------------------------------
    // Final-layer packed hold + maxFinder
    // ------------------------------------------------------------
    reg [10*DATA_WIDTH-1:0] holdData_final;
    always @(posedge clock) begin
        if (o3_valid[0] == 1'b1)
            holdData_final <= x3_out;
    end

    maxFinder #(
        .NUM_INPUTS(10),
        .DATA_WIDTH(DATA_WIDTH),
        .SIGNED(SIGNED)
    ) mFind (
        .i_clk(clock),
        .i_data(x3_out),
        .i_valid(o3_valid),
        .o_data(class_idx),
        .o_data_valid(class_valid)
    );
endmodule