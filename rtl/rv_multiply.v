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

   wire 	 sign_a = ( d_fun_i == `FUNC_MUL || d_fun_i == `FUNC_MULHSU ) ? d_rs1_i[31] : 1'b0;
   wire 	 sign_b = ( d_fun_i == `FUNC_MUL ) ? d_rs2_i[31] : 1'b0;
   
   wire [32:0] 	 a = { sign_a, d_rs1_i };
   wire [32:0] 	 b = { sign_b, d_rs2_i };

   reg [65:0] 	 stage0, stage1;

   reg [2:0] 	 s2_fun;

   always@(posedge clk_i)
     if(!x_stall_i)
       begin
	  stage0 <= $signed(a) * $signed(b);
	  s2_fun <= d_fun_i;
       end

   always@*
     if( s2_fun != `FUNC_MUL )
       w_rd_o <= stage0[63:32];
     else
       w_rd_o <= stage0[31:0];
   
   
endmodule // rv_multiply

   
   

