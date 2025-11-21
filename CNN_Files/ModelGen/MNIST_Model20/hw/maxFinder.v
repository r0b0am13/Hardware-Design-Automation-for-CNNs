module maxFinder #(parameter NUM_INPUTS=10,parameter DATA_WIDTH=16, parameter SIGNED = 1)(
input           i_clk,
input [(NUM_INPUTS*DATA_WIDTH)-1:0]   i_data,
input           i_valid,
output reg [31:0]o_data,
output  reg     o_data_valid
);

reg [DATA_WIDTH-1:0] maxValue;
reg [(NUM_INPUTS*DATA_WIDTH)-1:0] inDataBuffer;
integer counter;

always @(posedge i_clk)
begin
    o_data_valid <= 1'b0;
    if(i_valid)
    begin
        maxValue <= i_data[DATA_WIDTH-1:0];
        counter <= 1;
        inDataBuffer <= i_data;
        o_data <= 0;
    end
    else if(counter == NUM_INPUTS)
    begin
        counter <= 0;
        o_data_valid <= 1'b1;
    end
    else if(counter != 0)
    begin
        counter <= counter + 1;
        if(inDataBuffer[counter*DATA_WIDTH+:DATA_WIDTH] > maxValue)
        begin
            maxValue <= inDataBuffer[counter*DATA_WIDTH+:DATA_WIDTH];
            o_data <= counter;
        end
    end
end

endmodule