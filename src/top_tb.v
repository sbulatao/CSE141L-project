`timescale 1ns / 1ps

module tb_top;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [7:0] rd2_Data;
    wire [7:0] ALUOut;
    wire       MemWrite;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst(rst),
        .rd2_Data(rd2_Data),
        .ALUOut(ALUOut),
        .MemWrite(MemWrite)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;
        #20;
        rst = 0;

        // Run simulation for a while
        #200;

        // Finish simulation
        $finish;
    end

    // Optional: Monitor outputs
    initial begin
        $monitor("Time=%0t | pc=%d | inst=%b | ALUOut=%b | rd2_Data=%b | MemWrite=%b", 
                  $time,   uut.pc, uut.inst, ALUOut,     rd2_Data,     MemWrite);
    end

    // Waveform dumping
    initial begin
        $dumpfile("tb_top.vcd"); 
        $dumpvars(0, tb_top);  
    end

endmodule
