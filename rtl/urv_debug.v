`timescale 1ns/1ps

`include "urv_defs.v"

module urv_debug
  (
   input 	 clk_i,
   input 	 rst_i,


   input 	 x_kill_i,
   input 	 x_stall_i,
   output 	 x_stall_req_o,
   output 	 d_kill_req_o,
   output 	 f_kill_req_o,
   output 	 halt_o,

   input 	 x_valid_i,
   input [31:0]  x_pc_i,
        
   input 	 x_dm_load_i,
   input 	 x_dm_store_i,
   input [31:0]  x_dm_addr_i,
   input [31:0]  x_dm_data_s_i,
   input [3:0] 	 x_dm_data_select_i,
   output [31:0] w_dm_data_l_o,
   output 	 w_dm_store_done_o,
   output 	 w_dm_load_done_o,
   output 	 x_dm_ready_o,


   output 	 dm_load_o,
   output 	 dm_store_o,
   output [31:0] dm_addr_o,
   output [31:0] dm_data_s_o,
   output [3:0]  dm_data_select_o,
   input [31:0]  dm_data_l_i,
   input 	 dm_store_done_i,
   input 	 dm_load_done_i,
   input 	 dm_ready_i,

   output [4:0]  rf_index_o,
   input [31:0]  rf_data_r_i
   output [31:0] rf_data_w_o,
   output 	 rf_write_o,

   output [31:0] f_pc_restore_o,
   output 	 f_pc_restore_load_o,
   
   input [6:0] 	 dbg_adr_i,
   input [7:0] 	 dbg_dat_i,
   input 	 dbg_stb_i,
   input 	 dbg_we_i,
   output [7:0]  dbg_dat_o,
   output 	 dbg_irq_o
   );

   parameter g_num_breakpoints = 4;

`define BREAK_SRC_PC 0
`define BREAK_SRC_MEM_ADDR 1
`define BREAK_SRC_MEM_ST_DATA 2
`define BREAK_SRC_MEM_LD_DATA 3

   
   reg [31:0] 	 break_compare_hi [0:g_num_breakpoints-1];
   reg [31:0] 	 break_compare_lo [0:g_num_breakpoints-1];

   reg [1:0] 	 break_src [0:g_num_breakpoints-1];
   reg 		 break_valid[0:g_num_breakpoints-1];
   
   reg [31:0] 	 in_muxed[0 : g_num_breakpoints-1];
   reg 		 in_valid[0:g_num_breakpoints-1]; 
   reg 		 break_hit[0: g_num_breakpoints-1];  

`define ST_IDLE 0

   generate
      genvar  gg;
      
      for (gg = 0; gg < g_num_breakpoints; gg = gg + 1)
	begin
	   always@*

	     case (break_src[gg])
	       `BREAK_SRC_PC: in_muxed[gg] <= x_pc_i;
	       `BREAK_SRC_MEM_ADDR: in_muxed[gg] <= x_dm_addr_i;
	       `BREAK_SRC_MEM_ST_DATA:  in_muxed[gg] <= x_dm_data_s_i;
	       `BREAK_SRC_MEM_ST_DATA:  in_muxed[gg] <= dm_data_l_i;
	     endcase // case (break_src[gg])

	   case (break_src[gg])
	     `BREAK_SRC_PC: 
	       begin
		  in_muxed[gg] <= x_pc_i; 
		  in_valid[gg] <= x_valid_i;
	       end
	     
	     `BREAK_SRC_MEM_ADDR:
	       begin
		  in_muxed[gg] <= x_dm_addr_i;
		  in_valid[gg] <= x_dm_load_i || x_dm_store_i;
	       end
	     
	     `BREAK_SRC_MEM_ST_DATA:  
	       begin
		  in_muxed[gg] <= x_dm_data_s_i;
		  in_valid[gg] <= x_dm_store_i;
	       end
	     
	     `BREAK_SRC_MEM_LD_DATA: 
	       begin
		  in_muxed[gg] <= dm_data_l_i;
		  in_valid[gg] <= dm_load_done_i;
	       end
	     
	   endcase // case (break_src[gg])

	   break_hit[gg] <= ( in_muxed[gg] >= break_comp1[gg] && in_muxed[gg] <= break_comp[gg] ) ? in_valid[gg] : 1'b0;

	end

   endgenerate

   reg trigger_reload_pc;
   reg trigger_halt;
   reg trigger_resume;
   
   reg [31:0] reload_pc_value;

`define DBG_REG_PC0 0
`define DBG_REG_PC1 1
`define DBG_REG_PC2 2
`define DBG_REG_PC3 3
   

   always@(posedge clk_i)
     if(rst_i) begin
	reload_pc <= 0;
     end else begin

	trigger_halt <= 0;
	trigger_resume <= 0;
	trigger_reload_pc <= 0;
	
	if ( dbg_we_i ) begin
	   case (dbg_adr_i)
	     `DBG_REG_PCO: reload_pc_value[7:0] <= dbg_dat_i;
	     `DBG_REG_PC1: reload_pc_value[15:8] <= dbg_dat_i;
	     `DBG_REG_PC2: reload_pc_value[23:16] <= dbg_dat_i;
	     `DBG_REG_PC3: reload_pc_value[31:24] <= dbg_dat_i;
	     `DBG_CTL: 
	       begin 
		  trigger_halt <= dbg_dat_i[0];
		  trigger_resume <= dbg_dat_i[1];
		  trigger_reload_pc <= dbg_dat_i[2];
	       end
	     
	     
	     
	     
	   endcase // case (dbg_adr_i)
	   

	end else begin // if ( dbg_we_i )
	   case (dbg_adr_i)
	     `DBG_REG_PCO: dbg_dat_o <= x_pc_i[7:0];
	     `DBG_REG_PC1: dbg_dat_o <= x_pc_i[15:8];
	     `DBG_REG_PC2: dbg_dat_o <= x_pc_i[23:16];
	     `DBG_REG_PC3: dbg_dat_o <= x_pc_i[31:24];
	   end // else: !if( dbg_we_i )
	

	end // else: !if( dbg_we_i )
	
	
	

     end
   
       
	

   

   
   
   
end

   
