`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2018 17:11:05
// Design Name: 
// Module Name: perceptron
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
//`define DEBUG
`include "include.v"

module neuronNew #(parameter neuronNo=0,numWeight=1024,dataWidth=16,sigmoidSize=5,actType="ReLU",biasFile="",weightFile="")(
    input           		 clk,
    input           	     rst,
    input [dataWidth-1:0]    myinput,
    input           	     myinputValid,
    input           		 weightValid,
    input           		 biasValid,
    input [dataWidth-1:0]    weightValue,
    input [dataWidth-1:0]	 biasValue,
    input [31:0]    	     config_neuron_num,
    output[dataWidth-1:0]    out,
    output          	     outvalid   
    );
    
    parameter addressWidth = $clog2(numWeight);
    
    wire          		   wen;
    reg [addressWidth-1:0] w_addr=0;
    reg [addressWidth-1:0] r_addr=0;
    wire [dataWidth-1:0]   w_out;
    reg [2*dataWidth-1:0]  mul=0; 
    reg signed [63:0]      sumtmp;
    reg signed [2*dataWidth-1:0]      sum;
    reg [dataWidth-1:0]    bias [0:0];
    reg                    mult_valid;
    reg                    addr=0;
	reg                    done;
	reg  [dataWidth-1:0]   finalSum;
	
	assign wen = weightValid & (config_neuron_num==neuronNo);
	
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
		if(biasValid & (config_neuron_num==neuronNo))
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
            mul  <= $signed(myinput) * $signed(w_out);
    end
	
	always @(posedge clk)
    begin
        mult_valid <= myinputValid;
    end
    
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
				sumtmp = $signed(sum) + $signed(mul);
				if($signed(sumtmp) > 2**(2*dataWidth-1) - 1)
					sum <= 2**(dataWidth-1) - 1;
				else if($signed(sumtmp) < -2**(2*dataWidth-1))
					sum <= -2**(dataWidth-1);
				else
					sum <= sumtmp[2*dataWidth-1:0];
				if(r_addr == 0)
				begin
					finalSum <= $signed(sumtmp[2*dataWidth-1-:dataWidth])+$signed(bias[0]);	
					done <= 1'b1;
					sum  <= 0;
				end
			end
        end
    end
    
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
