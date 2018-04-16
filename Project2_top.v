
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Project2_top(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);

//defining states
parameter HI_SCORE = 3'b000;
parameter DELAYING = 3'b001;
parameter TIMING = 3'b010;
parameter DISPLAYING = 3'b011;
parameter GO_BUFFS = 3'b1xx; //last two digits are don't cares.


//=======================================================
//  REG/WIRE declarations
//=======================================================
			 
	//state vars
	reg [2:0] currState;
	assign LED[9:7] = currState; //display state on LEDs
	reg [1:0] buttons;
	
	//clocks
	wire clk_1kHz, clk;
	clock_div clk_ms(MAX10_CLK1_50, clk_1kHz);
	assign clk = MAX10_CLK1_50;
	
	//scores
	reg [3:0] hi_score_cd, hi_score_ds, hi_score_s;
	reg [3:0] score_cd, score_ds, score_s;
	//decimal point for timing
	wire point;
	
	
	////////////////BCD_counter//////////////////////
	wire RCO_ms,RCO_cs,RCO_ds, RCO_s;
	wire [3:0] count_ms;
	wire [3:0] count_cs;
	wire [3:0] count_ds;
	wire [3:0] count_s;
	wire timing,bcd_clear_, sevseg_clr;
	assign timing = (curState == TIMING);
	
	BCD_counter time_ms(clk_1kHz, timing, bcd_clear_, 0, count_ms, RCO_ms);
	BCD_counter time_cs(RCO_ms, timing, bcd_clear_, 0, count_cs, RCO_cs);
	BCD_counter time_ds(RCO_cs, timing, bcd_clear_, 0, count_ds, RCO_ds);
	BCD_counter time_s(RCO_ds, timing, bcd_clear_, 0, count_s, RCO_s);

	//////////////////end BCD////////////////////
	
	
	///////////////////GO BUFFS///////////////////
	wire buff_clk;
	wire [3:0] a,b,c,d,e,f;
	wire [6:0] buff_hex0,buff_hex1,buff_hex2,buff_hex3,buff_hex4,buff_hex5;
	clock_div scroll_clk(MAX10_CLK1_50, buff_clk);
	defparam scroll_clk.n = 15000000;
	GOBUFFS scroll(buff_clk,a,b,c,d,e,f);
	//////////////////////end GO BUFFS/////////////////
	
	
	//////////////////////LFSR////////////////
	wire LFSR_clk;
	clock_div LFSR_en(clk, LFSR_clk); //LFSR clk shifts the LFSR every cycle. FOr randomness.
	defparam LFSR_en.n = 20000;

	wire[11:0] LFSR_delay;
	LFSR produce_delay(LFSR_clk, LFSR_delay);//outputs random delays
	
	reg [11:0] LFSR_count;
	wire LFSR_ready;
	//counts random delay out. en and count set in state-controlled alwyas block below
	counter LFSR_counter(clk_1kHz, LFSR_en, LFSR_count, LFSR_ready); 
	///////////////////////end LFSR//////////////
	
	////////////////////////FINAL OUTS//////////////////
	reg [6:0] final_hex0,final_hex1,final_hex2,final_hex3,final_hex4,final_hex5;
	//////////////////////////end finals//////////////////////
	
	//state transitions
	/ button state control
	reg[1:0] buttons; 
   always @(negedge KEY[1],posedge KEY[0], posedge LFSR_ready)
   begin
	  if(LFSR_ready)
			buttons = 2;
	  else begin
		if(!KEY[1]) begin
			if(curState == TIMING)begin
				buttons <= 3;
				test_sig <= 0;
				end
			else if (curState == DISPLAYING && SW[5]) 
				buttons <= 0;			
			else if (curState == DELAYING)
				buttons <= 0;	
			else if (curState == HI_SCORE)
				buttons <= 0;
			else buttons <= 3;
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
					curState <= TIMING;
			end
			else if(buttons == 0)
				curState <= HI_SCORE;
			else if(buttons == 1) 
				curState <= DELAYING;
			else if(buttons == 2)
				curState <= TIMING;
			else if(buttons == 3) 
				curState <= DISPLAYING;
		end
  end
	
	
	//state outputs/control signals
	always @(curState)
	 begin
		case(curState)
		  GO_BUFFS: begin
						  LFSR_en = 0;
						  point = 1; //off
						  sevseg_clr = 0;
						end
		  HI_SCORE: begin
						 LFSR_en = 0;
						 time_hex0 <= hi_score_cs;
						 time_hex1 <= hi_score_ds;
						 time_hex2 <= hi_score_s;
						 point = 0;
						 sevseg_clr = 1;
						end
		  TIMING: begin
						LFSR_en = 0;
						time_hex0 <= count_cs;
						time_hex1 <= count_ds;
						time_hex2 <= count_s;
						point = 0;
						sevseg_clr = 1;
					 end
		  DISPLAYING: begin
						    LFSR_en = 0;
							 score_s <= count_s;
							 score_ds <= count_ds;
							 score_cs <= count_cs
							 time_hex0 <= score_cs;
							 time_hex1 <= score_ds;
							 time_hex2 <= score_s;
							 point = 0;
							 sevseg_clr = 1;
							 if ({count_s,count_ds,count_cs} < {hi_score_s, hi_score_ds,hi_score_cs}) begin
								hi_score_s <= count_s;
								hi_score_ds <= count_ds;
								hi_score_cs <= count_cs;
							 end
							 bcd_clear_ <= 0;//reset counter
						  end
		  DELAYING: begin
						  LFSR_count <= LFSR_delay;
						  LFSR_en = 1;
						  time_hex0 <= 0;
						  time_hex1 <= 0;
						  time_hex2 <= 0;
						  point = 0;
						  sevseg_clr = 1;
						  bcd_clear_ <= 1;//rest clear bit so we can count
						end
		endcase
	 end
   
	
	
	
   //Timer SevSeg
   SevenSeg mS(time_hex0, time_hex_out0,0);
   SevenSeg cS(time_hex1, time_hex_out1,0);
   SevenSeg dS(time_hex1, time_hex_out2,0);
	SevenSeg off3(0, time_hex_out2,sevseg_clr);
	SevenSeg off4(0, time_hex_out2,sevseg_clr);
	SevenSeg off5(0, time_hex_out2,sevseg_clr);
	
	//Hi
	
	//GOBUFFS SevSeg
	Sko_SevSeg out0(a, buff_hex0);
	Sko_SevSeg out1(b, buff_hex1);
	Sko_SevSeg out2(c, buff_hex2);
	Sko_SevSeg out3(d, buff_hex3);
	Sko_SevSeg out4(e, buff_hex4);
	Sko_SevSeg out5(f, buff_hex5);
   
   assign HEX0[7] = 1;
   assign HEX1[7] = 1;
   assign HEX2[7] = point;
   assign HEX3[7] = 1;
   

endmodule // Project2_top




