module my_dff #( // change to my_dff since quartus complained
	parameter WIDTH = 8
)(
	input wire clk,
	input wire rst,
	input wire[WIDTH-1:0] d,
	output reg[WIDTH-1:0] q
    );

	always @(negedge clk,posedge rst) begin
		if(rst)
			q <= 0;
		else
			q <= d;
	end
endmodule
