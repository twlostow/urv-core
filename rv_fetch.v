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

`timescale 1ns/1ps

module rv_fetch 
(
 input 		   clk_i,
 input 		   rst_i,
 
 output [31:0] 	   im_addr_o,
 input [31:0] 	   im_data_i,
 input 		   im_valid_i,

 input 		   f_stall_i,
 input 		   f_kill_i,

 output reg [4:0]  rf_rs1_o,
 output reg [4:0]  rf_rs2_o,

 output reg 	   f_load_hazard_o,
 
 output [31:0] 	   f_ir_o,
 output reg [31:0] f_pc_o,
 output reg [31:0] f_pc_plus_4_o,
 
 output reg 	   f_valid_o,
  
 input [31:0] 	   x_pc_bra_i,
 input 		   x_bra_i
);

   reg [31:0] pc;
   reg [31:0] ir;
   reg 	      rst_d;

   wire [4:0] rs1_mem = im_data_i[19:15];
   wire [4:0] rs2_mem = im_data_i[24:20];

   wire [4:0] rd = ir [11:7];
   
   always@*
     if(!f_stall_i)
       begin
	  rf_rs1_o <= im_data_i [19:15];
	  rf_rs2_o <= im_data_i [24:20];
       end else begin
	  rf_rs1_o <= ir[19:15];
	  rf_rs2_o <= ir[24:20];
       end

   always@*
     f_load_hazard_o <= ( (rs1_mem == rd)  || (rs2_mem == rd) ) && !f_kill_i;
   
 

  

   reg [31:0]  pc_next;

   always@*
     if( x_bra_i )
       pc_next <= x_pc_bra_i;
     else if (f_stall_i || !im_valid_i)
       pc_next <= pc;
     else
       pc_next <= pc + 4;
   
   
   
   assign f_ir_o = ir;
   assign im_addr_o = pc_next;
   
 
   always@(posedge clk_i)
     if (rst_i) begin
	pc <= -4;
	ir <= 0;
	f_valid_o <= 0;
	rst_d <= 0;
	
     end else begin
	rst_d <= 1;

	if (!f_stall_i) begin
	      
	   pc <= pc_next;
	   f_pc_o <= pc;

	   if(im_valid_i) begin
	      ir <= im_data_i; // emit nop
	      f_valid_o <= (rst_d && !f_kill_i);
	   end else begin// if (i_valid_i)
	      f_valid_o <= 0;
	   end
	   
	end 
     end // else: !if(rst_i)


endmodule
 
  
