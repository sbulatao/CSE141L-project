module signext(
	input wire[2:0] InImm,
	output wire[7:0] ExtImm
    );

	assign ExtImm = {{5{InImm[2]}},InImm};
	// assign ExtImm = {{5{1'b0}},InImm};
	
endmodule
