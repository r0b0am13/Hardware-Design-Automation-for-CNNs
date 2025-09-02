`timescale 1ns / 1ps

module Maxpool
    #(
    STRIDE_SIZE = 2,
    DATA_WIDTH = 16,
    FRACTION_BITS = 14,
    SIGNED = 1,
    ROW_SIZE = 4,
    COLUMN_SIZE = 4
    )(
    
    input [STRIDE_SIZE*STRIDE_SIZE*DATA_WIDTH - 1 : 0 ] data_in,
    input data_in_valid,clock,sreset_n,
    output [DATA_WIDTH-1:0] maxpool_out,
    output out_valid
    
    );
    
    localparam NUM_INP = STRIDE_SIZE*STRIDE_SIZE;
    localparam STAGES = $clog2(NUM_INP);
    
    genvar i,j,k;
    generate
        for(i = 0; i<STAGES; i = i+1) begin : gen_stage
    
            localparam stage_input = STAGE_WIDTH(NUM_INP,i);
            localparam adder_num = stage_input >> 1;
            localparam only_wire = stage_input % 2;
            localparam stage_width = only_wire + adder_num;
        
            wire [DATA_WIDTH-1:0] wire_array [0:stage_width-1];
            reg [DATA_WIDTH-1:0] reg_array [0:stage_width-1];
        
            for(j = 0; j < adder_num+1; j=j+1) begin : gen_comparator
                if(j<adder_num) begin
                    if(i==0) begin
                        FP_Comparator #(.SIGNED(SIGNED),.INTEGER(DATA_WIDTH - FRACTION_BITS),.FRACTION(FRACTION_BITS)) comparator (.a(data_in[(2*j+2)*DATA_WIDTH-1: (2*j+1)*DATA_WIDTH]),.b(data_in[((2*j)+1)*DATA_WIDTH-1: (2*j)*DATA_WIDTH]),.out(wire_array[j]));
                    end
                    else begin
                        FP_Comparator #(.SIGNED(SIGNED),.INTEGER(DATA_WIDTH - FRACTION_BITS),.FRACTION(FRACTION_BITS)) comparator (.a(gen_stage[i-1].reg_array[2*j]),.b(gen_stage[i-1].reg_array[2*j+1]),.out(wire_array[j]));
                    end
                end
                if(j==adder_num) begin
                    if(only_wire ==1) begin
                        if(i==0) begin
                            assign wire_array[j] = data_in[2*j*DATA_WIDTH-1: (2*j-1)*DATA_WIDTH];
                        end
                        else begin
                            assign wire_array[j] = gen_stage[i-1].reg_array[2*j];
                        end
                    end
                end
            end
        
            for(k=0; k<stage_width; k = k+1) begin : gen_reg
            always @(posedge clock)
                if(!sreset_n) 
                    reg_array[k] <= 0;
                else
                    reg_array[k] <= wire_array[k];
            end
        end
        assign maxpool_out = gen_stage[STAGES-1].reg_array[0];
    endgenerate
    
      
    
    reg [STAGES-1:0] valid_reg;
    wire [STAGES-2:0] valid_wire;
    wire valid;
    reg [$clog2(STRIDE_SIZE)-1: 0] counter = 0;
    reg [$clog2(STRIDE_SIZE)-1: 0] row_valid_counter = 0;
    reg [$clog2(ROW_SIZE)-1: 0] row_counter = 0;
    
  //valid input control
    always @(posedge clock) begin
        if(!sreset_n) begin
            row_counter<=0;
            row_valid_counter<=0;
        end
        else if(data_in_valid) begin
            if(row_counter==(ROW_SIZE-1)) begin
                row_counter <=0;
                if(row_valid_counter==STRIDE_SIZE-1) begin
                    row_valid_counter <=0;
                end
                else begin
                   row_valid_counter <= row_valid_counter+1;   
                end           
            end
            else begin
                row_counter <= row_counter + 1; 
            end
        end
    end
    
    
    always @(posedge clock) begin
        if(!sreset_n) begin
            counter<=0;
        end
        else if(data_in_valid) begin
            if(counter==STRIDE_SIZE-1)
            counter <=0;
            else
                counter <= counter + 1; 
        end
    end
    
    assign valid = ~(|counter) & data_in_valid & ~(|row_valid_counter);
    
    //VALID LOGIC
    genvar m;
    generate
        for(m=0; m<STAGES;m=m+1) begin
            if(m==0) begin
                always @(posedge clock)
                    if(!sreset_n)
                        valid_reg[m] <= 0;
                    else
                        valid_reg[m] <=valid;
                assign valid_wire[m] = valid_reg[m]; 
            end       
            else if(m==STAGES-1) begin
                always @(posedge clock)
                    if(!sreset_n)
                        valid_reg[m] <= 0;
                    else
                        valid_reg[m] <=valid_wire[m-1];
                assign out_valid = valid_reg[m]; 
            end
            else begin
                always @(posedge clock)
                    if(!sreset_n)
                        valid_reg[m] <= 0;
                    else
                        valid_reg[m] <=valid_wire[m-1];
                assign valid_wire[m] = valid_reg[m]; 
            end
        end       
    endgenerate
   
   function automatic integer STAGE_WIDTH;
        input integer n, stage;
        integer i,x;
        begin
            x=n;
                for(i = 0; i<stage; i=i+1) begin
                x= x%2 + x/2;
                end
            STAGE_WIDTH = x;
        end
    endfunction  
    
endmodule
