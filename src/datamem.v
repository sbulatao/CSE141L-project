module datamem(
  input              clk,
  input [7:0]        DataAddr,
  input              MemWrite,
  input [7:0]       DataIn,
  output reg [7:0]       DataOut
  );

  reg [7:0] dm [255:0];

  initial begin
    dm[0] = 8'b1100_1010;	// low
    dm[1] = 8'b0000_0000;	// high
  end

  always@(posedge clk) begin
    if(!MemWrite)
      DataOut <= dm[DataAddr];
    else 
      dm[DataAddr] <= DataIn;
  end

endmodule