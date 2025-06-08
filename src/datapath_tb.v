`timescale 1ns / 1ps

module datapath_tb;

    // Inputs
    reg clk;
    reg rst;
    reg MemToReg;
    reg PcSrc;
    reg ALUSrc;
    reg RegWrite;
    reg Jump;
    reg [2:0] ALUControl;
    reg [2:0] AccControl;
    reg [8:0] inst;
    reg [7:0] ReadData;

    // Outputs
    wire overflow;
    wire BranchFlag;
    wire [7:0] pc;
    wire [7:0] ALUOut;
    wire [7:0] rd2_Data;

    // Instantiate the datapath
    datapath uut (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Monitor internal signals
    initial begin
        $monitor("Time: %t | pc: %h | inst: %b | ALUOut: %h | rd2_Data: %h | overflow: %b | BranchFlag: %b", 
                 $time, pc, inst, ALUOut, rd2_Data, overflow, BranchFlag);
    end

    // Test sequence
    initial begin
        $display("Starting datapath simulation...");
        // Initialize Inputs
        rst = 1;
        MemToReg = 0;
        PcSrc = 0;
        ALUSrc = 0;
        RegWrite = 0;
        Jump = 0;
        ALUControl = 3'b010; // Example: add
        AccControl = 3'b000;
        inst = 9'b000_001_010; 
        ReadData = 8'hAA;

        #10;
        rst = 0;
        RegWrite = 1;
        ALUSrc = 1;
        inst = 9'b100_001_011;  

        #10;
        MemToReg = 1;

        #20;
        Jump = 1;
        inst = 9'b010_010_011;

        #20;
        $display("Ending datapath simulation.");
        $finish;
    end

endmodule
