`include "controller.v"
`include "datapath.v"

module mips(
	input wire      clk,
    input wire      rst,
    input wire[7:0] ReadData,
	input wire[8:0] inst,
    output wire[7:0] pc,
	output wire     MemWrite,
	output wire[7:0] ALUOut,
    output wire[7:0] rd2_Data
    );
	
    wire [5:0] op;
    wire BranchFlag;
    wire overflow;
    wire MemToReg;
    wire PcSrc;
    wire ALUSrc;
    wire RegWrite;
    wire [1:0] Jump;
    wire [2:0] ALUControl;
    wire [2:0] AccControl;

	assign op = inst[8:3];

	controller ctrl_inst (
        .op(op),
        .BranchFlag(BranchFlag),
        .MemToReg(MemToReg),
        .MemWrite(MemWrite),
        .PcSrc(PcSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUControl(ALUControl),
        .AccControl(AccControl)
    );

    datapath datapath_inst (
        .clk(clk),
        .rst(rst),
        .MemToReg(MemToReg),
        .PcSrc(PcSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUControl(ALUControl),
        .AccControl(AccControl),
        .inst(inst),
        .ReadData(ReadData),
        .overflow(overflow),
        .BranchFlag(BranchFlag),
        .pc(pc),
        .ALUOut(ALUOut),
        .rd2_Data(rd2_Data)
    );

	
endmodule
