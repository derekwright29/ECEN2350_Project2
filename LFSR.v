//check this out: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
// Try to find a 12-bit Fib LFSR... 
// would be good.
//The 16-bit Fibonnaci LFSR can go through all 65535 states. Good one. 
// BUT, 65 seconds is probably toooo long.

module LFSR(enable, LF_shift_reg, ready);
   input enable;
   output reg [11:0] LF_shift_reg;
   output reg	ready;
   
   reg 		in_shift;

   always @ (posedge enable)
     begin
//	while(!ready) //top currently has this wait-til ready functionality.
//	  begin
	     in_shift = LF_shift_reg[11] ^ LF_shift_reg[5];
	     LF_shift_reg = {LF_shift_reg[10:0],in_shift};
	     if (LF_shift_reg < 500)
	       ready = 0;
	     else
	       ready = 1;
//	  end
	
     end
endmodule // LFSR


