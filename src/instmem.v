module instmem(
   input        	clk,
   input  	  [7:0] pc,
   output reg [8:0] inst
  );
	 
always @(posedge clk) begin
    case (pc)
        // Initialization: Set known values into ACC and registers
        0  : inst <= 9'b010010_011;     // LWI 3:      acc <- 3                acc = 3
        1  : inst <= 9'b101_001_011;    // LWRI r1,3:  r1 <- 3                 r1 = 3
        2  : inst <= 9'b101_010_100;    // LWRI r2,4:  r2 <- 4                 r2 = 4
        3  : inst <= 9'b001001_001;     // STR r1:     MEM[r1]=acc (3)         MEM[3] = 3
        4  : inst <= 9'b001000_001;     // LWR r1:     acc <- MEM[r1]          acc = 3 (from MEM[3])
        5  : inst <= 9'b010111_001;     // SLL 1:      acc <- acc << 1         acc = 6

        // ALU operations (registers are pre-initialized)
        6  : inst <= 9'b101_011_101;    // LWRI r3,5:  r3 <- 5                 r3 = 5
        7  : inst <= 9'b000000_011;     // ADD r3:     acc <- acc + r3         acc = 11
        8  : inst <= 9'b000001_010;     // SUB r2:     acc <- acc - r2         acc = 7
        9  : inst <= 9'b000010_010;     // AND r2:     acc <- acc & r2         acc = 7 & 4 = 4
        10 : inst <= 9'b000011_011;     // OR r3:      acc <- acc | r3         acc = 4 | 5 = 5
        11 : inst <= 9'b000101_000;     // BAN:        acc <- &acc (reduce)    acc = 0 (since acc = 5 = 101)
        12 : inst <= 9'b000110_000;     // BOR:        acc <- |acc             acc = 0

        // EQ and BRC testing
        13 : inst <= 9'b101_100_101;    // LWRI r4,5:  r4 <- 5                 r4 = 5
        14 : inst <= 9'b101_101_101;    // LWRI r5,5:  r5 <- 5                 r5 = 5
        15 : inst <= 9'b100_100_101;    // EQ r4 r5:   BranchFlag = 1 (equal)
        16 : inst <= 9'b010101_001;     // BRC 1:      jump to pc+1+1 = 18 if BF == 1

        // This ADDI should be skipped if BRC is taken
        17 : inst <= 9'b010000_001;     // ADDI 1:     (This line should be skipped)
        18 : inst <= 9'b010001_001;     // SUBI 1:     acc <- acc - 1

        // Jump test
        19 : inst <= 9'b111_010101;     // JMP 21:     pc <- 21
      	21 : inst <= 9'b101_010_111;    // LWRI r2,5:  r2 <- 7
        22 : inst <= 9'b110_000_010;     // JR r2:     pc <- r2 = 7

        default : inst <= 9'b000000000; // NOP
    endcase
end


endmodule