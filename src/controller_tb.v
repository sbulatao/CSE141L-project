`timescale 1ns / 1ps

module controller_tb;

    reg [5:0] tb_op;
    reg       tb_BranchFlag;
    wire      tb_MemToReg;
    wire      tb_MemWrite;
    wire      tb_PcSrc;
    wire      tb_ALUSrc;
    wire      tb_RegWrite;
    wire      tb_Jump;
    wire [2:0] tb_ALUControl;
    wire [2:0] tb_AccControl;

    controller dut (
        .op        (tb_op),
        .BranchFlag(tb_BranchFlag),
        .MemToReg  (tb_MemToReg),
        .MemWrite  (tb_MemWrite),
        .PcSrc     (tb_PcSrc),
        .ALUSrc    (tb_ALUSrc),
        .RegWrite  (tb_RegWrite),
        .Jump      (tb_Jump),
        .ALUControl(tb_ALUControl),
        .AccControl(tb_AccControl)
    );

    initial begin
        tb_op = 6'b000000;
        tb_BranchFlag = 1'b0;
        #10;

        $display("Time | Opcode | Zero | MemToReg | MemWrite | PcSrc | ALUSrc | RegWrite | Jump | ALUControl | AccControl");
        $display("-------------------------------------------------------------------------------------------------");

        // Monitor signals: time, opcode, zero, MemToReg, MemWrite, PcSrc, ALUSrc, RegDst, RegWrite, Jump, ALUControl
        $monitor("%4d | %6b | %4b | %8b | %8b | %5b | %6b | %8b | %4b | %10b | %10b",
                 $time, tb_op, tb_BranchFlag, tb_MemToReg, tb_MemWrite, tb_PcSrc, tb_ALUSrc, tb_RegWrite, tb_Jump, tb_ALUControl, tb_AccControl);

        tb_op = 6'b000000;
        tb_BranchFlag = 1'b0;
        #20;

        tb_op = 6'b001000;
        tb_BranchFlag = 1'b0;
        #20;

        tb_op = 6'b001001;
        tb_BranchFlag = 1'b0;
        #20;

        tb_op = 6'b001010;
        tb_BranchFlag = 1'b0;
        #20;

        tb_op = 6'b010001;
        tb_BranchFlag = 1'b1;
        #20;

        tb_op = 6'b100101;
        tb_BranchFlag = 1'b0;
        #20;
                
        tb_op = 6'b111001;
        tb_BranchFlag = 1'b1;
        #20;

        $finish;
    end

endmodule
