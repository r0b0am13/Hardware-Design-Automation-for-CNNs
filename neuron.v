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

module neuron #(parameter layerNo=0,neuronNo=0,numWeight=784,dataWidth=16,sigmoidSize=5,weightIntWidth=1,actType="relu",biasFile="",weightFile="")(
    input           clk,
    input           rst,
    input [dataWidth-1:0]    myinput,
    input           myinputValid,
    input           weightValid,
    input           biasValid,
    input [31:0]    weightValue,
    input [31:0]    biasValue,
    input [31:0]    config_layer_num,
    input [31:0]    config_neuron_num,
    output[dataWidth-1:0]    out,
    output reg      outvalid   
    );
    
    parameter addressWidth = $clog2(numWeight);
    
    reg         wen;
    wire        ren;
    reg [addressWidth-1:0] w_addr=0;
    reg [addressWidth:0]   r_addr=0;//read address has to reach until numWeight hence width is 1 bit more
    reg [dataWidth-1:0]  w_in=0;
    wire [dataWidth-1:0] w_out;
    reg [2*dataWidth-1:0]  mul=0; 
    reg [2*dataWidth-1:0]  sum=0;
    reg [2*dataWidth-1:0]  bias=0;
    reg [31:0]    biasReg[0:0];
    reg         weight_valid;
    reg         mult_valid;
    reg         sigValid; 
    wire [2*dataWidth:0] comboAdd;
    wire [2*dataWidth:0] BiasAdd;
    reg  [dataWidth-1:0] myinputd;
    reg muxValid_d;
    reg muxValid_f;
    reg addr=0;
    reg [1:0] pCounter;
    reg sum_valid;
    localparam IDLE     = 'd0,
               WAIT_END = 'd1,
               WAIT_OUT = 'd2; 
    reg [1:0] STATE = IDLE;
   //Loading weight values into the momory
    always @(posedge clk)
    begin
        if(rst)
        begin
            w_addr <= {addressWidth{1'b1}};
            wen <=0;
        end
        else if(weightValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
        begin
            w_in <= weightValue;
            w_addr <= w_addr + 1;
            wen <= 1;
        end
        else
            wen <= 0;
    end
	
    assign comboAdd = mul + sum;
    assign BiasAdd = mul + sum + bias;
    assign ren = myinputValid;
    
	`ifdef pretrained
		initial
		begin
			$readmemb(biasFile,biasReg);
		end
		always @(posedge clk)
		begin
            bias <= {biasReg[addr][dataWidth-1:0],{dataWidth{1'b0}}};
        end
	`else
		always @(posedge clk)
		begin
			if(biasValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
			begin
				bias <= {biasValue[dataWidth-1:0],{dataWidth{1'b0}}};
			end
		end
	`endif
    
    
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
        mul  <= $signed(myinputd) * $signed(w_out);
    end
    
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            sum <= 0;
            STATE <= IDLE;
            sum_valid <= 1'b0;
        end
        else
        begin
            case(STATE)
                IDLE:begin
                    if(mult_valid)
                    begin
                        sum <= mul;
                        STATE <= WAIT_END;        
                    end
                end
                WAIT_END:begin
                    sum <= comboAdd;
                    if(r_addr == numWeight-1 & myinputValid)
                    begin
                        pCounter <= 0;
                        STATE <= WAIT_OUT;
                    end
                end
                WAIT_OUT:begin
                    pCounter <= pCounter+1;
                    sum <= comboAdd; 
                    if(pCounter == 2)
                    begin
                        sum <= BiasAdd;
                        sum_valid <= 1'b1;
                    end
                    else if(pCounter == 3 & mult_valid)
                    begin
                        sum <= mul;
                        STATE <= WAIT_END; 
                        sum_valid <= 1'b0;
                    end
                    else if(pCounter == 3)
                    begin
                        STATE <= IDLE;
                        sum_valid <= 1'b0;
                    end     
                end
            endcase
        end
    end
    
    always @(posedge clk)
    begin
        myinputd <= myinput;
        weight_valid <= myinputValid;
        mult_valid <= weight_valid;
        outvalid <= sum_valid;
    end
    
    
    //Instantiation of Memory for Weights
    Weight_Memory #(.numWeight(numWeight),.neuronNo(neuronNo),.layerNo(layerNo),.addressWidth(addressWidth),.dataWidth(dataWidth),.weightFile(weightFile)) WM(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .wadd(w_addr),
        .radd(r_addr),
        .win(w_in),
        .wout(w_out)
    );
    
	generate
		if(actType == "sigmoid")
		begin:siginst
		//Instantiation of ROM for sigmoid
			Sig_ROM #(.inWidth(sigmoidSize),.dataWidth(dataWidth)) s1(
			.clk(clk),
			.x(sum[2*dataWidth-1-:sigmoidSize]),
			.out(out)
		);
		end
		else
		begin:ReLUinst
			ReLU #(.dataWidth(dataWidth),.weightIntWidth(weightIntWidth)) s1 (
			.clk(clk),
			.x(sum),
			.out(out)
		);
		end
	endgenerate

    `ifdef DEBUG
    always @(posedge clk)
    begin
        if(outvalid)
            $display(neuronNo,,,,"%b",out);
    end
    `endif
endmodule
