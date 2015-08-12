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

module rv_csr
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     x_stall_i,
   input 	     x_kill_i,
   
   input 	     d_is_csr_i,
   input [2:0] 	     d_fun_i,
   input [4:0] 	     d_csr_imm_i,
   input [11:0]      d_csr_sel_i,
   
   
   input [31:0]      d_rs1_i,
   
   output reg [31:0] x_rd_o,
   
   input [39:0]      csr_time_i,
   input [39:0]      csr_cycles_i,

   // interrupt management

   output [31:0]     x_csr_write_value_o,

   input [31:0]      csr_mstatus_i,
   input [31:0]      csr_mip_i,
   input [31:0]      csr_mie_i,
   input [31:0]      csr_mepc_i,
   input [31:0]      csr_mcause_i

   );
   
   reg [31:0] 	csr_mscratch; 
   
   reg [31:0] 	csr_in1;
   reg [31:0] 	csr_in2;
   reg [31:0] 	csr_out;

  
   always@*
     case(d_csr_sel_i)
       `CSR_ID_CYCLESL: csr_in1 <= csr_cycles_i[31:0];
       `CSR_ID_CYCLESH: csr_in1 <= { 24'h0, csr_cycles_i[39:32] };
       `CSR_ID_TIMEL: csr_in1 <= csr_time_i[31:0];
       `CSR_ID_TIMEH: csr_in1 <= { 24'h0, csr_time_i[39:32] };
       `CSR_ID_MSCRATCH: csr_in1 <= csr_mscratch;
       `CSR_ID_MEPC: csr_in1 <= csr_mepc_i;
       `CSR_ID_MSTATUS: csr_in1 <= csr_mstatus_i;
       `CSR_ID_MCAUSE: csr_in1 <= csr_mcause_i;
       `CSR_ID_MIP: csr_in1 <= csr_mip_i;
       `CSR_ID_MIE: csr_in1 <= csr_mie_i;
       default: csr_in1 <= 32'hx;
     endcase // case (d_csr_sel_i)

   always@*
     x_rd_o <= csr_in1;

   genvar 	i;

   
   always@*
     case (d_fun_i)
       `CSR_OP_CSRRWI,
       `CSR_OP_CSRRSI,
       `CSR_OP_CSRRCI:
	 csr_in2 <= {27'b0, d_csr_imm_i };
       default:
	 csr_in2 <= d_rs1_i;
     endcase // case (d_fun_i)

   generate

      
      for (i=0;i<32;i=i+1) 
	begin

	   always@*
	     case(d_fun_i)
	       `CSR_OP_CSRRWI, 
	       `CSR_OP_CSRRW:
		 csr_out[i] <= csr_in2[i];
	       `CSR_OP_CSRRCI,
	       `CSR_OP_CSRRC:
		 csr_out[i] <= csr_in2[i] ? 1'b0 : csr_in1[i];
	       `CSR_OP_CSRRSI,
	       `CSR_OP_CSRRS:
		 csr_out[i] <= csr_in2[i] ? 1'b1 : csr_in1[i];
	       default:
		 csr_out[i] <= 32'hx;
	     endcase // case (d_csr_op_i)
	end // for (i=0;i<32;i=i+1)
      
      endgenerate
   
   
   always@(posedge clk_i)
     if(rst_i) 
       csr_mscratch <= 0;
     else if(!x_stall_i && !x_kill_i && d_is_csr_i) 
       case (d_csr_sel_i)
	 `CSR_ID_MSCRATCH: 
	   csr_mscratch <= csr_out;
       endcase // case (d_csr_sel_i)
   

   assign x_csr_write_value_o = csr_out;

   
endmodule
       


   
   
   
   
