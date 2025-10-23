`timescale 1ns / 1ps


module ImageBuf_KernelSlider#(
    parameter KERNEL_SIZE = 3,
    parameter DATA_WIDTH  = 8,
    parameter COLUMN_NUM    = 5,
    parameter ROW_NUM = 5,
    parameter STRIDE = 1
    
    )(
    
    input  wire                     clock,
    input  wire                     data_valid,
    input  wire                     sreset_n,
    input  wire [DATA_WIDTH-1:0]    data_in,
    output wire [DATA_WIDTH-1:0]    data_out,
    output wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out,
    output wire                     kernel_valid
    
    );
    //structure logic
    genvar i,j;
    wire [DATA_WIDTH-1:0] LineBuffConnect [0:KERNEL_SIZE-1];
    wire [KERNEL_SIZE*DATA_WIDTH-1:0] KernelRows [0:KERNEL_SIZE-1]; 
    
    assign data_out = LineBuffConnect[KERNEL_SIZE-1]; 
    generate
        for (i = 0; i < KERNEL_SIZE; i = i + 1) begin : LINE_BUFFERS
            Line_Buffer #(
                .KERNEL_SIZE(KERNEL_SIZE),
                .DATA_WIDTH(DATA_WIDTH),
                .LENGTH(i== (KERNEL_SIZE-1) ? KERNEL_SIZE : COLUMN_NUM)
            ) Line_Buffer_inst (
                .clock(clock),
                .data_valid(data_valid),
                .sreset_n(sreset_n),
                .data_in(i == 0 ? data_in : LineBuffConnect[i-1]),
                .data_out(LineBuffConnect[i]),
                .kernel_row_out(KernelRows[i])
            );
        end

        for (i = 0; i < KERNEL_SIZE; i = i + 1) begin : KERNEL_OUTPUT
            assign kernel_out[(i+1)*DATA_WIDTH*KERNEL_SIZE-1 : i*DATA_WIDTH*KERNEL_SIZE] = KernelRows[i];
        end
    endgenerate
    
    //VALID LOGIC
    //row and column counters setup
    localparam ROW_BITS = $clog2(COLUMN_NUM);
    localparam COLUMN_BITS = $clog2(ROW_NUM);
    
    reg [COLUMN_BITS-1:0] column_counter;
    reg [ROW_BITS-1:0] row_counter;
    
    always @(posedge clock) begin
        if (!sreset_n) begin
            row_counter <= 0;
            column_counter <= 0;
        end
        else if (data_valid) begin
            if(column_counter >= COLUMN_NUM-1) begin
                column_counter <= 0;
                if(row_counter >= ROW_NUM-1) begin
                    row_counter <=0;
                end
                else begin
                    row_counter <= row_counter + 1;
                end
            end
            else begin
                column_counter <= column_counter + 1;
            end
        end    
    end
    
    //valid logic wiring
    reg kernel_valid_reg;
    assign kernel_valid = kernel_valid_reg;
    
    localparam STRIDE_BITS = $clog2(STRIDE);
    reg [STRIDE_BITS-1:0] row_stride_counter;
    reg [STRIDE_BITS-1:0] col_stride_counter;
    
    always @(posedge clock) begin
        if (!sreset_n) begin
            row_stride_counter <= 0;
            col_stride_counter <= 0;
            kernel_valid_reg   <= 0;
        end
        else if (data_valid) begin
            if (row_counter >= KERNEL_SIZE-1 && column_counter >= KERNEL_SIZE-1) begin
                if (row_stride_counter == 0 && col_stride_counter == 0) begin
                    kernel_valid_reg <= 1;
                end
                else begin
                    kernel_valid_reg <= 0;
                end
    
                //col_stride
                if (col_stride_counter == STRIDE-1 || column_counter == COLUMN_NUM-1) begin
                    col_stride_counter <= 0;
                end
                else begin
                    col_stride_counter <= col_stride_counter + 1;
                end
                //row_strde
                if (column_counter == COLUMN_NUM-1) begin
                    if (row_stride_counter == STRIDE-1 || row_counter == ROW_NUM-1 )
                        row_stride_counter <= 0;
                    else
                        row_stride_counter <= row_stride_counter + 1;
                end
            end
            else
                kernel_valid_reg <= 0;
        end
        else
            kernel_valid_reg <= 0;
    end
    
   
endmodule
