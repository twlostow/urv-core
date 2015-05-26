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

module rv_regmem 
(
 
 input 		   clk_i,
 input 		   rst_i,

 input [4:0] 	   a1_i,
 output  [31:0] q1_o,

 input [4:0] 	   a2_i,
 input [31:0] 	   d2_i,
 input 		   we2_i
 );

   reg [31:0] ram [0:31];
   reg [31:0] bypass_r;
   reg 	      bypass;


   
   reg [31:0] q1_int;
   
   always@(posedge clk_i)
       q1_int <= ram[a1_i];

   always@(posedge clk_i)
     if(we2_i)
	ram[a2_i] <= d2_i;

   // bypass logic

   always@(posedge clk_i)
     if(rst_i)
       bypass <= 0;
     else
       bypass <= we2_i && (a1_i == a2_i);

   
   always@(posedge clk_i)
     begin
	if(we2_i)
	  bypass_r <= d2_i;
     end
   
   assign q1_o = bypass ? bypass_r : q1_int;
   
   
// synthesis translate_off
initial begin : ram_init
   integer i;

   for(i=0;i<32; i=i+1) begin
      ram[i] = 0;
      
   end
   
   
end

// synthesis translate_on   
   
endmodule // rv_regmem

   
  

module rv_regfile
(
 input 	       clk_i,
 input 	       rst_i,

 input 	       x_stall_i,
 input 	       w_stall_i,

 input [4:0]   rf_rs1_i,
 input [4:0]   rf_rs2_i,

 input [4:0]   d_rs1_i,
 input [4:0]   d_rs2_i,

 output [31:0] x_rs1_value_o,
 output [31:0] x_rs2_value_o,

 input [4:0]   w_rd_i,
 input [31:0]  w_rd_value_i,
 input 	       w_rd_store_i,

 input 	       w_bypass_rd_write_i,
 input [31:0]  w_bypass_rd_value_i
 
 );


      wire [31:0] rs1_regfile;
      wire [31:0] rs2_regfile;
   wire 	  write  = (w_rd_store_i && (w_rd_i != 0));

   rv_regmem bank0 (
		    .clk_i(clk_i),
		    .rst_i (rst_i ),
		    .a1_i(rf_rs1_i),
		    .q1_o(rs1_regfile),

		    .a2_i(w_rd_i),
		    .d2_i(w_rd_value_i),
		    .we2_i (write));
      
		   
   rv_regmem bank1 (
		    .clk_i(clk_i),
		    .rst_i (rst_i ),

		    .a1_i(rf_rs2_i),
		    .q1_o(rs2_regfile),

		    .a2_i (w_rd_i),
		    .d2_i (w_rd_value_i),
		    .we2_i (write)
		    );
      

   
   wire 	  rs1_bypass = w_bypass_rd_write_i && (w_rd_i == d_rs1_i);
   wire 	  rs2_bypass = w_bypass_rd_write_i && (w_rd_i == d_rs2_i);
   
   assign x_rs1_value_o = rs1_bypass ? w_bypass_rd_value_i : rs1_regfile;
   assign x_rs2_value_o = rs2_bypass ? w_bypass_rd_value_i : rs2_regfile;

/*   wire 	  rs1_bypass = write && (w_rd_i == d_rs1_i);
   wire 	  rs2_bypass = write && (w_rd_i == d_rs2_i);
   
   assign x_rs1_value_o = rs1_bypass ? w_rd_value_i : rs1_regfile;
   assign x_rs2_value_o = rs2_bypass ? w_rd_value_i : rs2_regfile;*/

endmodule // rv_regfile


      		    
		 
