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
 
 output reg	   x_load_hazard_o,
 
 input [31:0] 	   f_ir_i,
 input [31:0] 	   f_pc_i,
 input 		   f_valid_i,

 output reg 	   x_valid_o,

 output reg [31:0] x_pc_o,
  
 output reg [4:0] 	   rf_rs1_o,
 output reg [4:0] 	   rf_rs2_o,

 output [4:0] 	   x_rs1_o,
 output [4:0] 	   x_rs2_o,
 
 output [4:0] 	   x_rd_o,

 output [4:0] 	   x_shamt_o,
 output reg [2:0]  x_fun_o,

 output [4:0] 	   x_opcode_o,
 output 	   x_shifter_sign_o,
 
 output [31:0] 	   x_imm_i_o,
 output [31:0] 	   x_imm_s_o,
 output [31:0] 	   x_imm_b_o,
 output [31:0] 	   x_imm_u_o,
 output [31:0] 	   x_imm_j_o
 );

   reg [31:0] 	  d_ir = 0;

   wire [4:0] f_rs1 = f_ir_i[19:15];
   wire [4:0] f_rs2 = f_ir_i[24:20];

   wire [4:0] d_rs1 = d_ir[19:15];
   wire [4:0] d_rs2 = d_ir[24:20];

   wire [4:0] rd = d_ir [11:7];

   reg [31:0] f_ir_d;
   
   
   always@*
     if(d_stall_i)
       begin
	  rf_rs1_o <= d_rs1;
	  rf_rs2_o <= d_rs2;
       end else begin
	  rf_rs1_o <= f_rs1;
	  rf_rs2_o <= f_rs2;
       end
   
   always@(posedge clk_i)
     if(rst_i)
       begin
	  x_pc_o <= 0;
	  x_valid_o <= 0;
	  
     end else if(!d_stall_i)
       begin
	  d_ir <= f_ir_i;
	  x_valid_o <= f_valid_i && !d_kill_i;
	  x_pc_o <= f_pc_i;
       end

   wire [4:0]       opcode = d_ir[6:2];
   
   always@(posedge clk_i)
     if(!d_stall_i)
       x_load_hazard_o <= ( (f_rs1 == rd)  || (f_rs2 == rd) ) && (!d_kill_i) && (opcode == `OPC_LOAD);
   
   
   assign x_rs1_o = d_ir [19:15];
   assign x_rs2_o = d_ir [24:20];

   assign x_rd_o = d_ir [11:7];
   assign x_opcode_o = d_ir[6:2];
   assign x_shamt_o = d_ir[24:20];

   
   // attempt to reuse ALU for jump address generation

   always@*
     case (opcode)
       `OPC_JAL, `OPC_JALR, `OPC_LUI, `OPC_AUIPC:
	 x_fun_o <= `FUNC_ADD;
       default:
	 x_fun_o <= d_ir[14:12];
     endcase // case (f_opcode)
   
   
   //assign x_fun_o = f_ir_i[14:12];
   
   assign x_shifter_sign_o = d_ir[30];

   
   // decoded imm values
   assign  x_imm_i_o = { {21{ d_ir[31] }}, d_ir[30:25], d_ir[24:21], d_ir[20] };
   assign	x_imm_s_o = { {21{ d_ir[31] }}, d_ir[30:25], d_ir[11:8], d_ir[7] };
   assign 	x_imm_b_o = { {20{ d_ir[31] }}, d_ir[7], d_ir[30:25], d_ir[11:8], 1'b0 };
   assign 	x_imm_u_o = { d_ir[31], d_ir[30:20], d_ir[19:12], 12'h000 };
   assign  	x_imm_j_o = { {12{d_ir[31]}}, 
			      d_ir[19:12], 
			      d_ir[20], d_ir[30:25], d_ir[24:21], 1'b0};



  
   
   


endmodule // rv_predecode


		     
