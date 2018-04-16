module state_ut(
		
		//////////// CLOCK //////////
		input 	     ADC_CLK_10,
		input 	     MAX10_CLK1_50,
		input 	     MAX10_CLK2_50,
		
		//////////// SEG7 //////////
		output [7:0] HEX0,
		output [7:0] HEX1,
		output [7:0] HEX2,
		output [7:0] HEX3,
		output [7:0] HEX4,
		output [7:0] HEX5,
		
		//////////// KEY //////////
		input [1:0]  KEY,
		
		//////////// LED //////////
		output [9:0] LEDR,
		
		//////////// SW //////////
		input [9:0]  SW
		);
		
				
	//defining states
   parameter HI_SCORE = 3'b000;
   parameter DELAYING = 3'b001;
   parameter TIMING = 3'b010;
   parameter DISPLAYING = 3'b011;
   parameter GO_BUFFS = 3'b1xx; //last two digits are don't cares.
		
	//Wires/Regs
   wire clk, clk_1kHz;
	assign clk = MAX10_CLK1_50;
   wire LFSR_ready;
   reg [2:0] 		     nextState;
	reg [2:0] 		     curState;
	reg LFSR_en;
	reg test_sig;

  // button state control
	reg[1:0] buttons = 0; 
   always @(negedge KEY[1],posedge KEY[0], posedge LFSR_ready)
     begin
	  if(LFSR_ready)
			buttons = 2;
	  else begin
		if(!KEY[1]) begin
			if(curState == TIMING)
				buttons = 3;
			else if (curState == DISPLAYING) begin
				buttons = 0;	
				end
			else if (curState == DELAYING)
				buttons = 0;
				test_sig = 1;
		 end
		else begin
		if (curState == DISPLAYING)
			buttons = 1;
		else if(curState == HI_SCORE)
			buttons = 1;
      end
	  end
	end
	
   //State transitions (in concert with button state control)
  always @(posedge clk)
  begin
		if(SW[9]) curState = GO_BUFFS;
		else begin
			if(LFSR_ready) begin
				if(curState == DELAYING) 
					curState = TIMING;
			end
			else if(buttons == 0)
				curState = HI_SCORE;
			else if(buttons == 1) 
				curState = DELAYING;
			else if(buttons == 2)
				curState = TIMING;
			else if(buttons == 3) 
				curState = DISPLAYING;
		end
  end
	
	clock_div clk_ms(clk, clk_1kHz);
	defparam clk_ms.n = 25000;
	counter test(clk_1kHz, LFSR_en, 2000, LFSR_ready);
	  
	//Set outputs/control signals
	//score <= ReacTime; //TODO: format for correct time
	//LFSR_en;
	//hi_score
	always @(curState)
	 begin
		case(curState)
		  GO_BUFFS: LFSR_en = 0;
		  HI_SCORE: LFSR_en = 0;
		  TIMING: LFSR_en = 0;
		  DISPLAYING: LFSR_en = 0;
		  DELAYING: LFSR_en = 1;
		endcase
	 end
//   
   //LED outs
   assign LEDR[6:4] = curState;
	assign LEDR[1:0] = buttons;
	assign LEDR[9] = LFSR_en;
	assign LEDR[8] = LFSR_ready;
	assign HEX3[7] = test_sig;
 
endmodule
