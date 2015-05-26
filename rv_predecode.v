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


module rv_predecode 
(
 input 	       clk_i,
 input 	       rst_i,

 input [31:0]  im_data_i,
 
 input [31:0]  f_ir_i,
 input [31:0]  f_pc_i,

 output [31:0] x_pc_o,
  
 output [4:0]  rf_rs1_o,
 output [4:0]  rf_rs2_o,

 output [4:0]  x_rs1_o,
 output [4:0]  x_rs2_o,
 
 output [4:0]  x_rd_o,

 output [4:0]  x_shamt_o,
 output reg [2:0]  x_fun_o,

 output [4:0]  x_opcode_o,
 output        x_shifter_sign_o,
 
 output [31:0] x_imm_i_o,
 output [31:0] x_imm_s_o,
 output [31:0] x_imm_b_o,
 output [31:0] x_imm_u_o,
 output [31:0] x_imm_j_o
 );

   wire [4:0]       f_opcode = f_ir_i[6:2];
   
   
  
   
   assign x_rs1_o = f_ir_i [19:15];
   assign x_rs2_o = f_ir_i [24:20];

   assign x_rd_o = f_ir_i [11:7];
   assign x_opcode_o = f_ir_i[6:2];
   assign x_shamt_o = f_ir_i[24:20];

   
   // attempt to reuse ALU for jump address generation

   always@*
     case (f_opcode)
       `OPC_JAL, `OPC_JALR, `OPC_LUI, `OPC_AUIPC:
	 x_fun_o <= `FUNC_ADD;
       default:
	 x_fun_o <= f_ir_i[14:12];
     endcase // case (f_opcode)
   
   
   //assign x_fun_o = f_ir_i[14:12];
   
   assign x_shifter_sign_o = f_ir_i[30];

   
   // decoded imm values
   assign  x_imm_i_o = { {21{ f_ir_i[31] }}, f_ir_i[30:25], f_ir_i[24:21], f_ir_i[20] };
   assign	x_imm_s_o = { {21{ f_ir_i[31] }}, f_ir_i[30:25], f_ir_i[11:8], f_ir_i[7] };
   assign 	x_imm_b_o = { {20{ f_ir_i[31] }}, f_ir_i[7], f_ir_i[30:25], f_ir_i[11:8], 1'b0 };
   assign 	x_imm_u_o = { f_ir_i[31], f_ir_i[30:20], f_ir_i[19:12], 12'h000 };
   assign  	x_imm_j_o = { {12{f_ir_i[31]}}, 
f_ir_i[19:12], 
f_ir_i[20], f_ir_i[30:25], f_ir_i[24:21], 1'b0};


   assign x_pc_o = f_pc_i;

  
   
   


endmodule // rv_predecode


		     
