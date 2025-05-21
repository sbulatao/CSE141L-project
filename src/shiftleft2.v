module shiftleft2(
	input wire[5:0] in_a,
	output wire[7:0] shift_y
    );

	assign shift_y = {in_a[5:0],2'b00};
endmodule
