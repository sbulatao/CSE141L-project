module maindec(
  input wire[5:0] op,
	output wire MemToReg,
	output wire MemWrite,
	output wire Branch,
	output wire ALUSrc,
	// output wire RegDst,
	output wire RegWrite,
	output wire [1:0] Jump,
	output wire [1:0] ALUOp
    );

	reg[8:0] controls;
	assign {RegWrite, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = controls;

	// Force RegDst = 1'b0 (unused) so that port exists
	// assign RegDst = 1'b0;

	always @(*) begin
      case (op[5:3])
			3'b000:controls <= 9'b10000_00_00;   //SR
			// 3'b000:controls <= 9'b00000_00_00; 
			3'b001:begin						 //LS
				case (op[2:0])
					3'b000:controls <= 9'b10001_00_00;	//LWR 
					3'b001:controls <= 9'b0001x_00_00;	//STR 
					// 3'b010:controls <= 9'b0000x_00_00; // we don't have it
					// default:controls<= 9'b11111_11_11;	//illegal
					default:controls <= 9'b10000_00_00;  // treat “illegal” as SR → Branch=0, Jump=00 or PASS THROUGH REG
				endcase
			end
			3'b010,								// SI
			3'b011: begin						// we don't have 011
				case (op[2:0])
					3'b101: controls <= 9'b0x10x_00_11;	 //BRC Branch if "equal"/"not equal"
					default: controls <= 9'b11000_00_01; //SI (ADD-imm) | 010 | 000 | 0000 | RegWrite=1, ALUSrc=1, Branch=0, MemWrite=0, MemToReg=0, Jump=00, ALUOp=01 → ALU does “Rdst ← Rsrc + immediate” | 010 000 000 | immediate add, or if FunctBit=0111 then shift left | 
				endcase
			end 
			3'b100:controls <= 9'b10000_0010;	// DR
			3'b101:controls <= 9'b10000_00_01;	// GR
			3'b110:controls <= 9'b0000x_11_11;	// JR
			3'b111:controls <= 9'b0x00x_01_11;	// J
			// default:controls<= 9'b11111_11_11;	//illegal
			default: controls <= 9'b10000_00_00;  // treat “illegal” as SGR → Branch=0, Jump=00 or PASS THROUGH REG
		endcase
	end
endmodule