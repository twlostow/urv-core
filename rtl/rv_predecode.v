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

 output 	   d_stall_req_o,
 
 output reg 	   x_load_hazard_o,
 
 input [31:0] 	   f_ir_i,
 input [31:0] 	   f_pc_i,
 input 		   f_valid_i,

 output 	   x_valid_o,

 output reg [31:0] x_pc_o,

 input 		   d_x_rs1_bypass_i,
 input 		   d_x_rs2_bypass_i,
 input 		   d_w_rs1_bypass_i,
 input 		   d_w_rs2_bypass_i,
  
 output [4:0] 	   rf_rs1_o,
 output [4:0] 	   rf_rs2_o,

 output [4:0] 	   x_rs1_o,
 output [4:0] 	   x_rs2_o,
 
 output [4:0] 	   x_rd_o,

 output reg [4:0]  x_shamt_o,
 output reg [2:0]  x_fun_o,

 output [4:0] 	   x_opcode_o,
 output reg 	   x_shifter_sign_o,
 
 output reg 	   x_is_signed_compare_o,
 output reg 	   x_is_signed_alu_op_o,
 output reg 	   x_is_add_o,
 output 	   x_is_shift_o,
 output reg 	   x_is_load_o,
 output reg 	   x_is_store_o,
 output reg 	   x_is_undef_o,
 
 
 output reg [2:0]  x_rd_source_o,
 output 	   x_rd_write_o,

 output reg [11:0] x_csr_sel_o,
 output reg [4:0]  x_csr_imm_o,
 output reg 	   x_is_csr_o,

 output reg 	   x_is_eret_o,

 output reg [31:0] x_imm_o,
 
 output reg [31:0] x_alu_op1_o,
 output reg [31:0] x_alu_op2_o,

 output reg 	   x_use_op1_o,
 output reg 	   x_use_op2_o,

 output reg [1:0] x_op1_sel_o,
 output reg [1:0] x_op2_sel_o
);


   wire [4:0] f_rs1 = f_ir_i[19:15];
   wire [4:0] f_rs2 = f_ir_i[24:20];
	      
   reg [4:0]  x_rs1;
   reg [4:0] x_rs2;
   reg [4:0] x_rd;
   reg [4:0] x_opcode;
   reg 	     x_valid;
   reg 	     x_is_shift;
   reg 	     x_rd_write;
   
   
   assign x_rs1_o = x_rs1;
   assign x_rs2_o = x_rs2;
   assign x_rd_o = x_rd;
   assign x_opcode_o = x_opcode;

   assign rf_rs1_o = f_rs1;
   assign rf_rs2_o = f_rs2;


   reg [31:0] x_ir;
   
   
   wire [4:0] d_opcode = f_ir_i[6:2];
   
   reg 	      load_hazard;

      // attempt to reuse ALU for jump address generation
   wire [2:0] d_fun = f_ir_i[14:12];

   wire d_is_shift = (d_fun == `FUNC_SL || d_fun == `FUNC_SR) &&
	(d_opcode == `OPC_OP || d_opcode == `OPC_OP_IMM );

   reg 	x_is_mul;
   
   
   wire d_is_mul = (f_ir_i[25] && d_fun == 3'b000);
   
   always@*
     if (x_valid && f_valid_i && ( (f_rs1 == x_rd)  || (f_rs2 == x_rd) ) && (!d_kill_i) )
       begin
	  case (x_opcode)
	    `OPC_LOAD:
	      load_hazard <= 1;
	    `OPC_OP:
	      load_hazard <= x_is_shift | x_is_mul;
	    `OPC_OP_IMM:
	      load_hazard <= x_is_shift;
	    default:
	      load_hazard <= 0;
	  endcase // case (x_opcode)
       end else
	 load_hazard <= 0;
   
   reg 	inserting_nop;
   
   always@(posedge clk_i)
     if(rst_i) begin
       inserting_nop <= 0;
     end else if (!d_stall_i)
      begin

	  if (inserting_nop)
	    inserting_nop <= 0;
	  else
	    inserting_nop <= load_hazard;
       end

   assign d_stall_req_o = load_hazard && !inserting_nop;

   wire [4:0] f_rd = f_ir_i[11:7];
   

   assign x_valid_o = x_valid;
   
   always@(posedge clk_i)
     if(rst_i || d_kill_i )
       begin
	  x_pc_o <= 0;
	  x_valid <= 0;
       end else  if(!d_stall_i)   begin
	  x_pc_o <= f_pc_i;

	  if (load_hazard && !inserting_nop)
	    x_valid <= 0;
	  else
	    x_valid <= f_valid_i;

	  x_ir <= f_ir_i;

	  x_rs1 <= f_rs1;
	  x_rs2 <= f_rs2;
	  x_rd <= f_rd;
	  x_opcode <= d_opcode;
	  
	  x_shamt_o <= f_ir_i[24:20];
       end
   

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
   wire [31:0] d_imm_s = { {21{ f_ir_i[31] }}, f_ir_i[30:25], f_ir_i[11:8], f_ir_i[7] };
   wire [31:0] d_imm_b = { {20{ f_ir_i[31] }}, f_ir_i[7], f_ir_i[30:25], f_ir_i[11:8], 1'b0 };
   wire [31:0] d_imm_u = { f_ir_i[31], f_ir_i[30:20], f_ir_i[19:12], 12'h000 };
   wire [31:0] d_imm_j = { {12{f_ir_i[31]}}, 
			   f_ir_i[19:12], 
			   f_ir_i[20], f_ir_i[30:25], f_ir_i[24:21], 1'b0};

   
   reg [31:0] d_imm;
   
   
   always@*
     case(d_opcode)
       `OPC_LUI, `OPC_AUIPC: d_imm <= d_imm_u;
       `OPC_OP_IMM, `OPC_LOAD: d_imm <= d_imm_i;
       `OPC_STORE: d_imm <= d_imm_s;
       `OPC_JAL: d_imm <= d_imm_j;
       `OPC_JALR: d_imm <= d_imm_i;
       `OPC_BRANCH: d_imm <= d_imm_b;
       default: d_imm <= 32'hx;
     endcase // case (opcode)

   always@(posedge clk_i)
     if(!d_stall_i)
       x_imm_o <= d_imm;
   

   always@(posedge clk_i)
     if(!d_stall_i)
       begin
	  case (d_opcode)
	    `OPC_LUI, `OPC_AUIPC: 
	      begin
		 x_alu_op1_o <= d_imm; 
		 x_use_op1_o <= 1;
	      end
	    `OPC_JAL, `OPC_JALR:
	      begin
		 x_alu_op1_o <= 4; 
		 x_use_op1_o <= 1;
	      end
	    
	    default:
	      begin
		 x_alu_op1_o <= 32'hx; 
		 x_use_op1_o <= 0;
	      end
	  endcase // case (d_opcode)

	  case (d_opcode)
	    `OPC_LUI:
	      begin
		 x_alu_op2_o <= 0;
		 x_use_op2_o <= 1;
	      end
	    `OPC_AUIPC, `OPC_JAL, `OPC_JALR:
	      begin
		 x_alu_op2_o <= f_pc_i;
		 x_use_op2_o <= 1;
	      end
	    
	    `OPC_OP_IMM:
	      begin
		 x_alu_op2_o <= d_imm;
		 x_use_op2_o <= 1;
	      end

	    default:
	      begin
		 x_alu_op2_o <= 32'hx; 
		 x_use_op2_o <= 0;
	      end
	  endcase // case (d_opcode_i)
       end // if (!d_stall_i)
   
   
   wire d_rd_nonzero = (f_rd != 0);
   
   // misc decoding
   always@(posedge clk_i)
     if(!d_stall_i)
       begin
	  x_is_shift <= d_is_shift;

	  x_is_load_o <= ( d_opcode == `OPC_LOAD && !load_hazard) ? 1'b1 : 1'b0;
	  x_is_store_o <= ( d_opcode == `OPC_STORE && !load_hazard) ? 1'b1 : 1'b0;
	  
	  x_is_mul <= d_is_mul;
	 

	  case (d_opcode)
	    `OPC_BRANCH:
	      x_is_signed_alu_op_o <= (d_fun == `BRA_GE || d_fun == `BRA_LT);
	    default:
	      x_is_signed_alu_op_o <= (d_fun == `FUNC_SLT);
	  endcase // case (d_opcode)
	  
   
	  

	  case (d_opcode)
	    `OPC_OP:
	      x_is_add_o <= ~f_ir_i[30] && !(d_fun == `FUNC_SLT || d_fun == `FUNC_SLTU);
	    `OPC_OP_IMM:
	      x_is_add_o <= !(d_fun == `FUNC_SLT || d_fun == `FUNC_SLTU);
	    `OPC_BRANCH:
	      x_is_add_o <= 0;
	    default:
	      x_is_add_o <= 1;
	  endcase // case (d_opcode)
	  

	  // all multiply/divide instructions except MUL
	  x_is_undef_o <= (d_opcode == `OPC_OP && f_ir_i[25] && d_fun != 3'b000);
	  
	  if(d_is_shift)
	    x_rd_source_o <= `RD_SOURCE_SHIFTER;
	  else if (d_opcode == `OPC_SYSTEM)
	    x_rd_source_o <= `RD_SOURCE_CSR;
	  else if (d_opcode == `OPC_OP && !d_fun[2] && f_ir_i[25])
	    x_rd_source_o <= `RD_SOURCE_MULTIPLY;
	  else
	    x_rd_source_o <= `RD_SOURCE_ALU;


	  
	  // rdest write value
	  case (d_opcode)
	    `OPC_OP_IMM, `OPC_OP, `OPC_JAL, `OPC_JALR, `OPC_LUI, `OPC_AUIPC:
	      x_rd_write <= d_rd_nonzero;
	    `OPC_SYSTEM:
	      x_rd_write <= d_rd_nonzero && (d_fun != 0); // CSR instructions write to RD
	    default:
	      x_rd_write <= 0;
	  endcase // case (d_opcode)
       end // if (!d_stall_i)
   
	

   // CSR/supervisor instructions
   always@(posedge clk_i)
	if (!d_stall_i)
	  begin
	     x_csr_imm_o <= f_ir_i[19:15];
	     
	     x_csr_sel_o <= f_ir_i[31:20];
	     x_is_csr_o <= (d_opcode == `OPC_SYSTEM) && (d_fun != 0);
	     x_is_eret_o <= (d_opcode == `OPC_SYSTEM) && (d_fun == 0) && (f_ir_i [31:20] == 12'b000100000000);
	     
	     
	  end
   
   assign x_is_shift_o = x_is_shift;
   assign x_rd_write_o = x_rd_write;
   


endmodule // rv_predecode


		     
