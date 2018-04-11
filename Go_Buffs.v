module GOBUFFS(clk, enable,values, out_reg);
   input clk,enable;
   input [8:0] values; //[GO BUFFS ]
   
   parameter G= 7'b0000100, O =7'b1000000 , F = 7'b0001110;
   
   
   always @(posedge clk)
     begin
	if (enable)
	  out_reg = out_reg[]
     end

endmodule // GOBUFFS
