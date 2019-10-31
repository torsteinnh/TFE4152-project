/*
 This is the testbench for camera_fsm, the logic that controlls the camera.
 */

`define _no_testbench_

`timescale 1ns / 1ps

`include "camera_fsm.v"


module camera_fsm_tb;
   logic clk, init, inc, dec, reset;
   logic expose, erase, nre1, nre2, adc;
   
   camera_fsm test_camera(clk, init, inc, dec, reset, expose, erase, nre1, nre2, adc);

   always @(*)
     #1 clk <= !clk;

   initial begin
      $dumpfile("outfiles/out_camera_fsm_tb.vcd");
      $dumpvars();
      
      {clk, init, inc, dec, reset} = 5'b00001;
      #2 reset = 0;

      #5 inc = 1;
      #2 dec = 1;
      #30 inc = 0;
      #4 dec = 0;
      #2 init = 1;
      #4 init = 0;

      #30 inc = 1;
      #4 inc = 0;

      #28 reset = 1;
      #2 reset = 0;

      #4 dec = 1;
      #60 dec = 0;

      init = 1;
      #1 init = 0;

      #1 dec = 1;
      
      #38 $finish;
   end
   
endmodule // camera_fsm_tb
