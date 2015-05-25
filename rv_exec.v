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
   output 	     x_stall_req_o, 
   
   input [31:0]      d_pc_i,
   input [4:0] 	     d_rd_i,
   input [2:0] 	     d_fun_i,

   
   input [31:0]      rf_rs1_value_i,
   input [31:0]      rf_rs2_value_i,

   input 	     d_valid_i,
   
   input [4:0] 	     d_opcode_i,
   input 	     d_shifter_sign_i,
 
   input [31:0]      d_imm_i_i,
   input [31:0]      d_imm_s_i,
   input [31:0]      d_imm_b_i,
   input [31:0]      d_imm_u_i,
   input [31:0]      d_imm_j_i,

   output reg [31:0] f_branch_target_o,
   output reg 	     f_branch_take_o,

   output 	     x_load_o,
   
   // Writeback stage I/F
   output reg [2:0 ] w_fun_o,
   output reg 	     w_load_o,
   output reg 	     w_store_o,
   
   output reg [4:0]  w_rd_o,
   output reg [31:0] w_rd_value_o,
   output reg 	     w_rd_write_o,
   output reg [31:0] w_dm_addr_o,
   
   // Data memory I/F (address/store)
   output [31:0]     dm_addr_o,
   output [31:0]     dm_data_s_o,
   output [3:0]      dm_data_select_o,
   output 	     dm_store_o,
   output 	     dm_load_o,
   input 	     dm_ready_i
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

   reg 	     rd_write;
   
   wire cmp_sign_ext = ( ( d_opcode_i == `OPC_BRANCH) && ( ( d_fun_i == `BRA_GE )|| (d_fun_i == `BRA_LT ) ) )
	|| ( ( (d_opcode_i == `OPC_OP) || (d_opcode_i == `OPC_OP_IMM) ) && (d_fun_i == `FUNC_SLT ) );
   
   wire [32:0] cmp_op1 = { cmp_sign_ext ? rs1[31] : 1'b0, rs1 };
   wire [32:0] cmp_op2 = { cmp_sign_ext ? rs2[31] : 1'b0, rs2 };

   wire [32:0] cmp_rs = cmp_op1 - cmp_op2;
   
   wire        cmp_equal = (cmp_op1 == cmp_op2);
   wire        cmp_lt = cmp_rs[32];

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
     case (d_opcode_i)
       `OPC_JAL: branch_target <= d_pc_i + d_imm_j_i;
       `OPC_JALR: branch_target <= rs1 + d_imm_i_i;
       `OPC_BRANCH: branch_target <= d_pc_i + d_imm_b_i;
       
       default: branch_target<= 32'hx;
     endcase // case (d_opcode_i)

   // decode ALU operands
   always@*
     begin
	case (d_opcode_i)
	  `OPC_LUI: alu_op1 <= { d_imm_u_i[31:12] , 12'h0 };
	  `OPC_AUIPC: alu_op1 <= { d_imm_u_i[31:12] , 12'h0 };
	  `OPC_JAL: alu_op1 <= 4;
	  `OPC_JALR: alu_op1 <= 4;
	  default: alu_op1 <= rs1;
	endcase // case (d_opcode_i)
	

	case (d_opcode_i)
	  `OPC_LUI: alu_op2 <= 0;
	  `OPC_AUIPC: alu_op2 <= d_pc_i;
	  `OPC_JAL: alu_op2 <= d_pc_i;
	  `OPC_JALR: alu_op2 <= d_pc_i;
	  `OPC_OP_IMM: alu_op2 <= d_imm_i_i;
	  default: alu_op2 <= rs2;
	endcase // case (d_opcode_i)
	
     end

   wire is_add = !((d_opcode_i == `OPC_OP && d_fun_i == `FUNC_ADD && d_shifter_sign_i) || (d_fun_i == `FUNC_SLT) || (d_fun_i == `FUNC_SLTU));
   
   wire[31:0] shifter_result;

   wire alu_op_signext = (d_fun_i == `FUNC_SLT);

   wire [32:0] alu_addsub_op1 = {alu_op_signext ? alu_op1[31] : 1'b0, alu_op1 };
   wire [32:0] alu_addsub_op2 = {alu_op_signext ? alu_op2[31] : 1'b0, alu_op2 };


   
   reg [32:0]  alu_addsub_result;

   always@*
     if(is_add)
       alu_addsub_result <= alu_addsub_op1 + alu_addsub_op2;
     else
       alu_addsub_result <= alu_addsub_op1 - alu_addsub_op2;
   
   
   // the ALU itself
   always@*
     begin
	case (d_fun_i)
	  `FUNC_ADD:
	    alu_result <= alu_addsub_result[31:0];
	      
	  `FUNC_XOR: alu_result <= alu_op1 ^ alu_op2;
	  `FUNC_OR: alu_result <= alu_op1 | alu_op2;
	  `FUNC_AND: alu_result <= alu_op1 & alu_op2;
	  `FUNC_SLT: alu_result <= alu_addsub_result[32]?1:0;
	  `FUNC_SLTU: alu_result <= alu_addsub_result[32]?1:0;
	  `FUNC_SL, `FUNC_SR: alu_result <= shifter_result;
	  

	  default: alu_result <= 32'hx;
	endcase // case (d_fun_i)
     end // always@ *

   reg 	shifter_req_d0;
   wire shifter_req = (d_valid_i) && (d_fun_i == `FUNC_SL || d_fun_i == `FUNC_SR) &&
	(d_opcode_i == `OPC_OP || d_opcode_i == `OPC_OP_IMM );
      
   rv_shifter shifter 
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .d_i(alu_op1),
      .q_o(shifter_result),
      .shift_i(alu_op2[4:0]),
      .func_i(d_fun_i),
      .arith_i(d_shifter_sign_i)
      );



   always@(posedge clk_i)
     shifter_req_d0 <= shifter_req;
   
   wire shifter_stall_req = shifter_req && !shifter_req_d0;
   
   // rdest write value
   always@*
    begin
       case (d_opcode_i)
	 `OPC_OP_IMM, `OPC_OP, `OPC_JAL, `OPC_JALR, `OPC_LUI, `OPC_AUIPC:
	   begin  
	      rd_value <= alu_result;
	      rd_write <= 1;
	   end
	 
	 default: 
	   begin
	    rd_value <= 32'hx;
	    rd_write <= 0;
	   end
       endcase
    end

   // generate load/store address
   always@*
     begin
	case (d_opcode_i) 
	  `OPC_LOAD: dm_addr <= rs1 + d_imm_i_i;
	  `OPC_STORE: dm_addr <= rs1 + d_imm_s_i;
	  default: dm_addr <= 32'hx;
	  
	endcase // case (d_opcode_i)
     end

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

   wire is_load = (d_opcode_i == `OPC_LOAD ? 1: 0) && d_valid_i && !x_kill_i;
   wire is_store = (d_opcode_i == `OPC_STORE ? 1: 0) && d_valid_i && !x_kill_i;

   assign dm_load_o = is_load;
   assign dm_store_o = is_store;
   
   always@(posedge clk_i) 
      if (rst_i) begin
	 f_branch_target_o <= 0;
	 f_branch_take_o <= 0;
	 w_rd_write_o <= 0;
	 w_rd_o <= 0;
	 w_fun_o <= 0;
	 w_load_o <= 0;
	 w_store_o <= 0;
	 w_dm_addr_o <= 0;
	 
	 
      end else if (!x_stall_i) begin
	 f_branch_target_o <= branch_target;
	 f_branch_take_o <= branch_take && !x_kill_i && d_valid_i;

	 w_rd_o <= d_rd_i;
	 
//	 if(!shifter_stall_req)
	 w_rd_value_o <= rd_value;
	 
	 w_rd_write_o <= rd_write && !x_kill_i && d_valid_i;

	 w_fun_o <= d_fun_i;
	 w_load_o <= is_load;
	 w_store_o <= is_store;
	 
	 w_dm_addr_o <= dm_addr;
	 
      end else begin // if (!x_stall_i)
	 f_branch_take_o <= 0;
	 w_rd_write_o <= 0;
	 w_load_o <= 0;
	 w_store_o <= 0;
      end

   
   assign x_stall_req_o = shifter_stall_req || ((is_store || is_load) && !dm_ready_i);
   assign x_load_o = is_load;
   
   

endmodule
	       
   
   

   
   
