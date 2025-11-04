`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2025 03:06:41
// Design Name: 
// Module Name: AllNumbersTest
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AllNumbersTest(

    );

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
    wire [15:0] pixelfp;
    
    assign pixelfp = {2'b0,Pixel_In,6'b0};

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


    
    
    reg [7:0] image_0 [0:783];
    reg [7:0] image_1 [0:783];
    reg [7:0] image_2 [0:783];
    reg [7:0] image_3 [0:783];
    reg [7:0] image_4 [0:783];
    reg [7:0] image_5 [0:783];
    reg [7:0] image_6 [0:783];
    reg [7:0] image_7 [0:783];
    reg [7:0] image_8 [0:783];
    reg [7:0] image_9 [0:783];
      
    integer i,j;

    initial begin
        $readmemb("number_0.mem", image_0);
        $readmemb("number_1.mem", image_1);
        $readmemb("number_2.mem", image_2);
        $readmemb("number_3.mem", image_3);
        $readmemb("number_4.mem", image_4);
        $readmemb("number_5.mem", image_5);
        $readmemb("number_6.mem", image_6);
        $readmemb("number_7.mem", image_7);
        $readmemb("number_8.mem", image_8);
        $readmemb("number_9.mem", image_9);
          

        reset_n = 0;
        data_in_valid = 0;
        Pixel_In = 0;

        @(negedge clock);
        reset_n <= 0;
        @(negedge clock);
        reset_n <= 1;
        
        for(j = 0; j < 10; j = j + 1) begin
            for (i = 0; i < 784; i = i + 1) begin
                @(negedge clock);
                data_in_valid = 1;
                case(j)
                    0: Pixel_In = image_0[i];
                    1: Pixel_In = image_1[i];
                    2: Pixel_In = image_2[i];
                    3: Pixel_In = image_3[i];
                    4: Pixel_In = image_4[i];
                    5: Pixel_In = image_5[i];
                    6: Pixel_In = image_6[i];
                    7: Pixel_In = image_7[i];
                    8: Pixel_In = image_8[i];
                    9: Pixel_In = image_9[i];
                endcase 
            end
            
            @(negedge clock);
            data_in_valid <= 0;
            Pixel_In <= 0;
            @(negedge clock);
            data_in_valid <= 0;
            Pixel_In <= 0;
        end
        repeat (600) @(negedge clock);
        $finish;
    end
    
endmodule