/*

  uRV - a tiny and dumb RISC-V core
 Copyright (c) 2015 CERN
 Author: Tomasz Włostowski <tomasz.wlostowski@cern.ch>

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 3.0 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public
 License along with this library.
 
*/

`include "urv_defs.v"

`timescale 1ns/1ps

module urv_divide
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     x_stall_i,
   input 	     x_kill_i,
   output 	     x_stall_req_o,

   input 	     d_valid_i,
   input 	     d_is_divide_i,
  
   input [31:0]      d_rs1_i,
   input [31:0]      d_rs2_i,

   input [2:0] 	     d_fun_i,

   output reg [31:0] x_rd_o
   );

   reg [31:0] 	     q,r,n,d;
   reg 		     n_sign, d_sign;
   reg [5:0] 	     state;

   wire [32:0] 	     alu_result;

   
   reg [31:0] 	     alu_op1;
   reg [31:0] 	     alu_op2;

   reg 		     is_rem;

   wire [31:0] r_next = { r[30:0], n[31 - (state - 3)] };

   
   always@*
     case(state) // synthesis full_case parallel_case
       0: begin alu_op1 <= 'hx; alu_op2 <= 'hx; end
       1: begin alu_op1 <= 0; alu_op2 <= d_rs1_i; end
       2: begin alu_op1 <= 0; alu_op2 <= d_rs2_i; end
       35: begin alu_op1 <= 0; alu_op2 <= q; end
       36: begin alu_op1 <= 0; alu_op2 <= r; end
       default: begin alu_op1 <= r_next; alu_op2 <= d; end
     endcase // case (state)

   reg alu_sub;
   
   assign alu_result = alu_sub ? {1'b0, alu_op1} - {1'b0, alu_op2} : {1'b0, alu_op1} + {1'b0, alu_op2};
   
   wire alu_ge = ~alu_result [32];

   wire start_divide = !x_stall_i && !x_kill_i && d_valid_i && d_is_divide_i;
   
   wire done = (is_rem ? state == 37 : state == 36 );


   assign x_stall_req_o = (start_divide || !done);

   always@*
     case (state) // synthesis full_case parallel_case
       1:
	 alu_sub <= n_sign;
       2:
	 alu_sub <= d_sign;
       35:
	 alu_sub <= n_sign ^ d_sign;
       36:
	 alu_sub <= n_sign;
       default:
	 alu_sub <= 1;
     endcase // case (state)
   


   always@(posedge clk_i)
     if(rst_i || done)
       state <= 0;
     else if (state != 0 || start_divide)
       state <= state + 1;
   
   always@(posedge clk_i)
	  case ( state ) // synthesis full_case parallel_case
	    0:
	      if(start_divide)
	      begin
		 q <= 0;
		 r <= 0;

		 is_rem <= (d_fun_i == `FUNC_REM || d_fun_i ==`FUNC_REMU);
		 
		 n_sign <= d_rs1_i[31];
		 d_sign <= d_rs2_i[31];
	      end

	    1: 
		n <= alu_result[31:0];
	  
	    2: 
		d <= alu_result[31:0];

	    35:
	      x_rd_o <= alu_result; // quotient

	    36:
	      x_rd_o <= alu_result; // remainder

	    default: // 3..34: 32 divider iterations
	      begin
		 
		 q <= { q[30:0], alu_ge };
		 r <= alu_ge ? alu_result : r_next;
		 
		 
	      end
	  endcase // case ( state )
   
   
endmodule // rv_divide

