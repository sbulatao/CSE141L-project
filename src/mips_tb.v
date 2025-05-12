`timescale 1ns / 1ps

module mips_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [8:0] inst;
    reg [7:0] ReadData;

    // Outputs
    wire [7:0] pc;
    wire MemWrite;
    wire [7:0] ALUOut;
    wire [7:0] rd2_Data;

    // Instantiate the MIPS module
    mips uut (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .ReadData(ReadData),
        .pc(pc),
        .MemWrite(MemWrite),
        .ALUOut(ALUOut),
        .rd2_Data(rd2_Data)
    );

    // Clock generation: 10ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor output signals
    initial begin
        $monitor("Time: %t | PC: %h | inst: %b | ALUOut: %h | rd2_Data: %h | MemWrite: %b", 
                 $time, pc, inst, ALUOut, rd2_Data, MemWrite);
    end

    // Test sequence
    initial begin
        $display("===== MIPS Processor Testbench Start =====");

        // Initialize inputs
        rst = 1;
        inst = 9'b000_000_000;
        ReadData = 8'h00;

        #10;
        rst = 0;

        // Simulate instruction: op = 6'b100000 (example), rs = 3'b001, rt = 3'b010
        inst = 9'b100_001_010;
        ReadData = 8'hAA;

        #20;

        // Another instruction
        inst = 9'b010_010_011;
        ReadData = 8'hBB;

        #20;

        // Another test pattern
        inst = 9'b001_011_100;
        ReadData = 8'hCC;

        #20;

        $display("===== MIPS Processor Testbench End =====");
        $finish;
    end

endmodule
