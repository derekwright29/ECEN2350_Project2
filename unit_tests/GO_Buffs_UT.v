module GO_Buffs_UT(

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

wire buff_clk;
wire [3:0] a,b,c,d,e,f;

clock_div scroll_clk(MAX10_CLK1_50, buff_clk);
GOBUFFS scroll(buff_clk,a,b,c,d,e,f);


Sko_SevSeg out0(buff_clk,a, HEX0[6:0]);
Sko_SevSeg out1(buff_clk,b, HEX1[6:0]);
Sko_SevSeg out2(buff_clk,c, HEX2[6:0]);
Sko_SevSeg out3(buff_clk,d, HEX3[6:0]);
Sko_SevSeg out4(buff_clk,e, HEX4[6:0]);
Sko_SevSeg out5(buff_clk,f, HEX5[6:0]);
assign HEX0[7] = 1;
assign HEX1[7] = 1;
assign HEX2[7] = 1;
assign HEX3[7] = 1;
assign HEX4[7] = 1;
assign HEX5[7] = 1;

endmodule
