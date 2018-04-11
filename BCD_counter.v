//Before class on Wednesday
module BCD_counter_old(clk, enable, data, ovr);
   input clk,enable;
   output reg [12:0] data;
   output reg		   ovr;
   
   always @(posedge clk)
     begin
	if (enable)
	  begin
	     data[3:0] = data[3:0] + 1;
	     if (data[3:0] > 9)
	       begin
		  data[3:0] = 0;
		  data[7:4] = data[7:4] + 1;
		  if(data[7:4] > 9)
		    begin
		       data[7:4] = 0;
		       data[11:8] = data[11:8] + 1;
		       if (data[11:8] > 9)
			 begin
			    data[11:8] = 0;
			    data[15:12] = data[15:12] + 1;
			    if (data[15:12] > 9)
			      begin
				 data[15:12] = 0;
				 ovr = 1;
			      end			 
			 end		       
		    end		  
	       end	     			 
	  end	    
     end
	
endmodule // BCD_counter


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
			count = 0;
		else if(enable)
		begin
			if(!load_)
			begin
				count <= data; //data will be passed as 0 for this module
				RCO = 1;
			end
			else
			begin
				count = count + 1;
				RCO = 0;
			end
		end
	end




endmodule










	
module counter(clk, _reset, enable, count_to, done);
   parameter k = 12;
  
   input clk, _reset, enable;
   input [k-1:0] count_to;
   output 	reg done;

   reg [k-1:0]  count;

   always @(posedge clk, negedge _reset)
     begin
	if(! _reset)
	  count = 0;
	else if(enable)
	  count = count + 1;
	if(count == count_to)
	  done = 1;
	else
	  done = 0;
     end
endmodule // counter

   
