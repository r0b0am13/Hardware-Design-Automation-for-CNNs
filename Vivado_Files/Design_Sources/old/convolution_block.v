`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.02.2025 02:00:35
// Design Name: 
// Module Name: convolution_block
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


module convolution_block#(KERNEL_SIZE=3,DATA_SIZE = 8,ROW_SIZE = 28,COLUMN_SIZE = 28)(clk,data_in, data_in_valid,convolution_out,conv_out_valid);

localparam Size = $clog2(KERNEL_SIZE*KERNEL_SIZE+1);
localparam Convol_Size = KERNEL_SIZE*KERNEL_SIZE;
localparam Stop_Count_Size = $clog2(KERNEL_SIZE-1);
localparam Row_Count_Size = $clog2(ROW_SIZE);

input [KERNEL_SIZE*KERNEL_SIZE*DATA_SIZE-1:0] data_in;
input data_in_valid,clk;
output [Size+31:0] convolution_out; //with bias (dont know if i need to truncate the values here or not)
output reg conv_out_valid;

reg [15:0] weights [0:KERNEL_SIZE*KERNEL_SIZE-1];
reg [15:0] bias = 0;
wire[Size+31:0] wiring [0:Convol_Size];
reg [Stop_Count_Size-1:0] stop_counter = 0;
reg [Row_Count_Size-1:0] counter = 0;

genvar i;
generate
    for(i = 0; i< KERNEL_SIZE*KERNEL_SIZE; i=i+1) begin
        if(i==0)
            Conv_Multi_Add#(Convol_Size) cma(.A(data_in[(i+1)*DATA_SIZE-1:i*DATA_SIZE]),.B(weights[i]),.Out(wiring[i]),.Cin(0));   
        else
            Conv_Multi_Add#(Convol_Size) cma(.A(data_in[(i+1)*DATA_SIZE-1:i*DATA_SIZE]),.B(weights[i]),.Out(wiring[i]),.Cin(wiring[i-1]));        
    end
            Conv_Multi_Add#(Convol_Size) cma(.A(1'b1),.B(bias),.Out(convolution_out),.Cin(wiring[KERNEL_SIZE*KERNEL_SIZE-1]));
endgenerate
always @(posedge clk) begin
    if(data_in_valid) begin
       if(counter>(ROW_SIZE-KERNEL_SIZE)) begin
            conv_out_valid <=0;
            if(stop_counter>=KERNEL_SIZE-1) begin
                conv_out_valid <=1;
                counter<=0;
                stop_counter<=0;
            end
            else begin
                stop_counter<=counter+1;
            end
       end
       else begin
           counter<=counter+1;   
       end          
    end          
end

endmodule
