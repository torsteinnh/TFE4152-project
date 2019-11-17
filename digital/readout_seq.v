/*
 This file contains a sequencer for the readout of the 4 pixel camera.
 It can be enabled and reset.
 Note that the enable does not imply a reset.
 */

`ifndef _readout_seq_v_31_
 `define _readout_seq_v_31_


module readout_seq(input logic clk,
		   input logic 	enable, reset,
		   output logic finished,
		   output logic nre1, nre2, adc);

   logic [3:0] 			step;

   assign finished = (step >= 8) ? 1 : 0;
   
   always @(posedge clk)
      if (!finished && enable && !reset) step <= step + 1;
   
   always @(*) begin
      if (reset)
	step <= 0;
      
      case (step)
	0: {nre1, nre2, adc} = 3'b110;
	1: {nre1, nre2, adc} = 3'b010;
	2: {nre1, nre2, adc} = 3'b011;
	3: {nre1, nre2, adc} = 3'b010;
	4: {nre1, nre2, adc} = 3'b110;
	5: {nre1, nre2, adc} = 3'b100;
	6: {nre1, nre2, adc} = 3'b101;
	7: {nre1, nre2, adc} = 3'b100;
	8: {nre1, nre2, adc} = 3'b110;
	default: {nre1, nre2, adc} = 3'b110;
      endcase // case (step)
   end // always @ (*)

   endmodule // readout_seq


 `ifndef _no_testbench_


module readout_seq_tb;
   logic clk, enable, reset, finished, nre1, nre2, adc;

   readout_seq test_seq(clk, enable, reset, finished, nre1, nre2, adc);

   always @(*)
     #1 clk <= !clk;

   initial begin
      $dumpfile("outfiles/out_readout_seq_tb.vcd");
      $dumpvars();
      
      {clk, enable, reset} = 3'b000;
      #5 reset = 1;
      #2 reset = 0;

      #4 enable = 1;
      #20 enable = 0;
      #4 enable = 1;
      #1 reset = 1; #1
      #2 reset = 0;
      #4 enable = 0;

      #4 $finish;
   end // initial begin
   
endmodule // readout_seq_tb


 `endif
`endif //  `ifndef _readout_seq_v_31_

