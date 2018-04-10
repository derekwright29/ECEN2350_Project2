module LFSR(enable, LF_shift_reg, ready);
   input enable;
   output [11:0] LF_shift_reg;
   output 	ready;
   
   wire 	in_shift;
   
   if (enable)
     begin
	in_shift = LF_shift_reg[9] ^ LF_shift_reg[5];
	LF_shift_reg = {LF_shift_reg[8:0],in_shift};
	if (LF_shift_reg < 500)
	  ready = 0;
	else
	  ready = 1;
     end
endmodule // LFSR

     
