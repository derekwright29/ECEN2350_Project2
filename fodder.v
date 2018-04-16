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
   
   //reg [2:0] curState;
   reg [2:0] 		     nextState;
   
//defining states
   parameter HI_SCORE = 3'b000;
   parameter DELAYING = 3'b001;
   parameter TIMING = 3'b010;
   parameter DISPLAYING = 3'b011;
   parameter GO_BUFFS = 3'b1xx; //last two digits are don't cares.
   
   wire [2:0] 		     curState;
   
   wire 		     LFSR_delay_ready;
   reg 			     LFSR_LED;
   
reg [3:0] hi_score_cs, hi_score_ds,hi_score_s;
   initial
     begin
	hi_score_cs = 9;
	hi_score_ds = 9;
	hi_score_s = 9;
     end
   reg [3:0] score_cs,    score_ds,    score_s;
   
   
   wire [6:0] hex_out0,hex_out1,hex_out2,hex_out3,hex_out4,hex_out5;
   wire       time_clear,decimal_pt;
   
   
   //////////////////////BCD_CODE////////////////////////////////////
   
   //BCD module arguments: clk,enable,clear_,data, count,RCO
   
   wire       clk_1kHz;
   //wire load_ms, load_cs, load_ds, load_s;
   wire       RCO_ms,RCO_cs,RCO_ds, RCO_s;
   wire [3:0] count_ms;
   wire [3:0] count_cs;
   wire [3:0] count_ds;
   wire [3:0] count_s;
   wire [6:0] time_hex0,time_hex1,time_hex2,time_hex3,time_hex4,time_hex5;
   
   clock_div clk_ms(MAX10_CLK1_50, clk_1kHz);
   
   
   BCD_counter time_ms(clk_1kHz, 	1, 1, 0, count_ms, RCO_ms);
   BCD_counter time_cs(RCO_ms, 1, 1, 0, count_cs, RCO_cs);
   BCD_counter time_ds(RCO_cs, 1, 1, 0, count_ds, RCO_ds);
   BCD_counter time_s(RCO_ds, 1, 1, 0, count_s, RCO_s);
   
   SevenSeg timer_cs(count_cs, time_hex0);
   SevenSeg timer_ds(count_ds, time_hex1);
   SevenSeg timer_s(count_s, time_hex2);
   SevenSeg off1(0,time_hex3, time_clear);
   SevenSeg off2(0, time_hex4, time_clear);
   SevenSeg off3(0, time_hex5, time_clear);
   

   /////////////////////END_BCD//////////////////////////
   
   /////////////////////GO_BUFFS///////////////////////////
   
   wire       buff_clk;
   wire [3:0] a,b,c,d,e,f;
   wire    test_led;
   assign LEDR[5] = test_led;
   clock_div scroll_clk(MAX10_CLK1_50, buff_clk);
   defparam scroll_clk.n = 10000000;
   GOBUFFS scroll(buff_clk,a,b,c,d,e,f);
   wire    deecimal_pt;
   wire [6:0] buff_hex0,buff_hex1,buff_hex2,buff_hex3,buff_hex4,buff_hex5;
   
   
   Sko_SevSeg out0(a, buff_hex0);
   Sko_SevSeg out1(b, buff_hex1);
   Sko_SevSeg out2(c, buff_hex2);
   Sko_SevSeg out3(d, buff_hex3);
   Sko_SevSeg out4(e, buff_hex4);
   Sko_SevSeg out5(f, buff_hex5);
   
   
   assign HEX0[7] = 1;
   assign HEX1[7] = 1;
   assign HEX2[7] = decimal_pt;
   assign HEX3[7] = 1;
   assign HEX4[7] = 1;
   assign HEX5[7] = 1;
   ///////////////////END_GO_BUFFS////////////////////////////////////
   
   
   //TODO: remember to set FLSR_ready to 0 if not in DELAYING state. somewhere else
   //define state transitions
   always @(SW[9], posedge KEY[0], negedge KEY[0],negedge KEY[1], posedge LFSR_delay_ready)
     begin
	case(curState)
	  GO_BUFFS: if(SW[9]) nextState = GO_BUFFS;
	  else nextState = HI_SCORE;
	  HI_SCORE: if(KEY[0]) nextState = DELAYING;
	  else nextState = HI_SCORE;
	  DELAYING: if(LFSR_delay_ready) begin 
	     nextState = TIMING;
	     LFSR_LED = 1; end
	  else if (!KEY[1]) nextState = HI_SCORE;
	  else nextState = DELAYING;
	  TIMING: if(!KEY[0]) begin 
	     nextState = DISPLAYING;
	     LFSR_LED = 0; end
	     else nextState = TIMING;
	  DISPLAYING: if(!KEY[1]) nextState = HI_SCORE;
	  else nextState = DISPLAYING;
	endcase
     end
   
   //latch state on 50MHz clk
   always @(posedge MAX10_CLK1_50)
     begin
	curState <= nextState;
     end
   
   //TODO: multiplex SevSeg clear bits
   //multiplex outputs based on state
   always@(curState)
     begin
	LFSR_ready = 0;
	case(curState)
	  GO_BUFFS: begin 
	     hex0[3:0] <= a;
	     hex1[3:0] <= b;
	     hex2[3:0] <= c;
	     hex3[3:0] <= d;
	     hex4[3:0] <= e;
	     hex5[3:0] <= f;
	     decimal_pt = 1;
	  end
	  HI_SCORE: begin
	     hex0[3:0] <= hi_score_cs;//cs
	     hex1[3:0] <= hi_score_ds;//ds
	     hex2[3:0] <= hi_score_s;//s
	     time_clear = 1; //off
	     decimal_pt = 0;
	  end
	  DELAYING: begin 
	     delay_clear = 1;
	     decimal_pt = 0;
	  end
	  TIMING: begin
	     hex0[3:0] = count_cs[3:0];//cs
	     hex1[3:0] = count_ds[3:0];//ds
	     hex2[3:0] = count_s[3:0];//s
	     time_clear = 1; //off
	     decimal_pt = 0;
	  end
	  DISPLAYING: begin
	     hex0[3:0] = score_cs;//cs
	     hex1[3:0] = score_ds;//ds
	     hex2[3:0] = score_s;//s
	     time_clear = 1; //off
	     decimal_pt = 0;
	  end
	endcase
     end
   
   always @(curState)
     begin
	if(curState == GO_BUFFS)
	  begin
	     hex_out0 <= buff_hex0;
	     hex_out1 <= buff_hex1;
	     hex_out2 <= buff_hex2;
	     hex_out3 <= buff_hex3;
	     hex_out4 <= buff_hex4;
	     hex_out5 <= buff_hex5;
	  end
	else
	  begin
	     hex_out0 <= time_hex0;
	     hex_out1 <= time_hex1;
	     hex_out2 <= time_hex2;
	     hex_out3 <= time_hex3;
	     hex_out4 <= time_hex4;
	     hex_out5 <= time_hex5;
	  end
     end
   
   //LED outs
   assign LEDR[6:4] = currState;
   assign LEDR[0] = LFSR_LED;
   //Hex outs
   assign HEX0[6:0] = hex_out0;
   assign HEX1[6:0] = hex_out1;
   assign HEX2[6:0] = hex_out2;
   assign HEX3[6:0] = hex_out3;
   assign HEX4[6:0] = hex_out4;
   assign HEX5[6:0] = hex_out5;
   
   
endmodule







wire [12:0] ReacTime; //means we can go up to 8.191 seconds
	wire [15:0] HEX_out;
	
	wire LFSR_count_enable;





//=======================================================
//  Structural coding
//=======================================================

//	
//	 //Button sate control
//   always @(posedge KEY[1])
//     begin
//	buttons[1] = ~buttons[1];
//     end
//   always @(posedge KEY[0])
//     begin
//		buttons[0] = ~buttons[0];
//     end
//	  
//	 stateMachine detState(clk_50MHZ, currState, nextState);
//	 clk_divider(clk_50MHZ, clk_1kHZ);
//	 
//	 always @ (currState)
//		begin
//			if (currState == COUNTING) begin
//				timer BCD_counter(clk_1kHZ, ReacTime);
//		end
//		
//		dispTime BCD(ReacTime, HEX_out);
//		
//		assign HEX0 = HEX_out[7:0];

   wire LFSR_ready, LFSR_en,delay_over;
   reg [9:0] LFSR_out;
 
// attempt: doesn't compile. Probably because of while/generate combo...
//   always @(posedge LFSR_en)
//     begin
//		generate
//			while(!LFSR_ready)
//				begin
//					LFSR get_delay0(LFSR_en, LFSR_out, LFSR_ready);
//				end
//	   endgenerate
//		LFSR_ready = 0; //reset for next time
//		LFSR_count_enable = 1;
//     end
   
   counter wait_delay(clk_1kHz, 1, LFSR_count_enable, LFSR_out, delay_over);
		

   clock_div test1(MAX10_CLK1_50, clk_1kHz);
   BCD_counter timer1(clk_1kHz, ReacTime);
   BCD_decoder BCD(ReacTime, HEX_out);
