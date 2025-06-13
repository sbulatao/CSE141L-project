module datamem(
  input              clk,
  input [7:0]        DataAddr,
  input              MemWrite,
  input [7:0]       DataIn,
  output reg [7:0]       DataOut
  );

  reg [7:0] dm [255:0];

initial begin
  // test case 1
  dm[0] = 8'b0011_1100; //low
  dm[1] = 8'b0111_0100; //high

  // test case 2
  //dm[0] = 8'b1101_1100; //low
  //dm[1] = 8'b0011_0100; //high

  // test case 3
  //dm[0] = 8'b1100_1010; //low
  //dm[1] = 8'b0001_0100; //high

  // test case 4
  //dm[0] = 8'b0010_1110; //low
  //dm[1] = 8'b1111_0001; //high

  // test case 5
  // dm[0] = 8'b0000_0001;	//low   
  // dm[1] = 8'b1000_0000;	//high

  // test case 6
  //dm[0] = 8'b1111_1010; //low
  //dm[1] = 8'b1111_1111; //high

  // test case 7
  //dm[0] = 8'b0000_0000; //low
  //dm[1] = 8'b0000_0000; //high

  // test case 8
  //dm[0] = 8'b1111_1111; //low
  //dm[1] = 8'b1111_1111; //high

  // test case 9
  //dm[0] = 8'b1111_1111; //low
  //dm[1] = 8'b0111_1111; //high

  // test case 10
  //dm[0] = 8'b0000_0000; //low
  //dm[1] = 8'b1000_0000; //high
end

  always@(posedge clk) begin
    if(!MemWrite)
      DataOut <= dm[DataAddr];
    else 
      dm[DataAddr] <= DataIn;
  end

endmodule