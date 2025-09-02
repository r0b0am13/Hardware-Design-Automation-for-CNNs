`timescale 1ns / 1ps

module image_buffer_TB();

    localparam DATA_WIDTH = 8,ROW_SIZE = 3,KERNEL_SIZE=3,COLUMN_SIZE = 3;
    reg clock,data_valid,sreset_n;
    reg [DATA_WIDTH-1:0] data_in;
    wire [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out;
    wire out_valid;

    Image_Buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_WIDTH(DATA_WIDTH),.ROW_SIZE(ROW_SIZE),.COLUMN_SIZE(COLUMN_SIZE)) ib_tb (.sreset_n(sreset_n),.clock(clock), .data_in(data_in),.kernel_out(kernel_out),.out_valid(out_valid),.data_in_valid(data_valid));

    integer i = 0;
    initial begin
    clock = 0;
    sreset_n = 1;
    
    #2;
    sreset_n = 0;
    
    #7 sreset_n = 1;
    data_valid = 1;
    for (i=1; i<=9; i = i+1) begin
        data_in = $unsigned(i); #10;
    end
    
    data_valid = 0;#50;
    #2 data_valid =1;
    
    for (i=1; i<=9; i = i+1) begin
    data_in = i; #10;
    end
    for (i=1; i<=9; i = i+1) begin
    data_in = i; #10;
    end
    
    #50;
       $finish;
    end
    always
    #5 clock = ~clock;
    
endmodule