module Project2_top(
//////////// CLOCK //////////
		    input 	 ADC_CLK_10,
		    input 	 MAX10_CLK1_50,
		    input 	 MAX10_CLK2_50,
		    
		    //////////// SEG7 //////////
		    output [7:0] HEX0,
		    output [7:0] HEX1,
		    output [7:0] HEX2,
		    output [7:0] HEX3,
		    output [7:0] HEX4,
		    output [7:0] HEX5,
		    
		    //////////// KEY //////////
		    
		    input [1:0]  KEY,
		    
		    //////////// LED //////////
		    output [9:0] LEDR,
		    
		    //////////// SW //////////
		    input [9:0]  SW
		    );
			 
			 wire clk_out;
			 
//	reg [2:0] currState,nextState;
//	assign LED[8:6] = currState; //display state on LEDs
//	reg [1:0] buttons;
//	wire clk_50MHZ;
//	assign clk_50MHZ = MAX10_CLK1_50;
//	wire clk_1kHz;
//	
//	reg [9:0] ReacTime;
//	reg [20:0] HEX_out;
//	
//	 //Button sate control
//   always @(posedge KEY[1])
//     begin
//	buttons[1] = ~buttons[1];
//     end
//   always @(posedge KEY[0])
//     begin
//		buttons[0] = ~buttons[0];
//     end
//	  
//	 detState stateMachine(buttons, clk_50MHZ,SW[9]);
//	 clk_divider(clk_50MHZ, clk_1kHZ);
//	 
//	 always @ (currState)
//		begin
//			if (currState == COUNTING) begin
//				timer Counter(clk_1kHZ, ReacTime);
//		end
//		
//		dispTime BCD(ReacTime, HEX_out);
//		
//		assign HEX0 = HEX_out[7:0];
		
	 clock_div test1(MAX10_CLK1_50, clk_out);
	 defparam test1.n = 50000000;
	 assign LEDR[0] = clk_out;
	 
	 endmodule
	 