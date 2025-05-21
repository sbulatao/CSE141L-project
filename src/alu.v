module alu(
    input wire[7:0] a, b,
    input wire[2:0] ALUControl,
    output reg[7:0] y,
    output reg overflow,
    output wire BranchFlag
    );
	 
	   always @(*) begin
        overflow = 1'b0;  // default
        case (ALUControl)
            3'b000: begin
                {overflow, y} = a + b;  // addition with overflow
            end
            3'b001: begin
                {overflow, y} = a - b;  // subtraction with overflow
            end
            3'b010: y = a & b;      // and
            3'b011: y = a | b;		// or
            3'b100: y = b;				// pass
            3'b101: y = &b;			// &()
            3'b110: y = |b;			// |()
            3'b111: y = a << b;		// <<
            default: y = 8'b0;
        endcase
    end

    assign BranchFlag = (y == 8'b0);
	 

endmodule