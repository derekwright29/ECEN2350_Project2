module BCD_counter_ut(

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

//BCD module arguments: clk,enable,clear_,data, count,RCO


//wire load_ms, load_cs, load_ds, load_s;
wire RCO_ms,RCO_cs,RCO_ds, RCO_s;
wire [3:0] count_ms;
wire [3:0] count_cs;
wire [3:0] count_ds;
wire [3:0] count_s;
wire clk_1kHz;
clock_div clk_ms(MAX10_CLK1_50, clk_1kHz);


BCD_counter time_ms(clk_1kHz, SW[9], SW[8], 0, count_ms, RCO_ms);
BCD_counter time_cs(RCO_ms, SW[9], SW[8], 0, count_cs, RCO_cs);
BCD_counter time_ds(RCO_cs, SW[9], SW[8], 0, count_ds, RCO_ds);
BCD_counter time_s(RCO_ds, SW[9], SW[8], 0, count_s, RCO_s);

SevenSeg timer_cs(count_cs, HEX0[6:0]);
SevenSeg timer_ds(count_ds, HEX1[6:0]);
SevenSeg timer_s(count_s, HEX2[6:0]);

assign HEX2[7] = 0;
assign HEX0[7] = 1;
assign HEX1[7] = 1;
assign HEX3[7] = 1;
assign HEX4[7] = 1;
assign HEX5[7] = 1;

SevenSeg(0,HEX3[6:0],1);
SevenSeg(0,HEX4[6:0],1);
SevenSeg(0,HEX5[6:0],1);

endmodule
