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

module rv_exec
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     x_stall_i,
   input 	     x_kill_i,
   output reg 	     x_stall_req_o,
   
   
   input [31:0]      d_pc_i,
   input [4:0] 	     d_rd_i,
   input [2:0] 	     d_fun_i,

   
   input [31:0]      rf_rs1_value_i,
   input [31:0]      rf_rs2_value_i,


   input 	     d_valid_i,

   
   input [4:0] 	     d_opcode_i,
   input 	     d_shifter_sign_i,

   input 	     d_is_csr_i,
   input 	     d_is_eret_i,
   input [4:0] 	     d_csr_imm_i,
   input [11:0]      d_csr_sel_i,
      
   input [31:0]      d_imm_i,
   input 	     d_is_signed_compare_i,
   input 	     d_is_signed_alu_op_i,
   input 	     d_is_add_i,
   input 	     d_is_shift_i,
   input 	     d_is_load_i,
   input 	     d_is_store_i,
   input 	     d_is_divide_i,
   input 	     d_is_undef_i,

   input [31:0]      d_alu_op1_i,
   input [31:0]      d_alu_op2_i,

   input 	     d_use_op1_i,
   input 	     d_use_op2_i,
   
   
   input [2:0] 	     d_rd_source_i,
   input 	     d_rd_write_i,
   
   output reg [31:0] f_branch_target_o,
   output 	     f_branch_take_o,


   input 	     irq_i,
   
   // Writeback stage I/F
   output reg [2:0 ] w_fun_o,
   output reg 	     w_load_o,
   output reg 	     w_store_o,

   output reg 	     w_valid_o,
   output reg [4:0]  w_rd_o,
   output reg [31:0] w_rd_value_o,
   output reg 	     w_rd_write_o,
   output reg [31:0] w_dm_addr_o,
   output reg [1:0]  w_rd_source_o,
   output [31:0]     w_rd_shifter_o,
   output [31:0]     w_rd_multiply_o,
   
   
   // Data memory I/F (address/store)
   output [31:0]     dm_addr_o,
   output [31:0]     dm_data_s_o,
   output [3:0]      dm_data_select_o,
   output 	     dm_store_o,
   output 	     dm_load_o,
   input 	     dm_ready_i,

   input [39:0]      csr_time_i,
   input [39:0]      csr_cycles_i,
   input 	     timer_tick_i
   
   );

   wire [31:0] 	 rs1, rs2;

   assign rs1 = rf_rs1_value_i;
   assign rs2 = rf_rs2_value_i;
   
   reg [31:0] 	 alu_op1, alu_op2, alu_result;
   reg [31:0] 	 rd_value;
      
   reg 		 branch_take;
   reg 		 branch_condition_met;
   
   reg [31:0] 	 branch_target;

   reg [31:0] 	 dm_addr, dm_data_s, dm_select_s;

   wire [32:0] cmp_op1 = { d_is_signed_compare_i ? rs1[31] : 1'b0, rs1 };
   wire [32:0] cmp_op2 = { d_is_signed_compare_i ? rs2[31] : 1'b0, rs2 };

   wire [32:0] cmp_rs = cmp_op1 - cmp_op2;
   
   wire        cmp_equal = (cmp_op1 == cmp_op2);
   wire        cmp_lt = cmp_rs[32];

   reg 	       f_branch_take;
   
   wire [31:0] rd_shifter;
   wire [31:0] rd_csr;
   wire [31:0] rd_mul;
   wire [31:0] rd_div;

   wire        exception;
   wire [31:0] csr_mie, csr_mip, csr_mepc, csr_mstatus,csr_mcause;
   wire [31:0] csr_write_value;
   wire [31:0] exception_address, exception_vector;
   
   
   rv_csr csr_regs
     (
      
      .clk_i(clk_i),
      .rst_i(rst_i),

      .x_stall_i(x_stall_i),
      .x_kill_i(x_kill_i),
      
      .d_is_csr_i(d_is_csr_i),
      .d_fun_i(d_fun_i),
      .d_csr_imm_i(d_csr_imm_i),
      .d_csr_sel_i (d_csr_sel_i),
      
      .d_rs1_i(rs1),

      .x_rd_o(rd_csr),
      .x_csr_write_value_o(csr_write_value),

      .csr_time_i(csr_time_i),
      .csr_cycles_i(csr_cycles_i),

      .csr_mstatus_i(csr_mstatus),
      .csr_mip_i(csr_mip),
      .csr_mie_i(csr_mie),
      .csr_mepc_i(csr_mepc),
      .csr_mcause_i(csr_mcause)
      );

   rv_exceptions exception_unit 
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .x_stall_i (x_stall_i),
      .x_kill_i (x_kill_i),
      
      .d_is_csr_i(d_is_csr_i),
      .d_is_eret_i (d_is_eret_i),
      .d_fun_i(d_fun_i),
      .d_csr_imm_i(d_csr_imm_i),
      .d_csr_sel_i(d_csr_sel_i),
      .x_csr_write_value_i(csr_write_value),
      
      .exp_irq_i(irq_i),
      .exp_tick_i(timer_tick_i),
      .exp_breakpoint_i(1'b0),
      .exp_unaligned_load_i(1'b0),
      .exp_unaligned_store_i(1'b0),
      .exp_invalid_insn_i(d_is_undef_i && !x_stall_i && !x_kill_i && d_valid_i),

      .x_exception_o(exception),
      .x_exception_pc_i(d_pc_i),
      .x_exception_pc_o(exception_address),
      .x_exception_vector_o(exception_vector),

      .csr_mstatus_o(csr_mstatus),
      .csr_mip_o(csr_mip),
      .csr_mie_o(csr_mie),
      .csr_mepc_o(csr_mepc),
      .csr_mcause_o(csr_mcause)

      );

   
   // branch condition decoding   
   always@*
     case (d_fun_i)
       `BRA_EQ: branch_condition_met <= cmp_equal;
       `BRA_NEQ: branch_condition_met <= ~cmp_equal;
       `BRA_GE: branch_condition_met <= ~cmp_lt | cmp_equal;
       `BRA_LT: branch_condition_met <= cmp_lt;
       `BRA_GEU: branch_condition_met <= ~cmp_lt | cmp_equal;
       `BRA_LTU: branch_condition_met <= cmp_lt;
       default: branch_condition_met <= 0;
     endcase // case (d_fun_i)
   
   always@*
     if(d_is_eret_i )
       branch_target <= exception_address;
     else if ( exception )
       branch_target <= exception_vector;
     else case (d_opcode_i)
	    `OPC_JAL: branch_target <= d_pc_i + d_imm_i;
	    `OPC_JALR: branch_target <= rs1 + d_imm_i;
	    `OPC_BRANCH: branch_target <= d_pc_i + d_imm_i;
	    default: branch_target<= 32'hx;
	  endcase // case (d_opcode_i)

   // decode ALU operands
   always@*
     begin
	alu_op1 <= d_use_op1_i ? d_alu_op1_i : rs1;
	alu_op2 <= d_use_op2_i ? d_alu_op2_i : rs2;
     end
	

   wire [32:0] alu_addsub_op1 = {d_is_signed_alu_op_i ? alu_op1[31] : 1'b0, alu_op1 };
   wire [32:0] alu_addsub_op2 = {d_is_signed_alu_op_i ? alu_op2[31] : 1'b0, alu_op2 };
   
   reg [32:0]  alu_addsub_result;

   always@*
     if(d_is_add_i)
       alu_addsub_result <= alu_addsub_op1 + alu_addsub_op2;
     else
       alu_addsub_result <= alu_addsub_op1 - alu_addsub_op2;
   
   
   // the ALU itself
   always@*
     begin
	case (d_fun_i)
	  `FUNC_ADD:
	    alu_result <= alu_addsub_result[31:0];
	  `FUNC_XOR: 
	    alu_result <= alu_op1 ^ alu_op2;
	  `FUNC_OR: 
	    alu_result <= alu_op1 | alu_op2;
	  `FUNC_AND: 
	    alu_result <= alu_op1 & alu_op2;
	  `FUNC_SLT: 
	    alu_result <= alu_addsub_result[32]?1:0;
	  `FUNC_SLTU: 
	    alu_result <= alu_addsub_result[32]?1:0;
	  default: alu_result <= 32'hx;
	endcase // case (d_fun_i)
     end // always@ *

   
   rv_shifter shifter 
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .x_stall_i(x_stall_i),
      .d_valid_i(d_valid_i),
      .d_rs1_i(rs1),
      .d_shamt_i(alu_op2[4:0]),
      .d_fun_i(d_fun_i),
      .d_shifter_sign_i(d_shifter_sign_i),
      .d_is_shift_i(d_is_shift_i),

      .w_rd_o(w_rd_shifter_o)
     );

      wire divider_stall_req = 0;

  rv_multiply multiplier 
    (
     .clk_i(clk_i),
     .rst_i(rst_i),
     .x_stall_i(x_stall_i),
   
     .d_rs1_i(rs1),
     .d_rs2_i(rs2),
     .d_fun_i(d_fun),
     .w_rd_o (w_rd_multiply_o)
   );

/*   wire divider_stall_req;
   wire [31:0] rd_divide;
   
   rv_divide divider
     (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .x_stall_i(x_stall_i),
      .x_kill_i(x_kill_i),
      .x_stall_req_o(divider_stall_req),

      .d_valid_i(d_valid_i),
      .d_is_divide_i(d_is_divide_i),
   
      .d_rs1_i(rs1),
      .d_rs2_i(rs2),

      .d_fun_i(d_fun_i),

      .x_rd_o(rd_divide)
   );

 -----/\----- EXCLUDED -----/\----- */

   always@*
     case (d_rd_source_i)
       `RD_SOURCE_ALU: rd_value <= alu_result;
       `RD_SOURCE_CSR: rd_value <= rd_csr;
       
//       `RD_SOURCE_DIVIDE: rd_value <= rd_divide;
       default: rd_value <= 32'hx;
     endcase // case (x_rd_source_i)
   
   // generate load/store address
   always@*
     begin
	dm_addr <=  rs1 + { {20{d_imm_i[11]}}, d_imm_i[11:0] };
     end

   reg unaligned_addr;
   
   always@*
	case (d_fun_i)
	  `LDST_B,
	  `LDST_BU: 
	    unaligned_addr <= 0;
	  
	  `LDST_H,
	    `LDST_HU:
	    unaligned_addr <= (dm_addr[0]);
	  
	  `LDST_L:
	    unaligned_addr <= (dm_addr[1:0] != 2'b00);
	  default:
	    unaligned_addr <= 0;
	  
	endcase // case (d_fun_i)
     
   
   // generate store value/select
   always@*
     begin
	case (d_fun_i)
	  `LDST_B: 
	    begin
	       dm_data_s <= { rs2[7:0], rs2[7:0], rs2[7:0], rs2[7:0] };
	       dm_select_s[0] <= (dm_addr [1:0] == 2'b00);
	       dm_select_s[1] <= (dm_addr [1:0] == 2'b01);
	       dm_select_s[2] <= (dm_addr [1:0] == 2'b10);
	       dm_select_s[3] <= (dm_addr [1:0] == 2'b11);
	    end
	  
	  `LDST_H:
	    begin
	       dm_data_s <= { rs2[15:0], rs2[15:0] };
	       dm_select_s[0] <= (dm_addr [1] == 1'b0);
	       dm_select_s[1] <= (dm_addr [1] == 1'b0);
	       dm_select_s[2] <= (dm_addr [1] == 1'b1);
	       dm_select_s[3] <= (dm_addr [1] == 1'b1);
	    end

	  `LDST_L:
	    begin
	       dm_data_s <= rs2;
	       dm_select_s <= 4'b1111;
	    end
	  
	  default:
	    begin
	       dm_data_s <= 32'hx;
	       dm_select_s <= 4'hx;
	    end
	endcase // case (d_fun_i)
     end

   //branch decision
   always@*
     if( exception || d_is_eret_i)
       branch_take <= 1;
     else
       case (d_opcode_i)
	 `OPC_JAL, `OPC_JALR: 
	   branch_take <= 1;
	 `OPC_BRANCH:
	   branch_take <= branch_condition_met;
	 default: 
	   branch_take <= 0;
       endcase // case (d_opcode_i)
     
   
   // generate load/store requests

   assign dm_addr_o = dm_addr;
   assign dm_data_s_o = dm_data_s;
   assign dm_data_select_o = dm_select_s;


   assign dm_load_o =  d_is_load_i & d_valid_i & !x_kill_i & !x_stall_i & !exception;
   assign dm_store_o = d_is_store_i & d_valid_i & !x_kill_i & !x_stall_i & !exception;
   
   
   always@(posedge clk_i) 
      if (rst_i) begin
	 f_branch_take   <= 0;
	 w_load_o <= 0;
	 w_store_o <= 0;
	 w_valid_o <= 0;
      end else if (!x_stall_i) begin
	 f_branch_target_o <= branch_target;
	 f_branch_take <= branch_take && !x_kill_i && d_valid_i;
	 w_rd_o <= d_rd_i;
	 w_rd_value_o <= rd_value;
	 w_rd_write_o <= d_rd_write_i && !x_kill_i && d_valid_i && !exception;
	 w_rd_source_o <= d_rd_source_i;
	 w_fun_o <= d_fun_i;
	 w_load_o <= d_is_load_i && !x_kill_i && d_valid_i && !exception;
	 w_store_o <= d_is_store_i && !x_kill_i && d_valid_i && !exception;
	 w_dm_addr_o <= dm_addr;
	 w_valid_o <= !exception; 
      end // else: !if(rst_i)

   assign f_branch_take_o = f_branch_take;
   
   always@*
     if(f_branch_take)
       x_stall_req_o <= 0;
     else if(divider_stall_req)
       x_stall_req_o <= 1;
     else if ((d_is_load_i || d_is_store_i) && d_valid_i && !x_kill_i && !dm_ready_i)
       x_stall_req_o <= 1;
     else
       x_stall_req_o <= 0;

endmodule
	       
   
   

   
   
