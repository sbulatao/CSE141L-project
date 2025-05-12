module alu(
    input wire[7:0] a, b,
    input wire[2:0] ALUControl,
    output reg[7:0] y,
    output reg overflow,
    output wire BranchFlag
    );

    always @(*) begin
        case (ALUControl)
            3'b000: y <= a + b;           // add
            3'b001: y <= a - b;           // sub           
            3'b010: y <= a & b;           // and
            3'b011: y <= a | b;           // or
            3'b100: y <= b;               // pass
            3'b101: y <= &b;        	  // &()
            3'b110: y <= |b;        	  // |()
            3'b111: y <= a << b;          // <<
            default: y <= 8'b0;
        endcase
    end

    assign BranchFlag = (y == 8'b0);

    always @(*) begin
        case (ALUControl)
            3'b000: {overflow,y} <= a + b;
            3'b001: {overflow,y} <= a - b;
            default: overflow <= 1'b0;
        endcase
    end

endmodule