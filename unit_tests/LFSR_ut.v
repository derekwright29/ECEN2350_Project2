module LFSR_ut(

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

wire LFSR_clk;
wire [11:0] LFSR_out;
wire [11:0] int_LFSR;
wire ready;

clock_div LFSR_en(MAX10_CLK1_50, LFSR_clk);
defparam LFSR_en.n = 60000000;

LFSR LFSR_test(LFSR_clk,LFSR_out, ready);

SevenSeg Hex0(LFSR_out[3:0], HEX0[6:0],0);
SevenSeg Hex1(LFSR_out[7:4], HEX1[6:0],0);
SevenSeg Hex2(LFSR_out[11:8], HEX2[6:0],0);



assign LEDR[4] = LFSR_clk;
assign LEDR[0] = ready;

SevenSeg off3(,HEX3[6:0],1);
SevenSeg off4(,HEX4[6:0],1);
SevenSeg off5(,HEX5[6:0],1);
assign HEX0[7] = 1;
assign HEX1[7] = 1;
assign HEX2[7] = 1;
assign HEX3[7] = 1;
assign HEX4[7] = 1;
assign HEX5[7] = 1;

endmodule
