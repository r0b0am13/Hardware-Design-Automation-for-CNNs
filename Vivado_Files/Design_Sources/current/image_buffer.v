`timescale 1ns / 1ps

module Image_Buffer #(
    KERNEL_SIZE=3,
    DATA_WIDTH = 16,
    ROW_SIZE = 5,
    COLUMN_SIZE = 5
    )
    (
    input wire clock,data_in_valid,sreset_n,
    input wire[DATA_WIDTH-1:0] data_in,
    output [KERNEL_SIZE*KERNEL_SIZE*DATA_WIDTH-1:0] kernel_out,
    output reg out_valid
    );
    
    wire [DATA_WIDTH-1:0] lb_out [0:KERNEL_SIZE-1];
    wire [KERNEL_SIZE*DATA_WIDTH-1:0] kernel_row_out [0:KERNEL_SIZE-1];

    genvar i;
    generate
        for(i=0;i<KERNEL_SIZE;i=i+1) begin //in
            if(i==0) begin
                Line_Buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_WIDTH(DATA_WIDTH),.ROW_SIZE(ROW_SIZE)) lb (.sreset_n(sreset_n),.clock(clock),.data_valid(data_in_valid),.data_in(data_in),.data_out(lb_out[i]),.kernel_row_out(kernel_row_out[i]));
            end
            else if(i==(KERNEL_SIZE-1)) begin //out
                Line_Buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_WIDTH(DATA_WIDTH),.ROW_SIZE(KERNEL_SIZE)) lb (.sreset_n(sreset_n),.clock(clock),.data_valid(data_in_valid),.data_in(lb_out[i-1]),.data_out(lb_out[i]),.kernel_row_out(kernel_row_out[i]));
            end
            else begin //middle
                Line_Buffer #(.KERNEL_SIZE(KERNEL_SIZE),.DATA_WIDTH(DATA_WIDTH),.ROW_SIZE(ROW_SIZE)) lb (.sreset_n(sreset_n),.clock(clock),.data_valid(data_in_valid),.data_in(lb_out[i-1]),.data_out(lb_out[i]),.kernel_row_out(kernel_row_out[i]));
            end
        end
    
        for(i=0;i<KERNEL_SIZE;i=i+1) begin
            assign kernel_out[(i+1)*DATA_WIDTH*KERNEL_SIZE-1:i*DATA_WIDTH*KERNEL_SIZE] = kernel_row_out[KERNEL_SIZE-i-1];
        end

    endgenerate
    
    localparam counter_size = $clog2(ROW_SIZE*COLUMN_SIZE);
    reg [counter_size-1:0] counter = 0;
    
    always @(posedge clock) begin
        if(!sreset_n) begin
            counter <=0;
            out_valid<=0;
        end
        else begin 
            if(data_in_valid) begin
                if(counter>=ROW_SIZE*COLUMN_SIZE-1) begin
                    counter <= 0;
                end
                else
                    counter= counter + 1;
            end
            if(data_in_valid & (counter>=ROW_SIZE*(KERNEL_SIZE-1)+KERNEL_SIZE))
                out_valid <= 1;
            else
                out_valid <= 0;
            end
        end
    
endmodule



