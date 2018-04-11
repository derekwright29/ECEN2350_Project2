module GOBUFFS(clk, a,b,c,d,e,f);
   input clk;
   output reg [3:0] a; //[GO BUFFS  ]
	output reg [3:0] b;
	output reg [3:0] c;
	output reg [3:0] d;
	output reg [3:0] e;
	output reg [3:0] f;
    initial
	 begin
		a= 0;
		b=1;
		c=2;
		d=3;
		e=4;
		f=5;
	 end

   always @(posedge clk)
     begin
		a = a+ 1;
		b=b+1;
		c=c+1;
		d=d+1;
		e = e+1;
		f=f+1;	
		end

endmodule // GOBUFFS

module Sko_SevSeg(input clk, input [3:0] char, output reg[6:0] HEX_out);

   parameter G = 0, O = 1, SPACE = 2, B = 3, U = 4, F1 = 5, F2 = 6, S = 7, END1 = 8, END2 = 9;
  
	always @(negedge clk)
	begin
		case(char)
			G:		 HEX_out <= 7'b1000010;
			O: 	 HEX_out <= 7'b1000000;
			SPACE: HEX_out <= 7'b1111111;
			B: 	 HEX_out <= 7'b0000011;
			U: 	 HEX_out <= 7'b0010011;
			F1: 	 HEX_out <= 7'b0001110;
			F2: 	 HEX_out <= 7'b0001110;
			S: 	 HEX_out <= 7'b0010010;
			END1:  HEX_out <= 7'b1111111;
			END2:  HEX_out <= 7'b1111111;
			default: HEX_out <= 7'b1111111;
		endcase
		
	end
	
	endmodule