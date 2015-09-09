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
 input 	       clk_i,
 input 	       rst_i,

 input 	       en1_i,
 
 input [4:0]   a1_i,
 output reg [31:0] q1_o,

 input [4:0]   a2_i,
 input [31:0]  d2_i,
 input 	       we2_i
 );

   reg [31:0] ram [0:31];
   reg [31:0] bypass_r;
   reg 	      bypass;


   
   reg [31:0] q1_int;
   
   always@(posedge clk_i)
     if(en1_i)
       q1_o <= ram[a1_i];

   always@(posedge clk_i)
     if(we2_i)
	ram[a2_i] <= d2_i;

// synthesis translate_off
initial begin : ram_init
   integer i;

   for(i=0;i<32; i=i+1) begin
      ram[i] = 0;
   end
end
// synthesis translate_on
   
endmodule // rv_regmem2


module rv_regfile
(
 input 	       clk_i,
 input 	       rst_i,

 input 	       d_stall_i,

 input [4:0]   rf_rs1_i,
 input [4:0]   rf_rs2_i,

 input [4:0]   d_rs1_i,
 input [4:0]   d_rs2_i,

 output reg [31:0] x_rs1_value_o,
 output reg [31:0] x_rs2_value_o,

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
		    .en1_i(!d_stall_i),
		    .a1_i(rf_rs1_i),
		    .q1_o(rs1_regfile),

		    .a2_i(w_rd_i),
		    .d2_i(w_rd_value_i),
		    .we2_i (write));
      
		   
   rv_regmem bank1 (
		    .clk_i(clk_i),
		    .rst_i (rst_i ),
		    .en1_i(!d_stall_i),
		    .a1_i(rf_rs2_i),
		    .q1_o(rs2_regfile),

		    .a2_i (w_rd_i),
		    .d2_i (w_rd_value_i),
		    .we2_i (write)
		    );
   
   wire 	  rs1_bypass_x = w_bypass_rd_write_i && (w_rd_i == d_rs1_i) && (w_rd_i != 0);
   wire 	  rs2_bypass_x = w_bypass_rd_write_i && (w_rd_i == d_rs2_i) && (w_rd_i != 0);

   reg 		  rs1_bypass_w, rs2_bypass_w;
 
   always@(posedge clk_i)
     if(rst_i)
       begin
          rs1_bypass_w <= 0;
	  rs2_bypass_w <= 0;
       end else begin
	  rs1_bypass_w <= write && (rf_rs1_i == w_rd_i);
	  rs2_bypass_w <= write && (rf_rs2_i == w_rd_i);
       end
   
   reg [31:0] 	  bypass_w;

   always@(posedge clk_i)
     if(write)
       bypass_w <= w_rd_value_i;

   always@*
     begin
	case ( {rs1_bypass_x, rs1_bypass_w } ) // synthesis parallel_case full_case
	  2'b10, 2'b11:
	    x_rs1_value_o <= w_bypass_rd_value_i;
	  2'b01:
	    x_rs1_value_o <= bypass_w;
	  default:
	    x_rs1_value_o <= rs1_regfile;
	endcase // case ( {rs1_bypass_x, rs1_bypass_w } )

	case ( {rs2_bypass_x, rs2_bypass_w } ) // synthesis parallel_case full_case
	  2'b10, 2'b11:
	    x_rs2_value_o <= w_bypass_rd_value_i;
	  2'b01:
	    x_rs2_value_o <= bypass_w;
	  default:
	    x_rs2_value_o <= rs2_regfile;	 
	endcase // case ( {rs2_bypass_x, rs2_bypass_w } )
     end // always@ *
   

endmodule // rv_regfile

		 
module rv_regmem_distram
(
 input 		   clk_i,
 
 input [4:0] 	   a1_i,
 output [31:0] q1_o,

 
 input [4:0] 	   a2_i,
 input [31:0] 	   d2_i,
 input 		   we2_i
 );

   reg [31:0] ram [0:31];
   
   assign q1_o = ram[a1_i];

   always@(posedge clk_i)
     if(we2_i)
	ram[a2_i] <= d2_i;

// synthesis translate_off
initial begin : ram_init
   integer i;

   for(i=0;i<32; i=i+1) begin
      ram[i] = 0;
   end
end
// synthesis translate_on
   
endmodule // rv_regmem2


module rv_regfile_distram
(
 input 	       clk_i,
 input 	       rst_i,

 input 	       d_stall_i,

 input [4:0]   rf_rs1_i,
 input [4:0]   rf_rs2_i,

 input [4:0]   d_rs1_i,
 input [4:0]   d_rs2_i,

 output reg [31:0] x_rs1_value_o,
 output reg [31:0] x_rs2_value_o,

 input [4:0]   w_rd_i,
 input [31:0]  w_rd_value_i,
 input 	       w_rd_store_i,

 input 	       w_bypass_rd_write_i,
 input [31:0]  w_bypass_rd_value_i
 
 );


   wire [31:0] rs1_regfile;
   wire [31:0] rs2_regfile;
   wire 	  write  = (w_rd_store_i && (w_rd_i != 0));

   rv_regmem_distram bank0 (
		    .clk_i(clk_i),
		    .a1_i(rf_rs1_i),
		    .q1_o(rs1_regfile),

		    .a2_i(w_rd_i),
		    .d2_i(w_rd_value_i),
		    .we2_i (write));
      
		   
   rv_regmem_distram bank1 (
		    .clk_i(clk_i),
		    .a1_i(rf_rs2_i),
		    .q1_o(rs2_regfile),

		    .a2_i (w_rd_i),
		    .d2_i (w_rd_value_i),
		    .we2_i (write)
		    );
   
   wire 	  rs1_bypass_x = w_bypass_rd_write_i && (w_rd_i == d_rs1_i) && (w_rd_i != 0);
   wire 	  rs2_bypass_x = w_bypass_rd_write_i && (w_rd_i == d_rs2_i) && (w_rd_i != 0);

   reg 		  rs1_bypass_w, rs2_bypass_w;
 
   always@*
     begin
	rs1_bypass_w <= write && (rf_rs1_i == w_rd_i);
	rs2_bypass_w <= write && (rf_rs2_i == w_rd_i);
     end
   

   always@(posedge clk_i)
     if(!d_stall_i)
     begin
	case ( {rs1_bypass_x, rs1_bypass_w } ) // synthesis parallel_case full_case
	  2'b10, 2'b11:
	    x_rs1_value_o <= w_bypass_rd_value_i;
	  2'b01:
	    x_rs1_value_o <= w_rd_value_i;
	  default:
	    x_rs1_value_o <= rs1_regfile;
	endcase // case ( {rs1_bypass_x, rs1_bypass_w } )

	case ( {rs2_bypass_x, rs2_bypass_w } ) // synthesis parallel_case full_case
	  2'b10, 2'b11:
	    x_rs2_value_o <= w_bypass_rd_value_i;
	  2'b01:
	    x_rs2_value_o <= w_rd_value_i;
	  default:
	    x_rs2_value_o <= rs2_regfile;	 
	endcase // case ( {rs2_bypass_x, rs2_bypass_w } )
     end // always@ *
   

endmodule // rv_regfile

		 
