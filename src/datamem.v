module datamem(
    input              clk,
    input  [7:0]       DataAddr,
    input              MemWrite,
    input  [7:0]       DataIn,
    output reg [7:0]   DataOut
);

    reg [7:0] dm [255:0];

    // 主功能逻辑
    always @(posedge clk) begin
        if (MemWrite) begin
            dm[DataAddr] <= DataIn;
            $display("[WRITE] mem[%0d] <= %0d (0x%02x)", DataAddr, DataIn, DataIn);
        end
    end

    // 异步读取
    always @(*) begin
        if (!MemWrite) begin
            DataOut = dm[DataAddr];
        end else begin
            DataOut = 8'hxx;  // 避免混淆：写入时不应该读出
        end
    end

    // ========== Testbench用的强制写入 ========== //
    task write_force(input [7:0] addr, input [7:0] value);
        begin
            dm[addr] = value;
            $display("[TB FORCE WRITE] mem[%0d] <= %0d (0x%02x)", addr, value, value);
        end
    endtask

    // ========== Testbench用的强制读取 ========== //
    function [7:0] read_force(input [7:0] addr);
        begin
            read_force = dm[addr];
            $display("[TB FORCE READ] mem[%0d] => %0d (0x%02x)", addr, read_force, read_force);
        end
    endfunction

endmodule
