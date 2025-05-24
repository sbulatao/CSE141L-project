module regfile(
    input wire clk,
    input wire wen,  
    input wire[2:0] AccControl,
    input wire[2:0] ra1, ra2,
    input wire[7:0] wd3,    
    output wire[7:0] rd1,  
    output wire[7:0] rd2   
);

    reg [7:0] rf[7:0];   // r0[7:0], r1[7:0],...,r7[7:0]
    reg [7:0] acc;

    always @(posedge clk) begin
        if (wen) begin
            if (AccControl[2] == 1'b1)
				rf[ra2] <= wd3;			// for MOV rs <- acc
			else
                acc <= wd3;				// for other accumulation
        end
		else begin
			rf[ra2] <= rf[ra2];
			acc <= acc;
		end
    end

    reg [7:0] rd1_temp;
    reg [7:0] rd2_temp;

    always @(*) begin
        rd1_temp <= 8'b0;
        rd2_temp <= 8'b0;
        case (AccControl[1:0])
            2'b00: begin			// for LWR EQ
                rd1_temp <= rf[ra1];
                rd2_temp <= rf[ra2];
            end

            2'b01: begin			// for BAN BOR STR JR
                rd1_temp <= rf[ra1];
                rd2_temp <= acc;
            end

          2'b10: begin			// for ADD(I) SUB(I) AND OR SLL LWI BRC
                rd1_temp <= acc;
                rd2_temp <= rf[ra2];
            end

            default: begin			// for JUMP  
                rd1_temp <= acc;
                rd2_temp <= acc;
            end
        endcase
    end

    assign rd1 = rd1_temp;
    assign rd2 = rd2_temp;

endmodule