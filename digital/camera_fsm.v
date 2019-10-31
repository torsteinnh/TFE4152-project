/*
 This file contains the controll logic of the FSM of the camera.
 It depends on the fcd_reg, exp_reg and read_sequencer to function.
 */

// `define _no_testbench_

`ifndef _fsm_logic_v_31_
 `define _fsm_logic_v_31_

 `include "exp_reg.v"
 `include "fcd_reg.v"
 `include "readout_seq.v"


module camera_fsm(input  logic clk,
		  input logic  init, exponer_inc, exponer_dec, reset,
		  output logic expose, erase, nre_1, nre_2, adc_enable);
   
   typedef enum 	       logic [1:0]
			       {idle, exposing, readout, illegal} statetypes;
   statetypes current_state, next_state;
   
   logic 		       readout_enable, readout_reset, readout_finished;
   
   logic 		       fcd_enable, fcd_dset, fcd_finished;
   logic [4:0] 		       fcd_data;
   
   logic 		       exp_reset, exp_inc, exp_dec;
   
   
   exp_reg exposure_reg(clk, exp_reset, exp_inc, exp_dec, fcd_data);
   fcd_reg countdown_reg(clk, fcd_enable, fcd_dset, fcd_data, fcd_finished);
   readout_seq readout_sequencer(clk, readout_enable, readout_reset, readout_finished, nre_1, nre_2, adc_enable);
   
   
   assign exp_inc = (current_state == idle) ? exponer_inc : 0;
   assign exp_dec = (current_state == idle) ? exponer_dec : 0;
   
   always @(posedge clk)
     case (next_state)
       idle: begin
	  {expose, erase, readout_enable, readout_reset, fcd_enable, fcd_dset} <= 6'b010101;
	  current_state <= next_state;
       end
       exposing: begin
	  {expose, erase, readout_enable, readout_reset, fcd_enable, fcd_dset} <= 6'b100110;
	  current_state <= next_state;
       end
       readout: begin
	  {expose, erase, readout_enable, readout_reset, fcd_enable, fcd_dset} <= 6'b001001;
	  current_state <= next_state;
       end
       default: current_state <= next_state;
       
     endcase // case (next_state)
   
   
   always @(*) begin
      if (reset)
	current_state = illegal;
      else case (current_state)
	     illegal: begin
		exp_reset = 1;
		readout_reset = 1;
		exp_reset = 0;
		readout_reset = 0;
		next_state = idle;
	     end
	     idle: if (init) next_state = exposing;
	     exposing: if (fcd_finished) next_state = readout;
	     readout: if (readout_finished) next_state = idle;
	     default: next_state = idle;
	   endcase // case (state)
   end // always @ (*)
   
   initial
     current_state = illegal;
   
endmodule // camera_fsm


`endif
