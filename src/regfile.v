module regfile(
    input wire clk,
    input wire wen,  
    input wire[2:0] AccControl,
    input wire[2:0] ra1, ra2,
    input wire[7:0] wd3,    
    output wire[7:0] rd1,  
    output wire[7:0] rd2   
);

    reg [7:0] rf[7:0];   // r0[7:0], r1[7:0],...,r7[7:0], r0 = 0 by default
    reg [7:0] acc;

    always @(posedge clk) begin
        if (wen) begin
            if (AccControl == 3'b111)
				rf[ra1] <= wd3;			// for LWR rs <- imm
			else
                acc <= wd3;				// for other accumulation
        end
		else begin
			rf[ra1] <= rf[ra1];
			acc <= acc;
		end

    end

    reg [7:0] rd1_temp;
    reg [7:0] rd2_temp;

    always @(*) begin
        rd1_temp <= 8'b0;
        rd2_temp <= 8'b0;
        case (AccControl)
            3'b001: begin               // model1: acc = acc f rd2/imm
                rd1_temp <= acc;                         		// ra1 invalid, acc -> rd1 -> a
                rd2_temp <= (ra2 != 3'b000) ? rf[ra2] : 8'b0;	// ra2 -> rd2 -> b
            end
            3'b010: begin               // model2: acc = f(acc). ra1,ra2 invalid
                rd2_temp <= acc;                         // acc -> rd2 -> b
            end
            3'b101: begin               // model5: MEM(imm) = acc. ra1,ra2 invalid
                rd2_temp <= acc;                         // acc -> rd2 -> WD
            end
            3'b011, 3'b100: begin       // model3: EQ rs rt, model4: jump
                rd1_temp <= (ra1 != 3'b000) ? rf[ra1] : 8'b0;	// r0 = 0 by default
                rd2_temp <= (ra2 != 3'b000) ? rf[ra2] : 8'b0;
            end
			//3'b110: model6: acc = MEM(imm). 	ra1,ra2 invalid, aludec makes y=b=imm, don't care
			//3'b111: model7: rs = imm. 		ra1,ra2 invalid, aludec makes y=b=imm, don't care
            default: begin
                rd1_temp <= 8'b0;
                rd2_temp <= 8'b0;
            end
        endcase
    end

    assign rd1 = rd1_temp;
    assign rd2 = rd2_temp;

endmodule