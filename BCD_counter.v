module BCD_counter(clk, count);
	input clk;
	output reg [12:0] count;
	
	always @(posedge clk)
	begin
		count = count + 1;
	end
	
endmodule
	