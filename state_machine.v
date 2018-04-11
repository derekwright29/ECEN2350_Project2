//module stateMachine(clk, state_inputs, state);
//   always @(state_inputs)
//     begin
//	case (state_inputs)
//		2: state = COUNTING;
//		default: state = WAITING;
//	endcase // case (state_inputs)
//     end
//endmodule // stateMachine


module state_decoder(state, enables);
   input [2:0] state;
   output reg [5:0] enables;

   always @(state)
     begin
	case(state)
	  0: enables <= 5'b00001;
	  1: enables <= 5'b00010;
	  2: enables <= 5'b00100;
	  3: enables <= 5'b01000;
	  3'b1xx: enables <= 5'b10000;
	  //default: enables <= 5'b00001;
	endcase // case (state)
     end // always @ (state)
endmodule // state_decoder

