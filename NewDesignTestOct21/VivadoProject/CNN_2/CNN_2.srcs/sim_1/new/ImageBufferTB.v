`timescale 1ns / 1ps

module ImageBuf_KernelSliderTB;

    // Parameters
    parameter KERNEL_SIZE = 2;
    parameter DATA_WIDTH  = 8;
    parameter ROW_NUM    = 26;
    parameter COLUMN_NUM = 26;
    parameter STRIDE_SIZE = 2;

    // DUT Ports
    reg clock;
    reg data_valid;
    reg sreset_n;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out;
    wire kernel_valid;

    // Instantiate DUT
    ImageBuf_KernelSlider #(
        .KERNEL_SIZE(KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .ROW_NUM(ROW_NUM),
        .COLUMN_NUM(COLUMN_NUM),
        .STRIDE(STRIDE_SIZE)
    ) DUT (
        .clock(clock),
        .data_valid(data_valid),
        .sreset_n(sreset_n),
        .data_in(data_in),
        .data_out(data_out),
        .kernel_out(kernel_out),
        .kernel_valid(kernel_valid)
    );
    genvar i;
    wire [KERNEL_SIZE*DATA_WIDTH-1:0] Kernel_Out_Row [0:KERNEL_SIZE-1];
    wire [DATA_WIDTH-1:0] Kernel_Out_Element [0:KERNEL_SIZE*KERNEL_SIZE-1];
    generate 
        for(i=0;i<KERNEL_SIZE; i=i+1) begin
            assign Kernel_Out_Row[KERNEL_SIZE-1-i] = kernel_out[(i+1)*KERNEL_SIZE*DATA_WIDTH-1:i*KERNEL_SIZE*DATA_WIDTH];
        end
        for(i=0;i<KERNEL_SIZE*KERNEL_SIZE; i=i+1) begin
            assign Kernel_Out_Element[KERNEL_SIZE*KERNEL_SIZE-i-1] = kernel_out[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH];
        end
    endgenerate
    //Clock
    initial clock = 0;
    always #5 clock = ~clock;  // 100 MHz

    integer valid_counter;
    // Stimulus
    integer j;
    initial begin
        // Initialize
        sreset_n = 0;
        data_valid = 0;
        data_in = 0;
        valid_counter = 0;
        #2;

        // Reset make low
        #20;
        sreset_n = 1;

        // Feed data
        #10;
        
        for (j = 0; j < ROW_NUM*COLUMN_NUM; j = j + 1) begin
            data_in = j;
            data_valid = 1;
            #10;
        end
        
        for (j = 0; j < ROW_NUM*COLUMN_NUM; j = j + 1) begin
            data_in = j;
            data_valid = 1;
            #10;
        end
        
        #10
        data_valid = 0;
        // Wait to observe outputs
        #100;
        $finish;
    end
    

    
    
    always @(posedge clock) begin
        if(kernel_valid)
            valid_counter = valid_counter + 1;
    end

endmodule
