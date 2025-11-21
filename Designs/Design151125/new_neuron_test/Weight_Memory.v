module Weight_Memory #(parameter numWeight = 3, neuronNo=5,addressWidth=10,dataWidth=16,weightFile="w_1_15.mif",input_channels=1)
    (
    input                     clk,
    input                     wen,
    input  [addressWidth-1:0] wadd,
    input  [addressWidth-1:0] radd,
    input  [dataWidth-1:0]    win,
    output [input_channels*dataWidth-1:0]    wout);
   
    reg [dataWidth-1:0] mem [numWeight-1:0];
   
    initial
begin
   $readmemb(weightFile, mem);
end

always @(posedge clk)
begin
if (wen)
begin
mem[wadd] <= win;
end
end
    genvar i;
    generate
    for (i=0; i<input_channels; i=i+1) begin
        assign wout[(i+1)*dataWidth-1:i*dataWidth] = mem[radd + (input_channels-i-1)*numWeight/input_channels];
    end

    endgenerate

 
endmodule