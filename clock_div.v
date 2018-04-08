module clock_div(clk, new_clk);
   parameter n = 50000; //for 1kHz clock_out
   input clk;
   output reg new_clk;
   
   reg [25:0] count;// Gives a lowest clock freq of ~1Hz
   
   
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
	