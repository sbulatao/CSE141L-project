`include "mips.v"
`include "instmem.v"
`include "datamem.v"

module top(
    input  wire        clk,
    input  wire        rst,
    output wire [7:0]  rd2_Data,
    output wire [7:0]  ALUOut,
    output wire        MemWrite
);

    wire   [7:0]       pc;
    wire   [8:0]       inst;
    wire   [7:0]       ReadData;

	mips mips_u (
        .clk(clk),
        .rst(rst),
        .ReadData(ReadData),
        .inst(inst),
        .pc(pc),
        .MemWrite(MemWrite),
        .ALUOut(ALUOut),
        .rd2_Data(rd2_Data)
    );

	instmem imem(
		.clk(clk),
		.pc(pc),
		.inst(inst)
	);

	datamem dmem(
		.clk(~clk),
		.MemWrite(MemWrite),
		.DataAddr(ALUOut),
		.DataIn(rd2_Data),
		.DataOut(ReadData)
	);
	
endmodule
