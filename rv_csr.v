module rv_csr
  
  (
   input 	     clk_i,
   input 	     rst_i,

   input 	     x_stall_i,

   input 	     d_csr_write_rd_i,
   
   input [31:0]      d_rs1_i,
   input [31:0]      d_pc_i, // for exception strage

   output reg [31:0] x_rd_o,
   output reg 	     x_rd_write_o,
   
   input 	     x_exception_i,
   input 	     x_exception_irq_i,
   input [2:0] 	     x_exception_id_i

   output [31:0]     x_exception_pc_o
   );
   
   reg [31:0] 	csr_mepc;
   reg [31:0] 	csr_mscratch;
   reg [31:0] 	csr_mcause;
   reg [31:0] 	csr_mstatus;
   
   wire 	csr_mie;
   
   assign x_exception_pc_o = csr_mepc;
   
   
   
   
   
