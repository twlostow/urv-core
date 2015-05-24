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

module rv_cpu
  (
   input 	 clk_i,
   input 	 rst_i,

   // instruction mem I/F
   output [31:0] im_addr_o,
   input [31:0]  im_data_i,
   input 	 im_valid_i,

   // data mem I/F
   output [31:0] dm_addr_o,
   output [31:0] dm_data_s_o,
   input [31:0]  dm_data_l_i,
   output [3:0]  dm_data_select_o,
   input 	 dm_ready_i,

   output 	 dm_store_o,
   output 	 dm_load_o,
   input 	 dm_load_done_i,
   input 	 dm_store_done_i 
   );

   wire 	 f_stall;
   wire 	 w_stall;
   wire 	 x_stall;
   wire 	 x_kill;
   wire 	 f_kill;
 
   wire [31:0] 	 f2d_pc, f2d_pc_plus_4, f2d_ir;
   wire 	 f2d_ir_valid;
   wire [31:0] 	 x2f_pc_bra;
   wire 	 x2f_bra;
   wire 	 f2d_valid;
   

   wire 	 f_stall_req;
   
   
   
   rv_fetch fetch
     (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .im_addr_o(im_addr_o),
      .im_data_i(im_data_i),
      .im_valid_i(im_valid_i),
      
      .f_stall_i(f_stall),
      .f_kill_i(f_kill),
      .f_valid_o(f2d_valid),
      
      .f_ir_o(f2d_ir),
      .f_pc_o(f2d_pc),

    //  .f_ir_valid_o(f2d_ir_valid),
      .x_pc_bra_i(x2f_pc_bra),
      .x_bra_i(x2f_bra)
      );

   wire [31:0] 	 d2x_pc;
   wire [4:0] 	 rf_rs1, d2x_rs1;
   wire [4:0] 	 rf_rs2, d2x_rs2;
   wire [4:0] 	 d2x_rd;
   wire [4:0] 	 d2x_shamt;
   wire [2:0] 	 d2x_fun;
   wire [4:0] 	 d2x_opcode;
   wire 	 d2x_shifter_sign;
   wire [31:0] 	 d2x_imm_i, d2x_imm_s, d2x_imm_u, d2x_imm_b, d2x_imm_j;
   
   
   rv_predecode decode
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .im_data_i(im_data_i),

      .f_stall_i(f_stall),
      .f_ir_i(f2d_ir),
      .f_pc_i(f2d_pc),

      .x_pc_o(d2x_pc),
     
      .rf_rs1_o(rf_rs1),
      .rf_rs2_o(rf_rs2),

      .x_rs1_o(d2x_rs1),
      .x_rs2_o(d2x_rs2),
      
      .x_rd_o(d2x_rd),

      .x_shamt_o(d2x_shamt),
      .x_fun_o(d2x_fun),

      .x_opcode_o(d2x_opcode),
      .x_shifter_sign_o(d2x_shifter_sign),
     
      .x_imm_i_o(d2x_imm_i),
      .x_imm_s_o(d2x_imm_s),
      .x_imm_b_o(d2x_imm_b),
      .x_imm_u_o(d2x_imm_u),
      .x_imm_j_o(d2x_imm_j)
      );

   wire [31:0] 	 x_rs2_value, x_rs1_value;
   
   wire [4:0] 	 rf_rd;
   wire [31:0] 	 rf_rd_value;
   wire 	 rf_rd_write;

   
   rv_regfile regfile
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .x_stall_i(x_stall),
      .w_stall_i(w_stall),

      .rf_rs1_i(rf_rs1),
      .rf_rs2_i(rf_rs2),

      .d_rs1_i(d2x_rs1),
      .d_rs2_i(d2x_rs2),

      .x_rs1_value_o(x_rs1_value),
      .x_rs2_value_o(x_rs2_value),

      .w_rd_i(rf_rd),
      .w_rd_value_i(rf_rd_value),
      .w_rd_store_i(rf_rd_write)
      );

   wire [4:0] 	 x2w_rd;
   wire [31:0] 	 x2w_rd_value;
   wire [31:0] 	 x2w_dm_addr;
   wire 	 x2w_rd_write;
   wire [2:0] 	 x2w_fun;
   wire 	 x2w_store;
   

   
   rv_exec execute
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .x_stall_i(x_stall),
      .x_kill_i(x_kill),
      .x_stall_req_o(x_stall_req),
      .d_valid_i(f2d_valid),
   
      .d_pc_i(d2x_pc),
      .d_rd_i(d2x_rd),
      .d_fun_i(d2x_fun),

      .rf_rs1_value_i(x_rs1_value),
      .rf_rs2_value_i(x_rs2_value),
   
      .d_opcode_i(d2x_opcode),
      .d_shifter_sign_i(d2x_shifter_sign),
 
      .d_imm_i_i(d2x_imm_i),
      .d_imm_s_i(d2x_imm_s),
      .d_imm_b_i(d2x_imm_b),
      .d_imm_u_i(d2x_imm_u),
      .d_imm_j_i(d2x_imm_j),

      .f_branch_target_o (x2f_pc_bra), // fixme: consistent naming
      .f_branch_take_o (x2f_bra),

   // Writeback stage I/F
      .w_fun_o(x2w_fun),
      .w_load_o(x2w_load),
      .w_store_o(x2w_store),
   
      .w_dm_addr_o(x2w_dm_addr),
      .w_rd_o(x2w_rd),
      .w_rd_value_o(x2w_rd_value),
      .w_rd_write_o(x2w_rd_write),

      .dm_addr_o(dm_addr_o),
      .dm_data_s_o(dm_data_s_o),
      .dm_data_select_o(dm_data_select_o),
      .dm_store_o(dm_store_o),
      .dm_load_o(dm_load_o),
      .dm_ready_i(dm_ready_i)
   );

   wire 	 w_stall_req;
   

   rv_writeback writeback
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .w_stall_i(w_stall),
      .w_stall_req_o(w_stall_req),
      
      .x_fun_i(x2w_fun),
      .x_load_i(x2w_load),
      .x_store_i(x2w_store),
      
      .x_rd_i(x2w_rd),
      .x_rd_value_i(x2w_rd_value),
      .x_rd_write_i(x2w_rd_write),
      .x_dm_addr_i(x2w_dm_addr),
      
      .dm_data_l_i(dm_data_l_i),
      .dm_load_done_i(dm_load_done_i),
      .dm_store_done_i(dm_store_done_i),
      
      
      .rf_rd_value_o(rf_rd_value),
      .rf_rd_o(rf_rd),
      .rf_rd_write_o(rf_rd_write)
   );

   reg 		 x2f_bra_d0;

   always@(posedge clk_i)
     if(rst_i)
       x2f_bra_d0 <= 0;
   else if (!x_stall)
     x2f_bra_d0 <= x2f_bra;
     
   
   assign f_stall =  x_stall_req || w_stall_req;
   assign x_stall =  x_stall_req || w_stall_req;
// || (!f2d_ir_valid);
   assign w_stall = 0;
 //x_stall_req;

   assign x_kill = x2f_bra || x2f_bra_d0;
   assign f_kill = x2f_bra ;


   
//&& ~x_bra_d0;
   
      
endmodule // rv_cpu

   

   
