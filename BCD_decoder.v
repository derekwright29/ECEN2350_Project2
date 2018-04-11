module BCD_decoder(count,display, cout);
   input [3:0] count;
   output reg [3:0] display;
   output 	    cout;

   always @(count)
     begin
	display = count % 10;
	cout = (count > 9) ? 1:0;
     end
endmodule // BCD_decoder
/*
 * 
   
   always @(count)
     begin
	display[3:0] = display[3:0] + 1;
	//greater than 9
	if(display[3:0] > 9) begin
			display[3:0] = 0;
	   display[7:4] = display[7:4] + 1;
	   
	   //greater than 99?
	   if(display[7:4] > 9) begin
	      display[7:4] = 0;
	      display[11:8] = display[11:8] + 1;
	      
	      //greater than 999?
	      if (display[11:8] > 9) begin
		 display[11:8] = 0;
		 display[15:12] = display[15:12] + 1;
	      end
	   end
	   
	end
	
     end
   
   
endmodule
 */
