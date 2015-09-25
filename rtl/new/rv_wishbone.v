`include "rv_defs.v"

`timescale 1ns/1ps

module rv_core_wishbone
  (
   input 	     clk_i,
   input 	     cpu_rst_i,
   input 	     rst_i,

   // data Wishbone bus
   output reg 	     d_cyc_o,
   output reg 	     d_stb_o,
   output reg 	     d_we_o,
   output reg [3:0]  d_sel_o,
   output reg [31:0] d_adr_o,
   output reg [31:0] d_dat_o,
   input [31:0]      d_dat_i,
   input 	     d_stall_i,
   input 	     d_ack_i,

   // mem host access bus

   input 	     ha_cyc_i,
   input 	     ha_stb_i,
   input 	     ha_we_i,
   input [3:0] 	     ha_sel_i,
   input [31:0]      ha_adr_i,
   input [31:0]      ha_dat_i,
   output reg [31:0]     ha_dat_o,
   output reg 	     ha_ack_o,
   output 	     ha_stall_o
);

   parameter g_mem_size = 16384;
   parameter g_mem_addr_bits = 16;
   parameter g_address_space_bits = 18;
   parameter g_wishbone_start = 'h20000;

   reg [31:0]  mem[0:g_mem_size- 1];
   

   // instruction memory/host access wishbone port logic
   
   wire [31:0] 	  im_addr;
   reg [31:0] 	  im_data;
   reg 		  im_valid;

   reg [g_address_space_bits-1:0] ha_im_addr;
   reg [31:0]		  ha_im_wdata;
   reg [31:0]		  ha_im_rdata;
   reg 			  ha_im_access, ha_im_access_d;
   reg 			  ha_im_write;
   
   assign ha_stall_o = 0;

   // Host access to the CPU memory (through instruction port)
   always@(posedge clk_i or posedge rst_i)
     if(rst_i)
       begin
	  ha_im_access <= 0;
	  ha_im_access_d <= 0;
	  ha_im_write <= 0;
       end else begin
	  ha_im_access <= ha_cyc_i & ha_stb_i;
	  ha_im_access_d <= ha_im_access;

	  ha_im_write <=  ha_cyc_i & ha_stb_i & ha_we_i;
	  ha_im_wdata <= ha_dat_i;

	  if(ha_im_access_d) begin
	     ha_im_access <= 0;
	     ha_im_access_d <= 0;
	     ha_ack_o <= 1;
	     ha_dat_o <= ha_im_rdata;
	  end
       end // else: !if(rst_i)

   
   wire [g_address_space_bits-1: 0] im_addr_muxed  = (ha_im_access ? ha_im_addr : im_addr);
   

// Internal memory, instruction/host port
   always@(posedge clk_i)
     if(rst_i)
       im_valid <= 0;
     else begin
	if(ha_im_write)
	  mem[im_addr_muxed[g_mem_addr_bits-1:2] ] <= ha_im_wdata;

	im_data <= mem[im_addr_muxed[g_mem_addr_bits-1:2] ];
	im_valid <= !ha_im_access;
     end

   // data memory & Wishbone out

   wire [31:0] 	  dm_addr;
   wire [31:0] 	  dm_data_s;
   reg [31:0] 	  dm_data_l;
   wire [3:0] 	  dm_data_select;
   wire 	  dm_load;
   wire 	  dm_store;
   
   reg 		  dm_load_done;
   reg 		  dm_store_done;
   wire		  dm_ready = 1;
  
   reg 		  dm_cycle_in_progress;
   wire 	  dm_is_wishbone = (dm_addr >= g_wishbone_start);

   reg [31:0] 	  dm_mem_rdata;  
   reg [31:0] 	  dm_wb_rdata;
   reg 		  dm_wb_write;
   reg 		  dm_select_wb;
   
   
   
   always@(posedge clk_i)
     if(rst_i) begin
	d_cyc_o <= 0;
	dm_cycle_in_progress <= 0;
	dm_load_done <= 0;
	dm_store_done <= 0;
	dm_select_wb <= 0;
     end else begin
	
	
	if(!dm_cycle_in_progress) // access to internal memory
	  begin
	     if(!dm_is_wishbone) begin
		if(dm_store) begin
		   dm_load_done <= 0;
		   dm_store_done <= 1;
		   dm_select_wb <= 0;
		end else if (dm_load) begin

		   dm_load_done <= 1;
		   dm_store_done <= 0;
		   dm_select_wb <= 0;
		end else begin
		   dm_store_done <= 0; 
		   dm_load_done <= 0;
		   dm_select_wb <= 0;
		end
	     end else begin // if (!dm_is_wishbone)
		if(dm_load || dm_store) begin
		   d_cyc_o <= 1;
		   d_stb_o <= 1;
		   d_we_o <= dm_store;
		   dm_wb_write <= dm_store;
		   
		   d_adr_o <= dm_addr;
		   d_dat_o <= dm_data_s;
		   d_sel_o <= dm_data_select;
		   
		   
		   dm_load_done <= 0;
		   dm_store_done <= 0;
		   dm_cycle_in_progress <= 1;
		end else begin // if (dm_load || dm_store)
		   dm_store_done <= 0; 
		   dm_load_done <= 0;
		   dm_cycle_in_progress <= 0;
		end // else: !if(dm_load || dm_store)
	     end // else: !if(!dm_is_wishbone)
	  end else begin // if (!dm_cycle_in_progress)

		if(!d_stall_i)
		  d_stb_o <= 0;

		if(d_ack_i) begin
		   if(!dm_wb_write) begin
		      dm_wb_rdata <= d_dat_i;
		      dm_select_wb <= 1;
		      dm_load_done <= 1;
		   end else begin
		      dm_store_done <= 1;
		   end

		   dm_cycle_in_progress <= 0;
		   d_cyc_o <= 0;
		end // if (d_ack_i)
	     
		
	  end // else: !if(!dm_cycle_in_progress)
     end // else: !if(rst_i)

   always@*
     if(dm_select_wb)
       dm_data_l <= dm_wb_rdata;
     else
       dm_data_l <= dm_mem_rdata;

   // Internal memory, data port
   always@(posedge clk_i)
     begin

	if(!dm_is_wishbone) // access to local mem
	  begin
	     if(dm_store && dm_data_select[0])
	       mem [dm_addr[g_mem_addr_bits-1:2]][7:0] <= dm_data_s[7:0];
	     if(dm_store && dm_data_select[1])
	       mem [dm_addr[g_mem_addr_bits-1:2]][15:8] <= dm_data_s[15:8];
	     if(dm_store && dm_data_select[2])
	       mem [dm_addr[g_mem_addr_bits-1:2]][23:16] <= dm_data_s[23:16];
	     if(dm_store && dm_data_select[3])
	       mem [dm_addr[g_mem_addr_bits-1:2]][31:24] <= dm_data_s[31:24];
	  end // if (!d_is_wishbone)
	
	dm_mem_rdata <= mem [dm_addr[g_mem_addr_bits-1:2]];
	
     end // always@ (posedge clk)
   
   // The CPU!

   reg cpu_reset;
   
   always@(posedge clk_i)
     cpu_reset <= rst_i & cpu_rst_i;
   
   rv_cpu cpu_core
     (
      .clk_i(clk_i),
      .rst_i(rst_i),

      .im_addr_o(im_addr),
      .im_data_i(im_data),
      .im_valid_i(im_valid),

      .dm_addr_o(dm_addr),
      .dm_data_s_o(dm_data_s),
      .dm_data_l_i(dm_data_l),
      .dm_data_select_o(dm_data_select),
      .dm_ready_i(dm_ready),

      .dm_store_o(dm_store),
      .dm_load_o(dm_load),
      .dm_load_done_i(dm_load_done),
      .dm_store_done_i(dm_store_done) 
      );
 
endmodule
 

   
