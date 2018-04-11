module BCD_counter(clk, enable, data, ovr);
   input clk,enable;
   output reg [12:0] data;
   output 	     ovr;
   
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

	
module counter(clk, _reset, enable, count_to, done);
   paramter k = 12;
  
   input clk, _reset, enable;
   input [k-1:0] count_to;
   output 	 done;

   wire [k-1:0]  count;

   always @(posedge clk, negedge _reset)
     begin
	if(!reset)
	  count = 0;
	else if(enable)
	  count = count + 1;
	if(count == count_to)
	  done = 1;
	else
	  done = 0;
     end
endmodule // counter

   
