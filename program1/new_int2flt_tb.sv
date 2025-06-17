`include "TopLevel0.sv"
module new_int2flt_tb();
  bit         clk       , 
              reset = '1,
              req;
  wire        ack,			 // your DUT's done flag
              ack0;			 // my dummy done flag
  bit  [15:0] int_in; 	     // incoming operand
  logic[15:0] int_out0;      // reconstructed integer from my reference
  logic[15:0] int_out;       // reconstructed integer from your floating point output
  logic[15:0] int_outM;      // reconstructed integer from mathetmical floating point conversion
  bit  [ 3:0] shift;         // for incoming data sizing
  logic[15:0] flt_out0,		 // my design final result
			  flt_out,		 // your design final result
              flt_outM;	     // mathematical final result
  int         scoreM,        // your DUT vs. theory 
              score0,	     // your DUT vs. mine
			  count = 0;     // number of trials


  top f1(
	.clk(clk), 
	.rst(reset),
	.start(req),
	.done(ack));

  TopLevel0 f0(				 // reference DUT goes here
    .clk  (clk),			 // 
    .start(req),			 //  
	.reset(reset),			 //  
    .done (ack0));           

    initial clk = 0;
    always #5 clk = ~clk;

  initial begin				 // testcases
    #100 disp2(16'b0000000000000011); wait(ack);
    #100 disp2(16'b0000000000010011); wait(ack);
    #100 disp2(16'b0000000000110011); wait(ack);
    #100 disp2(16'b0000000011110000); wait(ack);
    #100 disp2(16'b0000111100001111); wait(ack);
    #100 disp2(16'b0011001100110011); wait(ack);
    #100 disp2(16'b0101010101010101); wait(ack);
    #100 disp2(16'b1010101010101010); wait(ack);
    #100 disp2(16'b1111000011110000); wait(ack);
    #100 disp2(16'b0000111111110000); wait(ack);
    #100 disp2(16'b1111111000000000); wait(ack);
    #100 disp2(16'b1111111111111111); wait(ack);
    #100 disp2(16'b1000000000000001); wait(ack);
    #100 disp2(16'b1110000000000001); wait(ack);
    #100 disp2(16'b1111100000000001); wait(ack);
    #100 disp2(16'b1111111100000001); wait(ack);
    #100 disp2(16'b1111111111000001); wait(ack);
    #100 disp2(16'b1111111111110001); wait(ack);
    #100 disp2(16'b1111111111111101); wait(ack);
    #100 disp2(16'b0000000000000010); wait(ack);
    #100 disp2(16'b0000000000001000); wait(ack);
    #100 disp2(16'b0000000000100000); wait(ack);
    #100 disp2(16'b0000000010000000); wait(ack);
    #100 disp2(16'b0000001000000000); wait(ack);
    #100 disp2(16'b0000100000000000); wait(ack);
    #100 disp2(16'b0010000000000000); wait(ack);
    #100 disp2(16'b1000000000000000); wait(ack);
    #100 disp2(16'b0000000000000101); wait(ack);
    #100 disp2(16'b0000000001010000); wait(ack);
    #100 disp2(16'b0000010100000000); wait(ack);
    #100 disp2(16'b0100000010100000); wait(ack);
    #100 disp2(16'b0001111111111111); wait(ack);
    #100 disp2(16'b0111111111111111); wait(ack);
    #100 disp2(16'b0011111111111111); wait(ack);
    #100 disp2(16'b0111110000000000); wait(ack);
    #100 disp2(16'b1000001111111111); wait(ack);
    #100 disp2(16'b1001110000000000); wait(ack);
    #100 disp2(16'b1010000001111111); wait(ack);
    #100 disp2(16'b1010101011111111); wait(ack);
    #100 disp2(16'b0000000011100000); wait(ack);
    #100 disp2(16'b1000000001110000); wait(ack);
    #100 disp2(16'b1100000000111000); wait(ack);
    #100 disp2(16'b1110000000011100); wait(ack);
    #100 disp2(16'b1111000000001110); wait(ack);
    #100 disp2(16'b1111100000000111); wait(ack);
    #100 disp2(16'b1111110000000000); wait(ack);
    #100 disp2(16'b1111111000000000); wait(ack);
    #100 disp2(16'b1111111110000000); wait(ack);
    #100 disp2(16'b1111111111100000); wait(ack);
    #100 disp2(16'b1111111111111000); wait(ack);
    #100 disp2(16'b1111111111111111); wait(ack);
    #100 disp2(16'b0001001001001001); wait(ack);
    #100 disp2(16'b0010010010010010); wait(ack);
    #100 disp2(16'b0100100100100100); wait(ack);
    #100 disp2(16'b1001001001001000); wait(ack);
    #100 disp2(16'b1010010101010010); wait(ack);
    #100 disp2(16'b1100110011001100); wait(ack);
    #100 disp2(16'b1110001110001110); wait(ack);
    #100 disp2(16'b1000000000000001); wait(ack);
    #100 disp2(16'b0110000110000110); wait(ack);
    #100 disp2(16'b0000110000001100); wait(ack);
    #100 disp2(16'b0000000011000000); wait(ack);
    #100 disp2(16'b0000000000001100); wait(ack);
    #100 disp2(16'b0000000000000011); wait(ack);
    #100 disp2(16'b1010101010101010); wait(ack);
    #100 disp2(16'b0101010101010101); wait(ack);
    #100 disp2(16'b1111111111110100); wait(ack);
    #100 disp2(16'b1111111111010000); wait(ack);
    #100 disp2(16'b1111111101000000); wait(ack);
    #100 disp2(16'b1111110100000000); wait(ack);
	$finish;
	end


task automatic disp2(input logic [15:0] int_in);
	logic        sign;
	logic[15:0]  exp_unb, exp_biased, mant;
	logic [15:0] half;
  logic [15:0] float_M=0;
  
	$display("This test case %b", int_in);
  
	sign = int_in[15];
	half = int_in;
  
	if (sign) half = ~int_in + 1;
  	else half = int_in;

	exp_unb = 21;

  if (!half[14:0]) begin
    exp_unb = sign ? 22 : 0;
    float_M = sign<<15;
    float_M = float_M | exp_unb<<10;
  end
	else begin
	  while (exp_unb>6 && (half & 16'h4000) == 0) begin
	  	half <<= 1;
	  	exp_unb--;
	  end

	  float_M = sign<<15;

	  exp_biased = exp_unb;
	  exp_biased <<= 10;

	  float_M = float_M + exp_biased;

	  if(exp_unb<16)
	  	half >>= (21-exp_unb);
	  else 
        half = {2'b0,half[13:0]>>4};

	  float_M = float_M + half;
	end

	f1.dmem.dm[0]  = int_in[7:0];
	f1.dmem.dm[1]  = int_in[15:8];
	f0.dmem.dm[0] = int_in[7:0];
	f0.dmem.dm[1] = int_in[15:8];


	#10ns req = 0; reset=1;
	#10ns req = 1; reset=0;

	wait(ack);
	//wait(ack0);
	#10ns;

	flt_outM = float_M;
  	flt_out0 = {f0.dmem.dm[3],f0.dmem.dm[2]};	 // results from my dummy DUT
	flt_out  = {f1.dmem.dm[3], f1.dmem.dm[2]};	 // results from your DUT
  
	$display("MATH = %b", flt_outM);
	$display("REF  = %b", flt_out0);
    $display("DUT = %b", flt_out);
  
    if (flt_out === flt_out0) 
      score0++;

    if (flt_out === flt_outM) 
      scoreM++;

    count++;
    $display("Scores so far: vs REF=%0d, vs MATH=%0d, tests=%0d",
			score0, scoreM, count);
  endtask
  
      initial begin
        $dumpfile("new_int2flt_tb.vcd"); 
        $dumpvars(0, new_int2flt_tb);  
    end
  
endmodule