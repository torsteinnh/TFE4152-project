/*
 This file contains a simple module for counting the exposure time,
 it runs from 2 to 30 (requiering 5 bits)
 */

`ifndef _exp_reg_v_25_
 `define _exp_reg_v_25_


module exp_reg(input  logic clk, reset, inc, dec,
	       output logic [4:0] q);
   
   always @(posedge clk)
     if (inc & (q < 30) & !reset)
       q <= q + 1;
     else if (dec & (q > 2) & !inc & !reset)
       q <= q - 1;

   always @(*)
     if (reset | q > 30 | q < 2)
       q <= 5'd15;

   initial
     q = 5'd15;
   
endmodule // exp_reg


 `ifndef _no_testbench_


module exp_reg_tb;
   logic clk, reset, inc, dec;
   logic [4:0] q;
   
   exp_reg testreg(clk, reset, inc, dec, q);
   
   initial begin
      $dumpfile("outfiles/out_exp_reg_tb.vcd");
      $dumpvars();
      
      #1 {clk, reset, inc, dec} = 4'b1100;
      #1 {clk, reset} = 2'b10;
      
      for (int i = 1; i <= 20; i = i+1) begin
	 #1 {clk, inc, dec} = 3'b111;
	 #1 {clk, inc, dec} = 3'b011;
      end
      
      for (int i = 1; i <= 40; i = i+1) begin
	 #1 {clk, inc, dec} = 3'b101;
	 #1 {clk, inc, dec} = 3'b001;
      end
      
      #1 reset = 1;
      #1 reset = 0;
      
      #1 {clk, reset, inc, dec} = 4'b1101;
      #1 {clk, reset} = 2'b00;
      #1 clk = 1;
      #1 clk = 0;
      
      #1 $finish;
   end
   
endmodule // exp_reg_tb


 `endif //  `ifndef _no_testbench_
`endif //  `ifndef _exp_reg_v_25_
