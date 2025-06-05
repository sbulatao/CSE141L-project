module maindec(
  input wire[5:0] op,
	output wire MemToReg,
	output wire MemWrite,
	output wire Branch,
	output wire ALUSrc,
	output wire RegDst,
	output wire RegWrite,
	output wire [1:0] Jump,
	output wire [1:0] ALUOp
    );

	reg[8:0] controls;
	assign {RegWrite, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = controls;

	// Force RegDst = 1'b0 (unused) so that port exists
	assign RegDst = 1'b0;

	always @(*) begin
      case (op[5:3])
			3'b000:controls <= 9'b10000_00_00;   //SGR
			// 3'b000:controls <= 9'b00000_00_00;    //SGR | 000 | 000 | 0000 | RegWrite=1, ALUSrc=0, Branch=0, MemWrite=0, MemToReg=0, Jump=00, ALUOp=00 → ALU does “ADD” or treat as NOP/shift | 000 000 000 | “no-op”/shift-right or test loop |
			3'b001:begin						  //SSR
				case (op[2:0])
					3'b000:controls <= 9'b10001_00_00;	//LWR  | 001 | 000 | 0000 | RegWrite=1, ALUSrc=0, Branch=0, MemWrite=0, MemToReg=1, Jump=00, ALUOp=00 → ALU pass b to form read addr | 001 000 000 | Rdst ← dmem[ DataAddr ] |
					3'b001:controls <= 9'b0001x_00_00;	//STR  | 001 | 001 | 0000 | RegWrite=0, ALUSrc=0, Branch=0, MemWrite=1, MemToReg=X, Jump=00, ALUOp=00 → ALU pass b to form write addr | 001 001 000 | dmem[ DataAddr ] ← Rsrc |
					3'b010:controls <= 9'b0000x_00_00;	//BRC  (≡ group1) | 001 | 010 | 0001 | RegWrite=0, ALUSrc=0, Branch=1, MemWrite=0, MemToReg=0, Jump=00, ALUOp=00 → ALU does “SUB Rsrc1−Rsrc2” | 001 010 001 | if (Rsrc1==Rsrc2) PC←PC+1+imm (imm is zero) |
					// default:controls<= 9'b11111_11_11;	//illegal
					default:controls <= 9'b10000_00_00;  // treat “illegal” as SGR → Branch=0, Jump=00 or PASS THROUGH REG
					// | (any “illegal”) | 001 | xxx | xxxx | controls forced back to 9’b10000_00_00 (SGR) | 001 xxx xxx → treated as 000 000 000 | treat as SGR |
				endcase
			end
			3'b010,
			3'b011: begin
				case (op[2:0])
					3'b101: controls <= 9'b0x10x_00_11;	 //BRC Branch if "equal"/"not equal"
					default: controls <= 9'b11000_00_01; //SI (ADD-imm) | 010 | 000 | 0000 | RegWrite=1, ALUSrc=1, Branch=0, MemWrite=0, MemToReg=0, Jump=00, ALUOp=01 → ALU does “Rdst ← Rsrc + immediate” | 010 000 000 | immediate add, or if FunctBit=0111 then shift left | 
				endcase
			end 
			3'b100:controls <= 9'b10000_0010;	//DR  | 100 | 000 | 0000 | RegWrite=1, ALUSrc=0, Branch=0, MemWrite=0, MemToReg=0, Jump=01, ALUOp=10 → ALU does “SUB or PASS B” | 100 000 000 | compare or pass (rarely used) | 
			3'b101:controls <= 9'b10000_00_01;	//GR  (ADD)| 101 | 000 | 0000 | RegWrite=1, ALUSrc=0, Branch=0, MemWrite=0, MemToReg=0, Jump=00, ALUOp=01 → ALU does “Rdst ← Rsrc1+Rsrc2” | 101 000 000 | reg-reg add |
			3'b110:controls <= 9'b0000x_11_11;	//JR  | 110 | 000 | 0000 | RegWrite=0, ALUSrc=0, Branch=0, MemWrite=0, MemToReg=X, Jump=11, ALUOp=11 → PC←Rsrc | 110 000 000 | jump to whatever is in Rsrc |
			3'b111:controls <= 9'b0x00x_01_11;	//J   0x3F | 111 | 111 | 0000 | RegWrite=0, ALUSrc=0, Branch=0, MemWrite=0, MemToReg=X, Jump=11, ALUOp=11 → PC←0x3F | 111 111 000 | JUMP to 0x3F → next PC=0x40…0xFF (terminate at 0xFF) |
			// default:controls<= 9'b11111_11_11;	//illegal
			default: controls <= 9'b10000_00_00;  // treat “illegal” as SGR → Branch=0, Jump=00 or PASS THROUGH REG
			// | (any “illegal”) | 001 | xxx | xxxx | controls forced back to 9’b10000_00_00 (SGR) | 001 xxx xxx → treated as 000 000 000 | treat as SGR |
		endcase
	end
endmodule