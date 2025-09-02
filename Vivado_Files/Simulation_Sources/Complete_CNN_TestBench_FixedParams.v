`timescale 1ns / 1ps

module Complete_CNN_TestBench_FixedParams;

    reg clock;
    reg reset_n;

    reg data_in_valid;
    reg [7:0] Pixel_In;

    wire [15:0] Conv_Debug, Maxpool_Debug;
    wire Conv_valid_Debug, Maxpool_valid_Debug;
    wire [31:0] out_final;
    wire out_valid_final;
    wire [1023:0] x1_out_d;
    wire [511:0]  x2_out_d;
    wire [159:0]  x3_out_d;
    wire [63:0]   o1_valid_d;
    wire [31:0]   o2_valid_d;
    wire [9:0]    o3_valid_d;

    Full_CNN_wrapper dut (
        .Conv_Debug(Conv_Debug),
        .Conv_valid_Debug(Conv_valid_Debug),
        .Maxpool_Debug(Maxpool_Debug),
        .Maxpool_valid_Debug(Maxpool_valid_Debug),
        .Pixel_In(Pixel_In),
        .clock(clock),
        .data_in_valid(data_in_valid),
        .o1_valid_d(o1_valid_d),
        .o2_valid_d(o2_valid_d),
        .o3_valid_d(o3_valid_d),
        .out_final(out_final),
        .out_valid_final(out_valid_final),
        .reset_n(reset_n),
        .x1_out_d(x1_out_d),
        .x2_out_d(x2_out_d),
        .x3_out_d(x3_out_d)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    initial begin
        $system("mkdir sim_outputs");
    end
    
    
    integer conv_file, max_file, cnn_file;

    initial begin
    // Open files
    conv_file = $fopen("sim_outputs/conv_outputs_b.txt", "w");
    max_file  = $fopen("sim_outputs/maxpool_outputs_b.txt", "w");
    cnn_file  = $fopen("sim_outputs/cnn_outputs_b.txt", "w");

    // Check if files were successfully opened
    if (conv_file == 0) begin
        $display("ERROR: Could not open conv_outputs.txt");
        $finish;
    end

    if (max_file == 0) begin
        $display("ERROR: Could not open maxpool_outputs.txt");
        $finish;
    end

    if (cnn_file == 0) begin
        $display("ERROR: Could not open cnn_outputs.txt");
        $finish;
    end
end
    
    reg [7:0] image_mem [0:783];  // 28x28 = 784 pixels
    integer i;

    initial begin
        $readmemb("image_mem.mem", image_mem);  

        reset_n = 0;
        data_in_valid = 0;
        Pixel_In = 0;

        @(posedge clock);
        reset_n <= 0;
        @(posedge clock);
        reset_n <= 1;

        for (i = 0; i < 784; i = i + 1) begin
            @(posedge clock);
            data_in_valid <= 1;
            Pixel_In <= image_mem[i];
        end

        @(posedge clock);
        data_in_valid <= 0;
        Pixel_In <= 0;

        
        repeat (19214) @(posedge clock);
        $fclose(conv_file);
        $fclose(max_file);
        $fclose(cnn_file);
            $finish;
    end
    integer conv_count,max_count,o1count,o2count,o3count,ofinalcount;
    
    
    initial begin
    conv_count = 0;
    max_count = 0;
    o1count = 0;
    o2count = 0;
    o3count = 0;
    ofinalcount = 0;
    end
   
    always @(posedge clock) begin
        if (Conv_valid_Debug) begin
            conv_count= conv_count+1;
            $display("[%0t] Count: %d Conv_Debug = %h", $time, conv_count, Conv_Debug);
            $fwrite(conv_file, "%b\n", Conv_Debug);
            
        end

        if (Maxpool_valid_Debug) begin
            max_count= max_count+1;
            $display("[%0t] Count: %d Maxpool_Debug = %h", $time, max_count, Maxpool_Debug);
            $fwrite(max_file, "%b\n", Maxpool_Debug);
            
        end

        if (|o1_valid_d) begin
            o1count = o1count+1;
            $display("[%0t] Count: %d x1_out_d = %h (valid = %h)", $time, o1count, x1_out_d, o1_valid_d);
            $fwrite(cnn_file, "%b\n", x1_out_d);
        end

        if (|o2_valid_d) begin
            o2count = o2count+1;
            $display("[%0t] Count: %d x2_out_d = %h (valid = %h)", $time, o2count, x2_out_d, o2_valid_d);
            $fwrite(cnn_file, "%b\n", x2_out_d);
        end
        if (|o3_valid_d) begin
            o3count = o3count+1;
            $display("[%0t] Count: %d x3_out_d = %h (valid = %h)", $time, o3count, x3_out_d, o3_valid_d);
            $fwrite(cnn_file, "%b\n", x3_out_d);
        end
        if (out_valid_final) begin
            ofinalcount = ofinalcount+1;
            $display("[%0t] Count: %d Final Output = %h", $time, ofinalcount, out_final);
            $fwrite(cnn_file, "%b\n", out_final);
        end
    end
endmodule