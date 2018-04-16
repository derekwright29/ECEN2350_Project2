//check this out: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
// Try to find a 12-bit Fib LFSR... 
// would be good.
//The 16-bit Fibonnaci LFSR can go through all 65535 states. Good one. 
// BUT, 65 seconds is probably toooo long.

module LFSR(enable, LF_shift_reg);
   input enable;
   output reg [11:0] LF_shift_reg;
   reg 		in_shift;

   always @ (posedge enable)
     begin
		if(!LF_shift_reg)
			LF_shift_reg <= 12'b101101110110;
			else begin
	     in_shift <= LF_shift_reg[11] ^ LF_shift_reg[10];
	     LF_shift_reg <= {LF_shift_reg[10:0],in_shift};
		  end
     end
endmodule // LFSR


