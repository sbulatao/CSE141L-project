`timescale 1ns / 1ns

module tb_top;

    // Inputs
    reg clk;
    reg rst;
    reg start;

    // Outputs
    wire done;
    // wire [7:0] rd2_Data;
    // wire [7:0] ALUOut;
    // wire       MemWrite;

    // Internal wires for monitoring
    wire [7:0] pc;
    wire [8:0] inst;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    );

    // Assign internal signals from uut
    assign pc   = uut.mips_u.pc;
    assign inst = uut.mips_u.inst;
    // assign rd2_Data = uut.mips_u.rd2_Data;
    // assign ALUOut   = uut.mips_u.ALUOut;
    // assign MemWrite = uut.mips_u.MemWrite;

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        start = 0;
        #20;

        rst = 0;
        start = 1;

        // Wait until done or timeout
        wait(done);
        //#1000;

        // Finish simulation
        $finish;
    end

    // Monitor signals
    initial begin
    	$monitor("Time=%0t | pc=%d | inst=%b | done=%b", 
                  $time,    pc,     inst,     done);
    end

    // Waveform dumping
    initial begin
        $dumpfile("tb_top.vcd"); 
        $dumpvars(0, tb_top);  
    end

endmodule
