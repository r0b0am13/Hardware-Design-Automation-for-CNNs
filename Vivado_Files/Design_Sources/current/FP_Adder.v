module FP_Adder#(
    parameter SIGNED = 1,
    parameter INTEGER = 2,
    parameter FRACTION = 14
)
(
    input[INTEGER+FRACTION-1:0] a,b,
    output reg [INTEGER+FRACTION-1:0] out
);

        localparam TOTAL_WIDTH = INTEGER + FRACTION;

    reg  [TOTAL_WIDTH:0] sum_raw;
    reg [TOTAL_WIDTH-1:0] sum_saturated;

    always @(*) begin
        if (SIGNED==1)
            sum_raw = $signed(a) + $signed(b);
        else
            sum_raw = a+b;
    end
    
    always @(*) begin
        if (SIGNED) begin

            if (sum_raw[TOTAL_WIDTH] != sum_raw[TOTAL_WIDTH-1]) begin //overflow/underflow

                if (sum_raw[TOTAL_WIDTH])
                    sum_saturated = {1'b1, {TOTAL_WIDTH-1{1'b0}}}; //min
                else
                    sum_saturated = {1'b0, {TOTAL_WIDTH-1{1'b1}}}; //max

            end else begin
                sum_saturated = sum_raw[TOTAL_WIDTH-1:0];
            end
            
        end else begin
            if (sum_raw[TOTAL_WIDTH])
                sum_saturated = {TOTAL_WIDTH{1'b1}}; //max
            else
                sum_saturated = sum_raw[TOTAL_WIDTH-1:0];
        end
    end

    always @(*) begin
        out = sum_saturated;
    end

endmodule