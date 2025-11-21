`timescale 1ns / 1ps

//`define DEBUG

module neuron #(parameter neuronNo=0,layerNo=0,numWeight=1024,dataWidth=16,sigmoidSize=5,weightIntWidth=1,actType="ReLU",biasFile="",weightFile="",input_channels=1)(
    input           		 clk,
    input           	     rst,
    input [dataWidth-1:0]    myinput,
    input           	     myinputValid,
    input           		 weightValid,
    input           		 biasValid,
    input [dataWidth-1:0]    weightValue,
    input [dataWidth-1:0]	 biasValue,
    input [31:0]    	     config_neuron_num,
	input [31:0] 			 config_layer_num,
    output[dataWidth-1:0]    out,
    output          	     outvalid   
    );
    
    localparam addressWidth = $clog2(numWeight);
    localparam extrabits = $clog2(numWeight+1);
    localparam fraction_bits = dataWidth - weightIntWidth;
    
    wire          		   wen;
    reg [addressWidth-1:0] w_addr=0;
    reg [addressWidth-1:0] r_addr=0;
    wire [dataWidth-1:0]   w_out;
    reg [2*dataWidth-1:0]  mul=0; 
    reg signed [2*dataWidth-1+extrabits:0]      sumtmp;
    reg signed [2*dataWidth-1+extrabits:0]      sum;
    reg [dataWidth-1:0]    bias [0:0];
    reg                    mult_valid;
    reg                    addr=0;
	reg                    done;
	wire  [dataWidth-1:0]   finalSum;
	wire  [2*dataWidth-1:0] bias_adjusted;
	
	assign wen = weightValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo);
	
	initial
	begin
		$readmemb(biasFile, bias);
	end
	
    //Loading weight values into the momory
    always @(posedge clk)
    begin
        if(rst)
        begin
            w_addr <= 0;
        end
        else if(wen)
        begin
            w_addr <= w_addr + 1;
        end
    end
	
    
	always @(posedge clk)
	begin
		if(biasValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
		begin
			bias[0] <= biasValue[dataWidth-1:0];
		end
	end
    
    
    always @(posedge clk)
    begin
        if(rst)
            r_addr <= 0;
        else if(r_addr == numWeight-1 & myinputValid)
            r_addr <= 0;
        else if(myinputValid)
            r_addr <= r_addr + 1;
    end
    
    always @(posedge clk)
    begin
        if(myinputValid)
            mul  <= $signed(myinput) * $signed(w_out); //for Qn.m will become Q2n.2m
    end
	
	always @(posedge clk)
    begin
        mult_valid <= myinputValid;
    end
    
    assign bias_adjusted = {{weightIntWidth{bias[0][dataWidth-1]}},bias[0],{(dataWidth-weightIntWidth){1'b0}}}; // Adjusted Q4.28
    always @(posedge clk)
    begin
        if(rst)
        begin
            sum <= 0;
			done <= 1'b0;
        end
        else
        begin
			done <= 1'b0;
			if(mult_valid)
			begin
				sum = $signed(sum) + $signed(mul);
				if(r_addr == 0)
				begin
					sumtmp <= $signed($signed(sum)+$signed(bias_adjusted)) >>> fraction_bits;	
					done <= 1'b1;
					sum  <= 0;
				end
			end
        end
    end
    
    assign finalSum = (sumtmp[2*dataWidth-1+extrabits]) ? 
                  (!(&sumtmp[2*dataWidth-1+extrabits:dataWidth-1]) ? //condition to check for negative overflow
                  {1'b1,{(dataWidth-1){1'b0}}} //overflowed if true since top is not completely 1s
                  : sumtmp[dataWidth-1:0]) : //negative but within bounds
                  (|sumtmp[2*dataWidth-1+extrabits:dataWidth-1] ? //if true means overflow
                  {1'b0,{(dataWidth-1){1'b1}}} //overflowed hence saturate
                  : sumtmp[dataWidth-1:0]); //positive but within bounds;
    //Instantiation of Memory for Weights
    Weight_Memory #(.numWeight(numWeight),.neuronNo(neuronNo),.addressWidth(addressWidth),.dataWidth(dataWidth),.weightFile(weightFile)) WM(
        .clk(clk),
        .wen(wen),
        .wadd(w_addr),
        .radd(r_addr),
        .win(weightValue),
        .wout(w_out)
    );
    

	ReLU #(.dataWidth(dataWidth)) s1 (
		.clk(clk),
		.x(finalSum),
		.inValid(done),
		.out(out),
		.outValid(outvalid)
	);


    `ifdef DEBUG
    always @(posedge clk)
    begin
        if(outvalid)
            $display(neuronNo,,,,"%b",out);
    end
    `endif
endmodule
