module maindec(
  input wire[5:0] op,
	output wire MemToReg,
	output wire MemWrite,
	output wire Branch,
	output wire ALUSrc,
	output wire RegWrite,
	output wire [1:0] Jump,
	output wire [1:0] ALUOp
    );

	reg[8:0] controls;
	assign {RegWrite, ALUSrc, Branch, MemWrite, MemToReg, Jump, ALUOp} = controls;

	always @(*) begin
      case (op[5:3])
			3'b000:controls <= 9'b10000_00_00;	//SGR
			3'b001:begin						//SSR
				case (op[2:0])
					3'b000:controls <= 9'b11001_00_00;	//LWR
					3'b001:controls <= 9'b0101x_00_00;	//STR
					3'b010:controls <= 9'b0000x_00_00;	//BRC
					default:controls<= 9'b11111_11_11;	//illegal
				endcase
			end
			3'b010,
			3'b011: begin
				case (op[2:0])
					3'b101: controls <= 9'b0x10x_00_11;	//BRC
					default: controls <= 9'b11000_00_01;	//SI
				endcase
			end 
			3'b100:controls <= 9'b10000_0010;	//DR
			3'b101:controls <= 9'b10000_00_01;	//GR
			3'b110:controls <= 9'b0000x_11_11;	//JR
			3'b111:controls <= 9'b0x00x_01_11;	//J
			default:controls<= 9'b11111_11_11;	//illegal
		endcase
	end
endmodule