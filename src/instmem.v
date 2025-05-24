module instmem(
    input         clk,
    input  [7:0]  pc,
    output reg [8:0] inst
);

    reg [8:0] memory [0:255];

    initial begin
        $readmemb("inst.txt", memory);
    end

    always @(posedge clk) begin
        inst <= memory[pc];
    end

endmodule
