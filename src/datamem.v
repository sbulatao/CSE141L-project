module datamem(
    input              clk,
    input  [7:0]       DataAddr,
    input              MemWrite,
    input  [7:0]       DataIn,
    output reg [7:0]   DataOut
);

    reg [7:0] dm [255:0];

    always @(posedge clk) begin
        if (MemWrite) begin
            dm[DataAddr] <= DataIn;
        end
    end

    always @(*) begin
        if (!MemWrite) begin
            DataOut = dm[DataAddr];
        end else begin
            DataOut = 8'hxx;
        end
    end


endmodule
