`timescale 1ns / 1ps



module Conv_Test;

    reg clk, reset;
    wire [15:0] convol_out, maxpool_out;
    wire convol_valid, max_valid;

    reg [7:0] mem [0:783]; 
    reg [9:0] addr; 
    reg [7:0] pixel_in;
    reg valid_pin;

    integer conv_file, maxpool_file;  // File handlers
    
    Conv_Max_Full CFT (
        .Pixel_In(pixel_in),
        .Pixel_valid(valid_pin),
        .clock(clk),
        .Con_Out(convol_out), 
        .Max_Out(maxpool_out),
        .Con_Valid(convol_valid), 
        .Max_Valid(max_valid)
    );
   
    always #5 clk = ~clk;  
    
    initial begin
        $readmemb("image_mem.mem", mem);
        reset = 0;
        clk = 0;
        
        conv_file = $fopen("conv_out_bin.txt", "w");
        maxpool_file = $fopen("maxpool_out_bin.txt", "w");

        #1 reset = 1;
        #1 reset = 0;
        #9000;
        
        $fclose(conv_file);
        $fclose(maxpool_file);

        $finish;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr <= 0;
            pixel_in <= 0;
            valid_pin <= 0;
        end else begin
            pixel_in <= mem[addr];
            if (addr != 783) begin
                valid_pin <= 1;
                addr <= addr + 1;
            end else begin
                valid_pin <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (convol_valid) begin
            $fwrite(conv_file, "%b\n", $signed(convol_out)); 
            $display("Time: %0t | Convolution Output: %b", $time, $signed(convol_out));
        end
        if (max_valid) begin
            $fwrite(maxpool_file, "%b\n", $signed(maxpool_out));
            $display("Time: %0t | MaxPool Output: %b", $time, $signed(maxpool_out)); 
        end
    end

endmodule
