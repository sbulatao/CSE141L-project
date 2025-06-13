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

  initial begin				 // test sequence
    // $monitor("data_mem.core0, 1 = %b  %b %t",f0.dmem.dm[3],f1.DM1.Core[3],$time);
    //#20ns reset = '0;
    disp2(16'b0000000000000000);  
    disp2(16'b0000000000000001);
    disp2(16'b0000000000000010);
    disp2(16'b0000000000000011);
    disp2(16'b0000000000001100);
    disp2(16'b0000000000110000);
    disp2(16'b0001111111111111);
    disp2(16'b0011111111111111);
    disp2(16'b0111111111111111);
    disp2(16'b1111111111111111);
    disp2(16'b1111111111111110);
    disp2(16'b1111111111111101);
    disp2(16'b1111111111110100);
    disp2(16'b1111111111010000);
    disp2(16'b1100000000000000);
    disp2(16'b0100000000000000);
    disp2(16'b1000000000000000);
    disp2(16'b1000000000000001);
	
	  if(count>10) begin
	  	//#20ns $display("scores = %d %d out of %d",score0,scoreM,count); 
        $stop;
	  end
	end


task automatic disp2(input logic [15:0] int_in);
	// locals
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
    half = 0;
    float_M = float_M + exp_unb<<10;
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
		half >>=5;

	  float_M = float_M + half;
	end



	f1.dmem.dm[0]  = int_in[7:0];
	f1.dmem.dm[1]  = int_in[15:8];

	f0.dmem.dm[0] = int_in[7:0];
	f0.dmem.dm[1] = int_in[15:8];

	#10ns req = 0; reset=1;
	#10ns req = 1; reset=0;

	//wait(ack);
	//wait(ack0);
	#10ns;

	flt_outM = float_M;
    flt_out0 = {f0.dmem.dm[3],f0.dmem.dm[2]};	 // results from my dummy DUT
	flt_out  = {f1.dmem.dm[3], f1.dmem.dm[2]};	 // results from your DUT
  
	$display("MATH = %b", flt_outM);
	$display("REF  = %b", flt_out0);
  $display("DUT  = %b\n", flt_out);
	// $display("IN=0x%h → DUT=0x%h, REF=0x%h, MATH=0x%h",
	// 		int_in, flt_out, flt_out0, flt_outM);
	// // Compare DUT vs. reference DUT
    // if (flt_out === flt_out0) 
    //   score0++;
    // else 
    //   $display("Mismatch DUT vs REF: DUT=0x%h REF=0x%h", flt_out, flt_out0);

    // // Compare DUT vs. math model
    // if (flt_out === flt_outM) 
    //   scoreM++;
    // else 
    //   $display("Mismatch DUT vs MATH: DUT=0x%h MATH=0x%h", flt_out, flt_outM);

    // count++;
    // $display("Scores so far: vs REF=%0d, vs MATH=%0d, tests=%0d",
	// 		score0, scoreM, count);
  endtask
endmodule