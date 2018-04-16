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

wire LFSR_clk, clk_1kHz;
assign LEDR[5] = clk_1kHz;
clock_div LFSR_en(MAX10_CLK1_50, LFSR_clk);
defparam LFSR_en.n = 20000;
clock_div clk_ms(MAX10_CLK1_50, clk_1kHz);
defparam clk_ms.n = 25000;

wire[11:0] LFSR_delay;
LFSR produce_delay(LFSR_clk, LFSR_delay);

reg button;
wire LFSR_ready;

reg [11:0] LFSR_count;
always @(posedge KEY[1])
begin
	button = ~button;
	LFSR_count <= LFSR_delay;
end

//clk, enable, count_to, done
counter LFSR_counter(clk_1kHz, button, LFSR_count, LFSR_ready);

counter test(clk_1kHz, SW[9], 2000, LEDR[9]);



SevenSeg Lf0(LFSR_count[3:0],HEX0[6:0],0);
SevenSeg Lf1(LFSR_count[7:4],HEX1[6:0],0);
SevenSeg Lf2(LFSR_count[11:8],HEX2[6:0],0);

assign LEDR[0] = LFSR_ready;
SevenSeg off3(,HEX3[6:0],1);
SevenSeg off4(,HEX4[6:0],1);
SevenSeg off5(,HEX5[6:0],1);
assign HEX0[7] = 1;
assign HEX1[7] = 1;
assign HEX2[7] = 1;
assign HEX3[7] = 1;
assign HEX4[7] = 1;
assign HEX5[7] = button;

endmodule // LFSR_ut
