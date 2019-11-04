/*
 This file contains the register used to count down different values in the camera.
 It has 5 bits, can take data inn and counts down on rising clock edge when enabled.
 It has an output for when the internal data is 0.
 Data set has priority over enable.
 */

`ifndef _fcd_reg_v_28_
 `define _fcd_reg_v_28_


module fcd_reg(input logic clk, enable, dset,
	       input logic [4:0] dread_data,
	       output logic 	 finished);
   
   logic [4:0] 			 data_int;
   
   always @(posedge clk)
     if (dset)
       data_int <= dread_data;
     else if (enable && (data_int > 'b0))
       data_int <= data_int - 1;

   assign finished = (data_int <= 5'd1) ? 1 : 0;
   
endmodule // fcd_reg


 `ifndef _no_testbench_


module fcd_reg_tb;
   logic clk, enable, dset, finished;
   logic [4:0] data_in;

   fcd_reg testreg(clk, enable, dset, data_in, finished);

   initial begin
      $dumpfile("outfiles/out_fcd_reg_tb.vcd");
      $dumpvars();

      #1 {clk, enable, dset, data_in} = 7'b0000111;
      #1 {clk, dset} = 2'b11;
      #1 clk = 0;
      #1 {clk, enable, dset} = 3'b110;

      for (int i = 1; i <= 21; i = i + 1) begin
	 #1 clk = !clk;
      end

      #1 {clk, enable} = 2'b10;
      #1 clk = 0;
      #1 clk = 1;

      for (int i = 1; i <= 5; i = i + 1) begin
	 #1 clk = !clk;
      end
      
      #1 {clk, enable, dset} = 3'b111;
      
      for (int i = 1; i <= 5; i = i + 1) begin
	 #1 clk = !clk;
      end

      #1 $finish;
   end // initial begin
   
endmodule // fcd_reg_tb





 `endif //  `ifndef _no_testbench_
`endif //  `ifndef _fcd_reg_v_28_

