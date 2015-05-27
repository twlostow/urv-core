/*
`include "rv_defs.v"

`timescale 1ns/1ps

module rv_multiply 
  (
   input 	 clk_i,
   input 	 rst_i,
   input 	 x_stall_i,
   
   
   input [31:0]  x_rs1_i,
   input [31:0]  x_rs2_i,

   input [4:0] 	 x_opcode_i,
   input [2:0] 	 x_fun_i,

   output [31:0] x_rd_o,
   output 	 x_rd_valid_o, 

   output 	 x_stall_req_o
   );

   parameter g_latency = 2;

   wire 	 sign_a = ( x_fun_i == `FUNC_MUL || x_fun_i == `FUNC_MULHSU ) ? x_rs1_i[31] : 1'b0;
   wire 	 sign_b = ( x_fun_i == `FUNC_MUL ) ? x_rs2_i[31] : 1'b0;
   
   wire [32:0] 	 a = { sign_a, x_rs1_i };
   wire [32:0] 	 b = { sign_b, x_rs2_i };

   reg [65:0] 	 stage0;

   reg [3:0] 	 pipe;

   always@(posedge clk_i)
     if(rst_i)
       pipe <= 0;
     else if (x_opcode_i = `OPC_MUL )
       pipe <= (1<<g_latency);
     else
       pipe <= {1'b0, pipe [3:1]};
	 
      
         
   
   always@(posedge clk_i)
     begin
	stage0 <= $signed(a) * $signed(b);
	if( d_fun_i != `FUNC_MUL )
   	  x_rd_o <= stage0[63:32];
	else
	  x_rd_o <= stage0[31:0];
     end

   
	       
   
   
endmodule // rv_multiply

   
   
   
   
*/
