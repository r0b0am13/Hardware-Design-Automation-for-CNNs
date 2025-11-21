`timescale 1ns / 1ps

module TestC();

   
    localparam IMG_WIDTH        = 28;
    localparam IMG_HEIGHT       = 28;
    localparam CONV_KERNEL_SIZE = 3;
    localparam POOL_KERNEL_SIZE = 2;
    localparam INPUT_DATAWIDTH  = 8;
    localparam DATA_WIDTH       = 16;
    localparam FRACTION_WIDTH   = 14;

    
    reg clock, sreset_n;
    reg data_valid;
    reg [INPUT_DATAWIDTH-1:0] data_in_8bit;

    wire [DATA_WIDTH-1:0] data_in_fixed;
    wire [DATA_WIDTH-1:0] data_out_convbuf;
    wire [CONV_KERNEL_SIZE*CONV_KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out_conv;
    wire kernel_valid_conv;

    wire [DATA_WIDTH-1:0] conv_out;
    wire conv_valid;

    wire [CONV_KERNEL_SIZE*CONV_KERNEL_SIZE*DATA_WIDTH-1:0] weights;
    wire [DATA_WIDTH-1:0] bias;

    wire [DATA_WIDTH-1:0] data_out_poolbuf;
    wire [POOL_KERNEL_SIZE*POOL_KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out_pool;
    wire kernel_valid_pool;

    wire [DATA_WIDTH-1:0] maxp_out;
    wire maxp_valid;

    // Image memory
    reg [INPUT_DATAWIDTH-1:0] image_mem [0:IMG_WIDTH*IMG_HEIGHT-1];
    integer i;

    //==========================================================
    // Clock Generation
    //==========================================================
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 100 MHz clock
    end
    //Save setups
    integer conv_file, max_file, kernel_out_conv_file;
    initial begin
        conv_file = $fopen("sim_outputs/conv_outputs_b.txt", "w");
        max_file  = $fopen("sim_outputs/maxpool_outputs_b.txt", "w");
        kernel_out_conv_file  = $fopen("sim_outputs/kernel_out_conv_b.txt", "w");
        
        if (conv_file == 0) begin
            $display("ERROR: Could not open conv_outputs.txt");
            $finish;
        end
    
        if (max_file == 0) begin
            $display("ERROR: Could not open maxpool_outputs.txt");
            $finish;
        end
        if (kernel_out_conv_file == 0) begin
            $display("ERROR: Could not open kernel_out_conv_b.txt");
            $finish;
        end
    end
    
    
    integer image_valid_count;
    integer conv_valid_count;
    integer max_valid_count;
    integer kernel_out_conv_valid_count;
    
    
    initial begin
        sreset_n   = 0;
        data_valid = 0;
        data_in_8bit = 0;
        image_valid_count=0;
        conv_valid_count = 0;
        max_valid_count = 0;
        kernel_out_conv_valid_count = 0;
        // Read image from memory file (8-bit grayscale values)
        $readmemb("image.mem", image_mem);

        #20;
        sreset_n = 1;
        data_valid = 0;
        
        #20;
        // Feed 28x28 image pixels
        for (i = 0; i < IMG_WIDTH*IMG_HEIGHT; i = i + 1) begin
            @(negedge clock);
            data_in_8bit = image_mem[i];
            data_valid = 1;
        end
        
        
        @(negedge clock);
        data_valid = 0;
        #1000;
            $fclose(conv_file);
            $fclose(max_file);
            $fclose(kernel_out_conv_file);
        $finish;
    end
    
   
    always @(posedge clock) begin
        if(conv_valid) begin
            conv_valid_count = conv_valid_count+1;
            $display("[%0t] Count: %d Conv_Debug = %h", $time, conv_valid_count, conv_out);
            $fwrite(conv_file, "%b\n", conv_out);
            
        end
        if(data_valid) begin
            image_valid_count = image_valid_count+1;
        end
        if(maxp_valid) begin
            max_valid_count = max_valid_count+1;
            $display("[%0t] Count: %d Maxpool_Debug = %h", $time, max_valid_count, maxp_out);
            $fwrite(max_file, "%b\n", maxp_out);
        end
        if(kernel_valid_conv) begin
            kernel_out_conv_valid_count = kernel_out_conv_valid_count+1;
            $display("[%0t] Count: %d kernel_out_conv = %h", $time, kernel_out_conv_valid_count, kernel_out_conv);
            $fwrite(kernel_out_conv_file, "%b\n", kernel_out_conv);
        end
            
    end

    //==========================================================
    // Data Converter (8-bit ? 16-bit Q2.14)
    //==========================================================
    DataConverter #(
        .INPUT_DATAWIDTH(INPUT_DATAWIDTH),
        .INPUT_FRACTION_WIDTH(0),
        .OUTPUT_DATAWIDTH(DATA_WIDTH),
        .OUTPUT_FRACTION_WIDTH(FRACTION_WIDTH)
    ) u_dataconverter (
        .data_in(data_in_8bit),
        .data_out(data_in_fixed)
    );

    //==========================================================
    // Conv Weights and Bias Module
    //==========================================================
    ConvWeightBiasModule #(
        .KERNEL_SIZE(CONV_KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_convweights (
        .Weights(weights),
        .Bias(bias)
    );

    //==========================================================
    // Image Buffer for Convolution Input (28x28 ? 26x26)
    //==========================================================
    ImageBuf_KernelSlider #(
        .KERNEL_SIZE(CONV_KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .COLUMN_NUM(IMG_WIDTH),
        .ROW_NUM(IMG_HEIGHT),
        .STRIDE(1)
    ) Conv_Inputter (
        .clock(clock),
        .data_valid(data_valid),
        .sreset_n(sreset_n),
        .data_in(data_in_fixed),       // Converted to 16-bit fixed
        .data_out(data_out_convbuf),
        .kernel_out(kernel_out_conv),
        .kernel_valid(kernel_valid_conv)
    );

    //==========================================================
    // Convolution Block
    //==========================================================
    Convolution #(
        .KERNEL_SIZE(CONV_KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .FRACTION_SIZE(FRACTION_WIDTH),
        .SIGNED(1),
        .ACTIVATION(1),
        .GUARD_TYPE(2)
    ) u_convolution (
        .clock(clock),
        .data_valid(kernel_valid_conv),
        .sreset_n(sreset_n),
        .kernel_in(kernel_out_conv),
        .weights(weights),
        .bias(bias),
        .conv_out(conv_out),
        .conv_valid(conv_valid)
    );

    //==========================================================
    // Image Buffer for Maxpool Input (26x26 ? 13x13)
    //==========================================================
    ImageBuf_KernelSlider #(
        .KERNEL_SIZE(POOL_KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .COLUMN_NUM(26),
        .ROW_NUM(26),
        .STRIDE(2)
    ) Pool_Inputter (
        .clock(clock),
        .data_valid(conv_valid),
        .sreset_n(sreset_n),
        .data_in(conv_out),
        .data_out(data_out_poolbuf),
        .kernel_out(kernel_out_pool),
        .kernel_valid(kernel_valid_pool)
    );

    //==========================================================
    // Maxpool Block
    //==========================================================
    Maxpool #(
        .KERNEL_SIZE(POOL_KERNEL_SIZE),
        .DATA_WIDTH(DATA_WIDTH),
        .SIGNED(1)
    ) u_maxpool (
        .clock(clock),
        .data_valid(kernel_valid_pool),
        .sreset_n(sreset_n),
        .kernel_in(kernel_out_pool),
        .maxp_out(maxp_out),
        .maxp_valid(maxp_valid)
    );

endmodule
