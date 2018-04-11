//check this out: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
// Try to find a 12-bit Fib LFSR... 
// would be good.
//The 16-bit Fibonnaci LFSR can go through all 65535 states. Good one. 
// BUT, 65 seconds is probably toooo long.

module LFSR(enable, LF_shift_reg, ready);
   input enable;
   output [11:0] LF_shift_reg;
   output 	ready;
   
   reg 		in_shift;
   
   if (enable)
     begin
	in_shift = LF_shift_reg[9] ^ LF_shift_reg[5];
	LF_shift_reg = {LF_shift_reg[8:0],in_shift};
	if (LF_shift_reg < 500)
	  ready = 0;
	else if (LF_shift_reg > 5000
	  ready = 1;
     end
endmodule // LFSR

     
