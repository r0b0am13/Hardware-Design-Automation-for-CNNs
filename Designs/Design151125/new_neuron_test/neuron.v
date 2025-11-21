`timescale 1ns / 1ps

//`define DEBUG

module neuron2 #(parameter neuronNo=0,layerNo=0,numWeight=1024,dataWidth=16,sigmoidSize=5,weightIntWidth=1,actType="ReLU",biasFile="",weightFile="",input_channels=1)(
    input           		 clk,
    input           	     rst,
    input [input_channels*dataWidth-1:0]    myinput,
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
    localparam WEIGHTS_PER_CHANNEL = numWeight/input_channels;
    
    //localparams to make it compatible with old code
    
    localparam ADDER_GUARD = 1;
    localparam MULT_GUARD = 1;
    localparam DATA_WIDTH = dataWidth;
    localparam FRACTION_SIZE = dataWidth - weightIntWidth;
    localparam SIGNED = 1;
    localparam INPUT_CHANNELS = input_channels;
    
    
    genvar i,j,k;
    integer l,m,n;
    
    wire          		   wen;
    reg [addressWidth-1:0] w_addr=0;
    reg [addressWidth-1:0] r_addr=0;
    wire [input_channels*dataWidth-1:0]   w_out;
    reg signed [2*dataWidth-1+addressWidth:0]      sum;
    reg signed [2*dataWidth-1+extrabits:0]      sum_bias;
    reg [dataWidth-1:0]    bias [0:0];
    reg                    mult_valid;
    reg                    addr=0;
	reg                    done;
	wire  [dataWidth-1:0]   finalSum;
	wire  [2*dataWidth-1:0] bias_adjusted;
	
	assign wen = weightValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo);

	
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
	
   //write blocks 
	always @(posedge clk)
	begin
		if(biasValid & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
		begin
			bias[0] <= biasValue[dataWidth-1:0];
		end
	end
    //useable blocks start here
    initial
	begin
		$readmemb(biasFile, bias);
	end
    
    
    
    
    
    always @(posedge clk)
    begin
        if(rst)
            r_addr <= 0;
        else if(r_addr == WEIGHTS_PER_CHANNEL-1 & myinputValid)
            r_addr <= 0;
        else if(myinputValid)
            r_addr <= r_addr + 1;
    end
    
    //Seperation (Wire-Only) Stage
    wire [dataWidth-1:0] InputChannels [0:input_channels-1];
    wire [dataWidth-1:0] WeightChannels [0:input_channels-1];
    generate
        for(i=0; i<input_channels; i = i +1) begin
            assign InputChannels[input_channels-1-i] = myinput[(i+1)*dataWidth-1: i*dataWidth];
            assign WeightChannels[input_channels-1-i] = w_out[(i+1)*dataWidth-1: i*dataWidth];
        end
    endgenerate
    
    
    //Mult_Stage
    
    wire [dataWidth*2-1:0] MultWire [0:input_channels-1];
    reg [dataWidth*2-1:0] MultReg [0:input_channels-1];
    
    
    generate
        for( i =0; i < input_channels; i=i+1) begin
            FP_Multiplier #(
                .DATA_WIDTH(DATA_WIDTH),
                .FRACTION_SIZE(FRACTION_SIZE),
                .SIGNED(SIGNED),
                .GUARD(MULT_GUARD)
            ) uut (
                .A(InputChannels[i]),
                .B(WeightChannels[i]),
                .Y(MultWire[i])
            );
        end
    endgenerate
   
    always @(posedge clk) begin
        if(rst) begin
            for(l=0; l<input_channels; l=l+1) begin
                MultReg[l] <=0;
            end
        end
        else begin
            for(l=0; l<input_channels; l=l+1) begin
                MultReg[l] <=MultWire[l];
            end
        end
    end
    
	//Mult_Valid
	always @(posedge clk)
    begin
        mult_valid <= myinputValid;
    end
    // Adder Stage
    // outside generate: wires to expose each stage's reg_array[0]


    localparam NUM_INP = INPUT_CHANNELS;
    localparam STAGES = $clog2(NUM_INP);
    wire [2*DATA_WIDTH+STAGES-1:0] adder_val;
    wire [2*DATA_WIDTH+STAGES-1:0] gen_stage_out [0:STAGES-1];
    generate
        for(i = 0; i<STAGES; i = i+1) begin : gen_stage
        
            localparam stage_input = STAGE_WIDTH(NUM_INP,i);
            localparam adder_num = stage_input >> 1;
            localparam only_wire = stage_input % 2;
            localparam stage_width = only_wire + adder_num;
            
            wire [2*DATA_WIDTH+i:0] wire_array [0:stage_width-1];
            reg  [2*DATA_WIDTH+i:0] reg_array  [0:stage_width-1];
            
            for(j = 0; j < adder_num+1; j=j+1) begin : gen_adder
                if(j<adder_num) begin
                    if(i==0) begin
                        FP_Adder #(
                            .DATA_WIDTH(2*DATA_WIDTH),       
                            .FRACTION_SIZE(FRACTION_SIZE),
                            .SIGNED(SIGNED),            
                            .GUARD(1)    
                        ) u_FP_Adder (
                            .A(MultReg[2*j]),           
                            .B(MultReg[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                     else begin
                        FP_Adder #(
                            .DATA_WIDTH(2*DATA_WIDTH+i),       
                            .FRACTION_SIZE(FRACTION_SIZE),
                            .SIGNED(SIGNED),            
                            .GUARD(1)    
                        ) u_FP_Adder (
                            .A(gen_stage[i-1].reg_array[2*j]),           
                            .B(gen_stage[i-1].reg_array[2*j+1]),           
                            .Y(wire_array[j])           
                        );
                     end
                end
                if(j==adder_num) begin
                    if(only_wire ==1) begin
                        if(i==0) begin
                            assign wire_array[j] = (SIGNED == 1) ?  $signed(MultReg[2*j]) : MultReg[2*j];
                        end
                        else begin
                            assign wire_array[j] = (SIGNED == 1) ? $signed(gen_stage[i-1].reg_array[2*j]) : gen_stage[i-1].reg_array[2*j];
                        end
                    end
                end
            end
            
            for(k=0; k<stage_width; k = k+1) begin : gen_reg
                always @(posedge clk)
                    if(rst)
                        reg_array[k] <= 0;
                    else
                        reg_array[k] <= wire_array[k];
            end
            assign gen_stage_out[i] = reg_array[0];
        end
        
        assign adder_val = gen_stage_out[STAGES-1];
    endgenerate
    //MultValid Propagator
    reg MultValid [0 : STAGES-1];
    wire adder_valid;
    assign adder_valid = MultValid[STAGES-1];
    
    always @(posedge clk) begin
        if(rst) begin
            for(l=0; l<STAGES; l=l+1) begin
               MultValid[l] <=0;
            end
        end
        else begin
            MultValid[0] <= mult_valid;
            for(l=1; l<STAGES; l=l+1) begin
                MultValid[l] <=MultValid[l-1];
            end
        end
    end
    //Done propagator
    reg DoneReg [0 : STAGES-1];
    wire done_valid;
    assign done_valid = DoneReg[STAGES-2];
    always @(posedge clk) begin
        if(rst) begin
            for(l=0; l<STAGES; l=l+1) begin
               DoneReg[l] <=0;
            end
        end
        else begin
            DoneReg[0] <= done;
            for(l=1; l<STAGES; l=l+1) begin
                DoneReg[l] <=DoneReg[l-1];
            end
        end
    end
    
    
    //assign bias_adjusted = {{weightIntWidth{bias[0][dataWidth-1]}},bias[0],{(dataWidth-weightIntWidth){1'b0}}}; // Adjusted Q4.28
    //Done Controls
    always @(posedge clk)
    begin
        if(rst)
        begin
            //sum <= 0;
			done <= 1'b0;
        end
        else
        begin
			done <= 1'b0;
			if(adder_valid)
			begin
				//sum <= $signed(sum) + $signed(gen_stage[STAGES-1].reg_array[0]);
				//sum_bias <= $signed($signed(sum)>>> fraction_bits) + $signed(bias_adjusted) ;
				if(r_addr == 0)
				begin	
					done <= 1'b1;
					//sum  <= 0;
				end
			end
        end
    end
    //Sum Controller
    always @(posedge clk)
    begin
        if(rst)
        begin
            sum <= 0;
			//done <= 1'b0;
        end
        else
        begin
			//done <= 1'b0;
			if(adder_valid)
			begin
				sum <= $signed(sum) + $signed(adder_val);
				if(done_valid)
				begin
					sum_bias <= $signed($signed(sum)>>> fraction_bits) + $signed(bias[0]) ;
					sum  <= 0;
				end
			end
        end
    end
    
    assign finalSum = (sum_bias[2*dataWidth-1+extrabits]) ? 
                  (!(&sum_bias[2*dataWidth-1+extrabits:dataWidth-1]) ? //condition to check for negative overflow
                  {1'b1,{(dataWidth-1){1'b0}}} //overflowed if true since top is not completely 1s
                  : sum_bias[dataWidth-1:0]) : //negative but within bounds
                  (|sum_bias[2*dataWidth-1+extrabits:dataWidth-1] ? //if true means overflow
                  {1'b0,{(dataWidth-1){1'b1}}} //overflowed hence saturate
                  : sum_bias[dataWidth-1:0]); //positive but within bounds;
                  
                  
                  
    //Instantiation of Memory for Weights
    Weight_Memory #(.numWeight(numWeight),.neuronNo(neuronNo),.addressWidth(addressWidth),.dataWidth(dataWidth),.weightFile(weightFile),.input_channels(input_channels)) WM(
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
		.inValid(DoneReg[STAGES-1]),
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
