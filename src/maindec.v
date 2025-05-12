module maindec(
  input wire[5:0] op,
	output wire MemToReg,
	output wire MemWrite,
	output wire Branch,
	output wire ALUSrc,
	// output wire RegDst,
	output wire RegWrite,
	output wire Jump,
	output wire [1:0] ALUOp
    );

	reg[7:0] controls;
	assign {RegWrite, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = controls;

	always @(*) begin
      case (op[5:3])
			3'b000:controls <= 8'b1000_0000;	//SGR
			3'b001:begin						//SSR
				case (op[2:0])
					3'b000:controls <= 8'b1100_1000;	//LWR
					3'b001:controls <= 8'b0101_x000;	//STR
					3'b010:controls <= 8'b0000_x000;	//BRC
					default:controls<= 8'b1111_1111;	//illegal
				endcase
			end
			3'b010,
			3'b011: begin
				case (op[2:0])
					3'b101: controls <= 8'b0x10_x011;	//BRC
					default: controls <= 8'b1100_0001;	//SI
				endcase
			end 
			3'b100:controls <= 8'b1000_0010;	//DR
			3'b101:controls <= 8'b1100_0001;	//RI
			3'b111:controls <= 8'b0000_x111;	//J
			default:controls<= 8'b1111_1111;	//illegal
		endcase
	end
endmodule