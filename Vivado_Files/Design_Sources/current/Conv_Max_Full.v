`timescale 1ns / 1ps

module Conv_Max_Full#(
    IN_DATA_WIDTH = 8,
    OUT_INTEGER = 2,
    OUT_FRACTION = 14,
    KERNEL_SIZE1 = 3,
    KERNEL_SIZE2 = 2,
    DATA_WIDTH = 16,
    ROW_SIZE1 = 28,
    COLUMN_SIZE1 = 28,
    ROW_SIZE2 = 26,
    COLUMN_SIZE2 = 26
    )
    (
    input [IN_DATA_WIDTH-1:0] Pixel_In,
    input Pixel_valid,
    input clock,
    output [DATA_WIDTH-1:0] Con_Out, Max_Out,FP_Input,
    output Con_Valid, Max_Valid
    );
    
    wire [DATA_WIDTH-1:0] FP_Out,convol_out,max_out;
    wire [KERNEL_SIZE1*KERNEL_SIZE1*DATA_WIDTH-1:0] Kernel_Out1;
    wire [KERNEL_SIZE2*KERNEL_SIZE2*DATA_WIDTH - 1 : 0 ] Kernel_Out2;
    wire out_valid1,out_valid2;
    wire convol_valid,max_valid;
    wire [KERNEL_SIZE1*KERNEL_SIZE1*DATA_WIDTH-1:0] weights;
    wire [DATA_WIDTH-1:0] bias;
    
    assign Con_Out = convol_out;
    assign Max_Out = max_out;
    assign Con_Valid = convol_valid;
    assign Max_Valid = max_valid;
    assign FP_Input = FP_Out;
    Pixel8_to_FP16Format#(.IN_DATA_WIDTH(IN_DATA_WIDTH),.OUT_INTEGER(OUT_INTEGER),.OUT_FRACTION(OUT_FRACTION)) 
        P816(.Pixel_In(Pixel_In) ,.FP_Out(FP_Out));
        
    Image_Buffer #(.KERNEL_SIZE(KERNEL_SIZE1),
                   .DATA_WIDTH(DATA_WIDTH),
                   .ROW_SIZE(ROW_SIZE1),
                   .COLUMN_SIZE(COLUMN_SIZE1)) 
                   IB_to_Conv (.clock(clock), 
                   .data_in(FP_Out),
                   .kernel_out(Kernel_Out1),
                   .out_valid(out_valid1),
                   .data_in_valid(Pixel_valid));
                   
    Weight_Bias #(
                  .DATA_WIDTH(DATA_WIDTH),
                  .KERNEL_SIZE(KERNEL_SIZE1)
                  ) WB (
                  .weights(weights),
                  .bias(bias)
                  );
                   
    Pipelined_Convolution #(
                            .COLUMN_SIZE(COLUMN_SIZE1),
                            .KERNEL_SIZE(KERNEL_SIZE1),
                            .DATA_WIDTH(DATA_WIDTH),
                            .FRACTION_BITS(OUT_FRACTION),
                            .SIGNED(1)
                             ) PC (
                            .data(Kernel_Out1),
                            .weights(weights),
                            .bias(bias),
                            .clock(clock),
                            .valid(out_valid1),
                            .convol_out(convol_out),
                            .convol_valid(convol_valid)
                            );
    
    Image_Buffer #(.KERNEL_SIZE(KERNEL_SIZE2),
                   .DATA_WIDTH(DATA_WIDTH),
                   .ROW_SIZE(ROW_SIZE2),
                   .COLUMN_SIZE(COLUMN_SIZE2)) 
                   IB_to_Max (.clock(clock), 
                   .data_in(convol_out),
                   .kernel_out(Kernel_Out2),
                   .out_valid(out_valid2),
                   .data_in_valid(convol_valid));
                   
    Maxpool #(
            .STRIDE_SIZE(KERNEL_SIZE2),
            .DATA_WIDTH(DATA_WIDTH),
            .FRACTION_BITS(OUT_FRACTION),
            .SIGNED(1),
            .ROW_SIZE(ROW_SIZE2),
            .COLUMN_SIZE(COLUMN_SIZE2)
            ) MP(
            .data_in(Kernel_Out2),
            .data_in_valid(out_valid2),
            .clock(clock),
            .maxpool_out(max_out),
            .out_valid(max_valid)
            );
    
endmodule
