`include "rv_defs.v"

`timescale 1ns/1ps

module rv_multiply 
  (
   input 	 clk_i,
   input 	 rst_i,
   input 	 x_stall_i,
   
   input [31:0]  d_rs1_i,
   input [31:0]  d_rs2_i,
   input [2:0] 	 d_fun_i,

   output reg [31:0] w_rd_o
   );

   reg [31:0] 	     yl_xl, yl_xh, yh_xl;



   wire[17:0] xl = d_rs1_i[17:0];
   wire[13:0] xh = d_rs1_i[31:18];
   wire[17:0] yl = d_rs2_i[17:0];
   wire[13:0] yh = d_rs2_i[31:18];
   
		 
   always@(posedge clk_i)
     if(!x_stall_i)
       begin
	  yh_xl <= $signed(yh) * $signed(xl);
	  yl_xh <= $signed(yl) * $signed(xh);
	  yl_xl <= $unsigned(yl) * $unsigned(xl);
       end
   

//       stage0 <= $signed(d_rs1_i) * $signed(d_rs2_i);

   always@*
     w_rd_o <= yl_xl + {yl_xh[13:0], 18'h0} + {yh_xl[13:0], 18'h0};
 
   
   
endmodule // rv_multiply

   
   

