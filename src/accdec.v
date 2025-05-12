module accdec(
  	input wire[5:0] op,
	output reg[2:0] AccControl
	);

	always @(*) begin
		case (op[5:3])
			3'b000: begin 
				case (op[2:0])
					3'b000,3'b001,3'b010,3'b011: AccControl <= 3'b001;	// model1: acc = acc f rs	SGR
					3'b101,3'b110: AccControl <= 3'b010;				// model2: acc = f(acc)		SGR
				endcase
			end
			3'b001: begin
				case (op[5:3])
					3'b000: AccControl <= 3'b110;		// model6: acc = mem(imm)	SSR
					3'b001: AccControl <= 3'b101;		// model5: mem(imm) = acc	SSR
				endcase
			end
			3'b010: AccControl <= 3'b001;	// model1: acc = acc + imm	SI
			3'b100: AccControl <= 3'b011;	// model3: EQ rs rt			DR
			3'b111: AccControl <= 3'b100;	// model4: jump				JMP
			3'b101: AccControl <= 3'b111;	// model7: LWR rs<-imm		RI
			default: AccControl <= 3'b000;	// invalid
		endcase
	end
endmodule