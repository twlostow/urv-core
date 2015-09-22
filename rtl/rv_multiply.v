`include "rv_defs.v"

`timescale 1ns/1ps

`define ARCH_VIRTEX6

   `ifdef ARCH_SPARTAN6

module rv_mult18x18
  (
   input 	 clk_i,
   input 	 rst_i,
   
   input 	 stall_i,
   
   input [17:0]  x_i,
   input [17:0]  y_i,

   output [35:0] q_o
   );

   DSP48A1 #(
	.A0REG(0),
	.A1REG(0),
	.B0REG(0),
	.B1REG(0),
	.CARRYINREG(0),
	.CARRYINSEL("OPMODE5"),
	.CARRYOUTREG(0),
	.CREG(0),
	.DREG(0),
	.MREG(1),
	.OPMODEREG(0),
	.PREG(0),
	.RSTTYPE("SYNC")
) D1 (
	.BCOUT(),
	.PCOUT(),
	.CARRYOUT(),
	.CARRYOUTF(),
	.M(q_o),
	.P(),
	.PCIN(),
	.CLK(clk_i),
	.OPMODE(8'd1),
	.A(x_i),
	.B(y_i),
	.C(48'h0),
	.CARRYIN(),
	.D(18'b0),
	.CEA(1'b0),
	.CEB(1'b0),
	.CEC(1'b0),
	.CECARRYIN(1'b0),
	.CED(1'b0),
	.CEM(~stall_i),
	.CEOPMODE(1'b0),
	.CEP(1'b1),
	.RSTA(rst_i),
	.RSTB(rst_i),
	.RSTC(1'b0),
	.RSTCARRYIN(1'b0),
	.RSTD(1'b0),
	.RSTM(rst_i),
	.RSTOPMODE(1'b0),
	.RSTP(1'b0)
);

endmodule // rv_mult18x18
   `endif //  `i
// fdef ARCH_SPARTAN6

`ifdef ARCH_VIRTEX6
module rv_mult18x18
  (
   input 	 clk_i,
   input 	 rst_i,
   
   input 	 stall_i,
   
   input [17:0]  x_i,
   input [17:0]  y_i,

   output reg [35:0] q_o
   );


   always@(posedge clk_i)
     if(!stall_i)
       q_o <= x_i * y_i;
   
endmodule // rv_mult18x18
`endif //  `ifdef ARCH_VIRTEX6



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




   wire[17:0] xl_u = {1'b0, d_rs1_i[16:0] };
   wire[17:0] yl_u = {1'b0, d_rs2_i[16:0] };

   wire[17:0] xl_s = {d_rs1_i[16], d_rs1_i[16:0] };
   wire[17:0] yl_s = {d_rs2_i[16], d_rs2_i[16:0] };

   wire[17:0] xh = { {3{d_rs1_i[31]}}, d_rs1_i[31:17] };
   wire[17:0] yh = { {3{d_rs2_i[31]}}, d_rs2_i[31:17] };

   wire [35:0] 	     yl_xl, yl_xh, yh_xl;
   
   rv_mult18x18 U_mul0 
     (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .stall_i(x_stall_i),

      .x_i(xl_u),
      .y_i(yl_u),
      .q_o(yl_xl)
      );

      rv_mult18x18 U_mul1
     (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .stall_i(x_stall_i),

      .x_i(xl_s),
      .y_i(yh),
      .q_o(yh_xl)
      );

      rv_mult18x18 U_mul2
     (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .stall_i(x_stall_i),

      .x_i(yl_s),
      .y_i(xh),
      .q_o(yl_xh)
      );
   
   
/* -----\/----- EXCLUDED -----\/-----
   
		 
   always@(posedge clk_i)
     if(!x_stall_i)
       begin
	  yh_xl <= $signed(yh) * $signed(xl);
	  yl_xh <= $signed(yl) * $signed(xh);
	  yl_xl <= $unsigned(yl) * $unsigned(xl);
       end
   

//       stage0 <= $signed(d_rs1_i) * $signed(d_rs2_i);

 */
   always@*
     w_rd_o <= yl_xl + {yl_xh[14:0], 17'h0} + {yh_xl[14:0], 17'h0};
 
   
   
endmodule // rv_multiply

   
   

