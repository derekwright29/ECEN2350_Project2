//after class on Monday
module BCD_counter(clk,enable,clear_,data, count,RCO);
	input clk, enable, clear_;
	input [3:0] data;
	output reg RCO;
	output reg [3:0] count;
	
	wire load_;
	assign load_ = ~(count[3] & count[0]);
	
	always @(posedge clk, negedge clear_)
	begin
		if (!clear_)
			count <= 0;
		else if(enable)
		begin
			if(!load_)
			begin
				count <= data; //data will be passed as 0 for this module
				RCO <= 1;
			end
			else
			begin
				count <= count + 1;
				RCO <= 0;
			end
		end
	end

endmodule
	
	
	//TODO: produce reliable reset signal
module counter(clk, enable, count_to, done);
   parameter k = 12;
  
   input clk, enable;
   input [k-1:0] count_to;
   output reg done;

   reg [k-1:0]  count = 0;
	
	
   always @(posedge clk)
     begin
	  if(enable) begin
		 count <= count + 1;
		 if(count == count_to)
			done <= 1;
	  end
	  else begin
			count <= 0;
			done <= 0;
			end
   end
endmodule // counter

   
