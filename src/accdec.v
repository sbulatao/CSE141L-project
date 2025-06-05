module accdec(
  	input wire[5:0] op,
	output reg[2:0] AccControl
	);

// model 0:
//			rd1_temp <= rf[ra1];
//          rd2_temp <= rf[ra2];
// model 1:
//          rd1_temp <= rf[ra1];
//          rd2_temp <= acc;
// model 2: 
//          rd1_temp <= acc;
//          rd2_temp <= rf[ra2];

	always @(*) begin
		case (op[5:3])
			3'b000: begin 
				case (op[2:0])
					3'b000,3'b001,3'b010,3'b011,3'b100: AccControl <= 3'b010;	// model2: acc = acc +-&| rs SR
					3'b101,3'b110, 3'b110: AccControl <= 3'b001;		// model1: acc = &|(acc)	 SR
				endcase
			end
			3'b001: begin
				case (op[2:0])
					3'b000: AccControl <= 3'b000; // model0: LWR acc = Mem(rs)	LS
					3'b001: AccControl <= 3'b010; // model2: STR Mem(rs) = acc	LS
					default: AccControl <= 3'b000; // or whatever fallback
				endcase
			end
			3'b010: AccControl <= 3'b010;	// model2: acc = acc +-&| imm	SI
			3'b100: AccControl <= 3'b000;	// model0: EQ rs rt				DR
          	3'b110: AccControl <= 3'b001;	// model1: JR acc -> rd2 -> pc	J
			3'b111: AccControl <= 3'b000;	// model0: jump					J
			3'b101: AccControl <= 3'b101;	// model1: MOV rs<-acc			GR
			default: AccControl <= 3'b000;	// invalid
		endcase
	end
endmodule