// revised 2025.05.11 for no_round required	   PROGRAM 1
// behavioral model for fix(8.8) to float(16) conversion
// CSE141L  dummy DUT for int_to_float
// goes alongside yours in the Program 1 testbench 
module TopLevel0 (
  input        clk, 
               reset, 				    // master reset -- start at beginning 
               start,                   // request -- start next conversion
  output logic done
  );				    // your acknowledge back to the testbench --ready for next operation

  logic[ 4:0]  exp;					    // floating point exponent
  logic[15:0]  int1;				    // input value
  logic        sgn; 				    // floating point sgn
  logic        trap;                    // max neg or 0 input
  bit  [ 1:0]  pgm;                     // counts 1, 2, 3 program
// port connections to dummy data_mem
  bit     [7:0]  DataAddr;		    // pointer	
  bit            MemWrite;				// write enable
  bit     [7:0]  DataIn;				// data input port 
  wire    [7:0]  DataOut;				// data output port

    datamem dmem(
        .clk(~clk),
        .MemWrite(MemWrite),
        .DataAddr(DataAddr),
        .DataIn(DataIn),
        .DataOut(DataOut)
    );

  always @(posedge clk) begin
	if(reset) begin 
	    pgm     = pgm+'b1;			    // move to the next program
	end	                                // do nothing else
    else if(start) begin
        int1    = {dmem.dm[1],dmem.dm[0]};
        sgn     = int1[15];               // two's comp MSB also works as fl pt sgn bit
        trap    = !int1[14:0];            // trap 0 or 16'h8000) 
        exp     = 6'd21;			   	    // biased exponent starting value = 6 + 15
        done    = 1'b0;
    end

	if(!done) begin
        if (sgn)
            int1 = ~int1 + 16'h0001;
        else
            int1 = int1;

        if (trap) begin
            exp = sgn ? 5'd22 : 5'd0;
            int1 = 0;
        end
        else begin
            while (exp > 5'd6 && int1[14] == 1'b0) begin
                int1 = int1 << 1;
                exp = exp - 1;
            end


            if (exp < 5'd16)
                int1 = int1 >> (21 - exp);
            else
                int1 = {2'b0,int1[13:0]>>4};
        end

             #10 {dmem.dm[3],dmem.dm[2]} = {sgn, exp, int1[9:0]};
             #10 done = '1;                 
    end
  end

endmodule