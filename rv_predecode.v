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


module rv_decode 
(
 input 		   clk_i,
 input 		   rst_i,

 input 		   d_stall_i,
 input 		   d_kill_i,
 
 output reg 	   x_load_hazard_o,
 
 input [31:0] 	   f_ir_i,
 input [31:0] 	   f_pc_i,
 input 		   f_valid_i,

 output reg 	   x_valid_o,

 output reg [31:0] x_pc_o,
  
 output reg [4:0]  rf_rs1_o,
 output reg [4:0]  rf_rs2_o,

 output [4:0] 	   x_rs1_o,
 output [4:0] 	   x_rs2_o,
 
 output [4:0] 	   x_rd_o,

 output reg [4:0]  x_shamt_o,
 output reg [2:0]  x_fun_o,

 output [4:0]  x_opcode_o,
 output reg 	   x_shifter_sign_o,
 
 output reg [31:0] x_imm_o,
 output reg 	   x_is_signed_compare_o,
 output reg 	   x_is_signed_alu_op_o,
 output reg 	   x_is_add_o,
 output reg 	   x_is_shift_o
 );


   wire [4:0] f_rs1 = f_ir_i[19:15];
   wire [4:0] f_rs2 = f_ir_i[24:20];

   reg [4:0] x_rs1;
   reg [4:0] x_rs2;
   reg [4:0] x_rd;
   reg [4:0] x_opcode;
   
   assign x_rs1_o = x_rs1;
   assign x_rs2_o = x_rs2;
   assign x_rd_o = x_rd;
   assign x_opcode_o = x_opcode;

   always@*
     if(d_stall_i)
       begin
	  rf_rs1_o <= x_rs1;
	  rf_rs2_o <= x_rs2;
       end else begin
	  rf_rs1_o <= f_rs1;
	  rf_rs2_o <= f_rs2;
       end
   reg[31:0] x_ir;
   
   
   always@(posedge clk_i)
     if(rst_i)
       begin
	  x_pc_o <= 0;
	  x_valid_o <= 0;
       end else if(!d_stall_i) begin
	  x_valid_o <= f_valid_i && !d_kill_i;
	  x_pc_o <= f_pc_i;
	  x_ir <= f_ir_i;
	  
       end

   wire [4:0] d_opcode = f_ir_i[6:2];
   
   always@(posedge clk_i)
     if(!d_stall_i)
       x_load_hazard_o <= ( (f_rs1 == x_rd)  || (f_rs2 == x_rd) ) && (!d_kill_i) && (x_opcode == `OPC_LOAD);
   

   always@(posedge clk_i)
     if(!d_stall_i)
       begin
	  x_rs1 <= f_rs1;
	  x_rs2 <= f_rs2;
	  x_rd <= f_ir_i [11:7];
	  x_opcode <= d_opcode;
	  x_shamt_o <= f_ir_i[24:20];
       end
   
   // attempt to reuse ALU for jump address generation
   wire [2:0] d_fun = f_ir_i[14:12];

   always@(posedge clk_i)
	if(!d_stall_i)
     case (d_opcode)
       `OPC_JAL, `OPC_JALR, `OPC_LUI, `OPC_AUIPC:
	 x_fun_o <= `FUNC_ADD;
       default:
	 x_fun_o <= d_fun;
     endcase // case (f_opcode)
   
   always@(posedge clk_i)
     if(!d_stall_i)
       x_shifter_sign_o <= f_ir_i[30];

   wire[31:0] d_imm_i = { {21{ f_ir_i[31] }}, f_ir_i[30:25], f_ir_i[24:21], f_ir_i[20] };
   wire[31:0] d_imm_s = { {21{ f_ir_i[31] }}, f_ir_i[30:25], f_ir_i[11:8], f_ir_i[7] };
   wire[31:0] d_imm_b = { {20{ f_ir_i[31] }}, f_ir_i[7], f_ir_i[30:25], f_ir_i[11:8], 1'b0 };
   wire[31:0] d_imm_u = { f_ir_i[31], f_ir_i[30:20], f_ir_i[19:12], 12'h000 };
   wire[31:0] d_imm_j = { {12{f_ir_i[31]}}, 
			      f_ir_i[19:12], 
			      f_ir_i[20], f_ir_i[30:25], f_ir_i[24:21], 1'b0};

   

   
   
   always@(posedge clk_i)
     begin
	if(!d_stall_i)
	  case(d_opcode)
	    `OPC_LUI, `OPC_AUIPC: x_imm_o <= d_imm_u;
	    `OPC_OP_IMM, `OPC_LOAD: x_imm_o <= d_imm_i;
	    `OPC_STORE: x_imm_o <= d_imm_s;
	    `OPC_JAL: x_imm_o <= d_imm_j;
	    `OPC_JALR: x_imm_o <= d_imm_i;
	    `OPC_BRANCH: x_imm_o <= d_imm_b;
	    default: x_imm_o <= 32'hx;
	  endcase // case (opcode)
     end // always@ (posedge clk_i)
   

   // misc decoding
   always@(posedge clk_i)
	if(!d_stall_i)
	  begin
	     x_is_shift_o <=	(d_fun == `FUNC_SL || d_fun == `FUNC_SR) &&
			    (d_opcode == `OPC_OP || d_opcode == `OPC_OP_IMM );
	     x_is_signed_compare_o <= ( ( d_opcode == `OPC_BRANCH) && ( ( d_fun == `BRA_GE )|| (d_fun == `BRA_LT ) ) )
	       || ( ( (d_opcode == `OPC_OP) || (d_opcode == `OPC_OP_IMM) ) && (d_fun == `FUNC_SLT ) );

	     x_is_add_o <= !((d_opcode == `OPC_OP && d_fun == `FUNC_ADD && f_ir_i[30]) || (d_fun == `FUNC_SLT) || (d_fun == `FUNC_SLTU));
	     x_is_signed_alu_op_o <= (d_fun == `FUNC_SLT);
	     
	  end
	
   
   


endmodule // rv_predecode


		     
