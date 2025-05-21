`include "maindec.v"
`include "aludec.v"
`include "accdec.v"

module controller(
	input wire[5:0] op,
	input wire BranchFlag,

	output wire MemToReg,
	output wire MemWrite,
	output wire PcSrc,
	output wire ALUSrc,
	output wire RegWrite,
	output wire[1:0] Jump,
  	output wire[2:0] ALUControl,

  	output wire[2:0] AccControl
    );

	wire[1:0] ALUOp;
	wire Branch;

 	maindec md_inst (
        .op (op),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .Branch  (Branch),
        .ALUSrc  (ALUSrc),
        .RegWrite(RegWrite),
        .Jump    (Jump),
        .ALUOp   (ALUOp)
    );

	aludec ad_inst (
        .ALUOp     (ALUOp),
        .FunctBit  (op[3:0]),
        .ALUControl(ALUControl)
    );

    accdec ac_inst(
  	    .op         (op),
	    .AccControl (AccControl)
	);

	assign PcSrc = Branch & BranchFlag;
    
endmodule