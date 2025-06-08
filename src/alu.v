module alu(
    input wire[7:0] a, b,
    input wire[3:0] ALUControl,
    output reg[7:0] y,
    output reg overflow,
    output wire BranchFlag
    );
	 
	   always @(*) begin
        overflow = 1'b0;  // default
        case (ALUControl)
            4'b0000: begin
                {overflow, y} = a + b;  // addition with overflow
            end
            4'b0001: begin
                {overflow, y} = a - b;  // subtraction with overflow
            end
            4'b0010: y = a & b;     // and
            4'b0011: y = a | b;		// or
            4'b0100: y = b;			// pass
            4'b0101: y = &b;		// &()
            4'b0110: y = |b;		// |()
            4'b0111: y = a << b;	// <<
            4'b1001: y = a >> b;    // >>
            4'b1000: y = a^ b;      // xor
            default: y = 8'b0;
        endcase
    end

    assign BranchFlag = (y == 8'b0);
	 

endmodule