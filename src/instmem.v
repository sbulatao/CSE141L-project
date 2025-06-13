module instmem(
    input            clk,
    input      [7:0] pc,
    output reg [8:0] inst
);

    reg [8:0] memory [0:255];
    integer i;

    initial begin
         $readmemb("inst.txt", memory);
    //     for (i = 0; i < 256; i = i + 1) begin
    //         $display(">>> instmem[%d] = %b", i, memory[i]);
    //         if (memory[i] === 9'bx) begin
    //             $display("*** instmem[%d] is uninitialized ***", i);
    //         end
    //     end
    end

    always @(posedge clk) begin
        inst <= memory[pc];
    end

endmodule