/*
 
 uRV - a tiny and dumb RISC-V core
 Copyright (c) 2015 twl <twlostow@printf.cc>.

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

`include "rv_defs.v"

`timescale 1ns/1ps

`define reverse_bits(x) { \
		  x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], \
		  x[8], x[9], x[10], x[11], x[12], x[13], x[14], x[15], \
		  x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23], \
		  x[24], x[25], x[26], x[27], x[28], x[29], x[30], x[31] }

module rv_shifter
  (
   input 	 clk_i,
   input 	 rst_i,

   input 	 x_stall_i,
   input 	 w_stall_req_i,

   output 	 x_stall_req_o,


   input d_valid_i,
   input [31:0]  d_rs1_i,
   output [31:0] x_rd_o,
   
   input [4:0] 	 d_shamt_i,
   input [2:0] 	 d_fun_i,
   input 	 d_shifter_sign_i,
   input 	 d_is_shift_i );

   wire 	 extend_sign = ((d_fun_i == `FUNC_SR) && d_shifter_sign_i) ? d_rs1_i[31] : 1'b0;

   wire 	 shifter_req = !w_stall_req_i && d_valid_i && d_is_shift_i;
   reg 		 shifter_req_d0;

   always@(posedge clk_i)
     if(shifter_req_d0 && !x_stall_i)
       shifter_req_d0 <= 0;
     else
       shifter_req_d0 <= shifter_req;
   
   assign x_stall_req_o = shifter_req && !shifter_req_d0;
   
   reg [31:0] shift_pre, shift_16, shift_8, s1_out;

   // stage 1
   always@*
     begin
	shift_pre <= (d_fun_i == `FUNC_SL) ? `reverse_bits(d_rs1_i) : d_rs1_i;
	shift_16 <= d_shamt_i[4] ? { {16{extend_sign}}, shift_pre[31:16] } : shift_pre;
	shift_8 <= d_shamt_i[3] ? { {8{extend_sign}}, shift_16[31:8] } : shift_16;
     end

   reg s2_extend_sign;
   reg [4:0] s2_shift;
   reg [2:0] s2_func;
   
   
   
   // stage 1 pipe register
   always@(posedge clk_i)
     begin
	s2_extend_sign <= extend_sign;
	s2_shift <= d_shamt_i;
	s2_func <= d_fun_i;
	s1_out <= shift_8;
     end

   reg [31:0] shift_4, shift_2, shift_1, shift_post;
   
   // stage 2
   always@*
     begin
	shift_4 <= s2_shift[2] ? { {4{s2_extend_sign}}, s1_out[31:4] } : s1_out;
	shift_2 <= s2_shift[1] ? { {2{s2_extend_sign}}, shift_4[31:2] } : shift_4;
	shift_1 <= s2_shift[0] ? { {1{s2_extend_sign}}, shift_2[31:1] } : shift_2;
	shift_post <= (s2_func == `FUNC_SL) ? `reverse_bits(shift_1) : shift_1;
     end
   
   assign x_rd_o = shift_post;

endmodule // rv_shifter

module rv_shifter2
  (
   input 	 clk_i,
   input 	 rst_i,

   input 	 x_stall_i,
   input 	 w_stall_req_i,

   output 	 x_stall_req_o,


   input d_valid_i,
   input [31:0]  d_rs1_i,
   output [31:0] x_rd_o,
   
   input [4:0] 	 d_shamt_i,
   input [2:0] 	 d_fun_i,
   input 	 d_shifter_sign_i,
   input 	 d_is_shift_i );

   wire 	 extend_sign = ((d_fun_i == `FUNC_SR) && d_shifter_sign_i) ? d_rs1_i[31] : 1'b0;

   wire 	 shifter_req = !w_stall_req_i && d_valid_i && d_is_shift_i;
   reg 		 shifter_req_d0;

   always@(posedge clk_i)
     if(shifter_req_d0 && !x_stall_i)
       shifter_req_d0 <= 0;
     else
       shifter_req_d0 <= shifter_req;
   
   assign x_stall_req_o = shifter_req && !shifter_req_d0;
   
   reg [31:0] shift_pre, shift_16, shift_8, s1_out;

   reg [31:0] s2_mask;
     
   // stage 1
   always@*
     begin
	shift_16 <= d_shamt_i[4] ? { d_rs1_i[15:0], d_rs1_i[31:16] } : d_rs1_i;
	shift_8 <= d_shamt_i[3] ? { shift_16[7:0], shift_16[31:8] } : shift_16;
     end

   reg [4:0] s2_shift;
   reg [2:0] s2_func;
   reg 	     s2_extend_sign;
   
   
   
   
   // stage 1 pipe register
   always@(posedge clk_i)
     begin : stage1
	integer i;
	
	for(i=0;i<32;i=i+1)
	  begin
	     if(d_fun_i == `FUNC_SL)
	       s2_mask[i] <= (d_shamt_i < i) ? 1'b1 : 1'b0;
	     else
	       s2_mask[i] <= (d_shamt_i < (31-i)) ? 1'b1 : 1'b0;
	  end
			    
	s2_extend_sign <= extend_sign;
	s2_shift <= d_shamt_i;
	s2_func <= d_fun_i;
	s1_out <= shift_8;
     end

   reg [31:0] shift_4, shift_2, shift_1, shift_post;
   
   // stage 2
   always@*
     begin : stage2
	integer i;
	
	shift_4 <= s2_shift[2] ? { s1_out[3:0], s1_out[31:4] } : s1_out;
	shift_2 <= s2_shift[1] ? { s1_out[1:0], shift_4[31:2] } : shift_4;
	shift_1 <= s2_shift[0] ? { s1_out[0], shift_2[31:1] } : shift_2;

         for(i=0;i<32;i=i+1)
	  begin
	     if(s2_extend_sign)
	       shift_post <= s2_mask[i] ? 1'b1 : shift_1[i];
	     else
	       shift_post <= s2_mask[i] ? 1'b0 : shift_1[i];
	  end
	
     end
   
   assign x_rd_o = shift_post;

endmodule // rv_shifter

