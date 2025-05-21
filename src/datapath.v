`include "dff.v"
`include "adder.v"
`include "mux2.v"
`include "regfile.v"
`include "signext.v"
`include "alu.v"

module datapath(
    input  wire        clk,
    input  wire        rst,
    input  wire        MemToReg,
    input  wire        PcSrc,
    input  wire        ALUSrc,
    input  wire        RegWrite,
    input  wire [1:0]  Jump,
    input  wire [2:0]  ALUControl,
    input  wire [2:0]  AccControl,
    input  wire [8:0]  inst,
    input  wire [7:0] ReadData,
    output wire        overflow,
    output wire        BranchFlag,
    output wire [7:0]  pc,
    output wire [7:0] ALUOut,
    output wire [7:0] rd2_Data
);

    wire [4:0]  writereg;
    wire [7:0]  pc_jr_jmp
    wire [7:0]  pcNext;
    wire [7:0]  pcResult;
    wire [7:0]  pcPlus1;
    wire [7:0]  pcBranch;
    wire [7:0]  SignImm;
    wire [7:0]  SignImmShift;
    wire [7:0]  SrcA;
    wire [7:0]  SrcB;
    wire [7:0]  result;
    wire BranchFlag_r;

	dff #(.WIDTH(8)) dff_u (
		.clk(clk),
		.rst(rst),
		.d(pcNext),
		.q(pc)
	);

	adder adder_pc (
		.a(pc),
		.b(8'b1),
		.y(pcPlus1)
	);

	adder adder_branch (
		.a(pcPlus1),
		.b(SignImm),
		.y(pcBranch)
	);

	mux2 #(.WIDTH(8)) mux_pcresult (
        .mux_d0(pcPlus1),
        .mux_d1(pcBranch),
        .mux_sel(PcSrc),
        .mux_y(pcResult)
    );

	mux2 #(.WIDTH(8)) mux_pcnext (
        .mux_d0(pcResult),
        .mux_d1(pc_jr_jmp),
        .mux_sel(Jump[0]),
        .mux_y(pcNext)
    );

    mux2 #(.WIDTH(8)) mux_jumpsrc (
        .mux_d0({2'b00,inst[5:0]}),
        .mux_d1(rd2_Data),
        .mux_sel(Jump[1]),
        .mux_y(pc_jr_jmp)
    );

	regfile regfile_inst (
		.clk(clk),
		.wen(RegWrite),
        .AccControl(AccControl),
		.ra1(inst[5:3]),
		.ra2(inst[2:0]),
		.wd3(result),
		.rd1(SrcA),
		.rd2(rd2_Data)
	);

	mux2 #(.WIDTH(8)) mux_result (
        .mux_d0(ALUOut),
        .mux_d1(ReadData),
        .mux_sel(MemToReg),
        .mux_y(result)
    );

	signext signext_u (
		.InImm(inst[2:0]),
		.ExtImm(SignImm)
	);

	mux2 #(.WIDTH(8)) mux_srcb (
        .mux_d0(rd2_Data),
        .mux_d1(SignImm),
        .mux_sel(ALUSrc),
        .mux_y(SrcB)
    );

	alu alu_u (
        .a(SrcA),
        .b(SrcB),
        .ALUControl(ALUControl),
        .y(ALUOut),
        .overflow(overflow),
        .BranchFlag(BranchFlag_r)
    );

    dff #(.WIDTH(1)) dff_Brc (
		.clk(clk),
		.rst(rst),
		.d(BranchFlag_r),
		.q(BranchFlag)
	);

endmodule
