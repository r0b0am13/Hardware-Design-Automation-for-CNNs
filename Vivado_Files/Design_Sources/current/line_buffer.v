`timescale 1ns / 1ps

module Line_Buffer#(KERNEL_SIZE = 3,DATA_SIZE = 8,ROW_SIZE = 5)
    (
    input clock,data_valid,
    input [DATA_SIZE-1:0] data_in,
    output [DATA_SIZE-1:0] data_out,
    output [KERNEL_SIZE*DATA_SIZE-1:0] kernel_row_out
    );


wire [DATA_SIZE-1:0] wiring [0:ROW_SIZE-1];


genvar i;
generate 

for(i=0;i<ROW_SIZE;i=i+1) begin
    if(i==0) begin
        Data_Buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.data_in(data_in),.data_out(wiring[i]));
        end
    else if(i==ROW_SIZE-1) begin
        Data_Buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.data_in(wiring[i-1]),.data_out(wiring[i]));
        end
    else
        Data_Buffer #(DATA_SIZE) pb (.clock(clock),.data_valid(data_valid),.data_in(wiring[i-1]),.data_out(wiring[i]));
    end
for(i=0; i<KERNEL_SIZE;i = i+1) begin
    assign kernel_row_out[(i+1)*DATA_SIZE-1:i*DATA_SIZE] = wiring[KERNEL_SIZE-i-1]; 
end
    assign data_out = wiring[ROW_SIZE-1];
endgenerate



endmodule
