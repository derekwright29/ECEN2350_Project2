module clock_div(clk, new_clk);
   parameter n = 25000; //for 1kHz clock_out 50M/25k/2 = 1k
   input clk;
   output reg new_clk;
   
   reg [25:0] count;// Gives a lowest clock freq of ~1/2 Hz
   
   
   always @(posedge clk)
   begin
      if (count == n)
		begin
			count = 0;
			new_clk = ~new_clk;
		end
		else
			count = count + 1;
   end
	
	endmodule
	