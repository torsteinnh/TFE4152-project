/*
 This module contains the deterministic logic of the camera controller.
 It contains an includeguard covering all its dependencies.
 */

`ifndef _detlog_v_24_
 `define _detlog_v_24_


module detlog(input logic [1:0] state_current,
	      input logic  init, exp_inc_inn, exp_dec_inn, reset, clk,

	      output logic [1:0] state_next,
	      output logic expose, erase, adc, nre_1, nre_2
	      );
   
   logic 		   exp_inc_use, exp_dec_use;

   assign exp_inc_use = exp_inc_inn;
   assign exp_dec_use = exp_inc_use ? 0 : exp_dec_inn;

endmodule // detlog

`endif
