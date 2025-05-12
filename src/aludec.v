module aludec(
  input wire[1:0] ALUOp,
	input wire[3:0] FunctBit,
	output reg[2:0] ALUControl
    );
	always @(*) begin
		case (ALUOp)
			2'b00: begin
				case (FunctBit)
					4'b0000: ALUControl <= 3'b000; //add 
					4'b0001: ALUControl <= 3'b001; //sub
					4'b0010: ALUControl <= 3'b010; //and
					4'b0011: ALUControl <= 3'b011; //or
					4'b0101: ALUControl <= 3'b101; //and()
					4'b0110: ALUControl <= 3'b110; //or()
					4'b1000, 4'b1001: ALUControl <= 3'b100;	//pass (don't need alu)
				endcase
			end
			2'b01: begin
				case (FunctBit)
					4'b0000: ALUControl <= 3'b000; //add 
					4'b0001: ALUControl <= 3'b001; //sub
					4'b0010: ALUControl <= 3'b100; //pass (out = b)
					4'b0111: ALUControl <= 3'b111; //<<
					default: ALUControl <= 3'b100; //pass (don't need alu)
				endcase
			end
			2'b10: begin
				case (FunctBit[3])
					1'b0: ALUControl <= 3'b001; //sub for EQ
					1'b1: ALUControl <= 3'b100; //pass (don't need alu)
				endcase
			end
			2'b11: ALUControl <= 3'b100; //pass (don't need alu)
		endcase
	end
endmodule