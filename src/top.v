`include "mips.v"
`include "instmem.v"
`include "datamem.v"

module top(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    output wire        done
);

    wire   [7:0]       pc;
    wire   [8:0]       inst;
    wire   [7:0]       ReadData;
    wire   [7:0]       SrcA;
    wire   [7:0]       ALUOut;
    wire               MemWrite;

    wire               internal_rst;

    assign internal_rst = rst | ~start;

    assign done = (pc == 8'hFF);    // just an example

    mips mips_u (
        .clk(clk),
        .rst(internal_rst),
        .ReadData(ReadData),
        .inst(inst),
        .pc(pc),
        .MemWrite(MemWrite),
        .ALUOut(ALUOut),
        .SrcA(SrcA)
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
        .DataIn(SrcA),
        .DataOut(ReadData)
    );

endmodule
