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

module main;

   
   reg clk = 0;
   reg rst = 1;
   
   wire [31:0] im_addr;
   reg [31:0] im_data;
   reg        im_valid;
   

   wire [31:0] dm_addr;
   wire [31:0] dm_data_s;
   reg [31:0] dm_data_l;
   wire [3:0]  dm_data_select;
   wire        dm_write;
   reg 	       dm_valid_l = 1;
   reg        dm_ready;
   
   localparam int mem_size = 16384;
   
   reg [31:0]  mem[0:mem_size - 1];

   task automatic load_ram(string filename);
      int f = $fopen(filename,"r");
      int     n, i;

      while(!$feof(f))
        begin
           int addr, data;
           string cmd;
           
           $fscanf(f,"%s %08x %08x", cmd,addr,data);
           if(cmd == "write")
             begin
                mem[addr % mem_size] = data;
             end
        end
      
   endtask // load_ram

   int seed;


   
   always@(posedge clk)
     begin
	if(   $dist_uniform(seed, 0, 100 ) <= 100) begin
	   im_data <= mem[(im_addr / 4) % mem_size];
	   im_valid <= 1;
	end else
	   im_valid <= 0;
	
	

	if(dm_write && dm_data_select[0])
	  mem [(dm_addr / 4) % mem_size][7:0] <= dm_data_s[7:0];
	if(dm_write && dm_data_select[1])
	  mem [(dm_addr / 4) % mem_size][15:8] <= dm_data_s[15:8];
	if(dm_write && dm_data_select[2])
	  mem [(dm_addr / 4) % mem_size][23:16] <= dm_data_s[23:16];
	if(dm_write && dm_data_select[3])
	  mem [(dm_addr / 4) % mem_size][31:24] <= dm_data_s[31:24];
	

	
	
//	dm_data_l <= mem[(dm_addr/4) % mem_size];
	
	
     end // always@ (posedge clk)


   
   always@(posedge clk)
     begin
	dm_ready <= 1'b1; // $dist_uniform(seed, 0, 100 ) <= 50;

	dm_data_l <= mem[(dm_addr/4) % mem_size];
   end	   

   rv_cpu DUT
     (
      .clk_i(clk),
      .rst_i(rst),

      .irq_i ( irq ),
      
      // instruction mem I/F
      .im_addr_o(im_addr),
      .im_data_i(im_data),
      .im_valid_i(im_valid),

      // data mem I/F
      .dm_addr_o(dm_addr),
      .dm_data_s_o(dm_data_s),
      .dm_data_l_i(dm_data_l),
      .dm_data_select_o(dm_data_select),
      .dm_store_o(dm_write),
      .dm_load_o(),
      .dm_store_done_i(1'b1),
      .dm_load_done_i(1'b1),
      .dm_ready_i(dm_ready)
      );
   

   always #5ns clk <= ~clk;

   integer f_console, f_exec_log;
   reg 	   test_complete = 0;
   
   initial begin
      string tests[$];
      string test_dir = "../../sw/testsuite/isa";
      
      
      int f = $fopen( {test_dir,"/tests.lst"} ,"r");
      int     n, i;

      f_console = $fopen("console.txt","wb");

      while(!$feof(f))
        begin
           string fname;
           
           $fscanf(f,"%s", fname);
	   tests.push_back(fname);
	   
	   
        end


      for (i=0;i<tests.size();i++)
	begin
	   rst = 1;
	   repeat(3) @(posedge clk);
	   $display("Loading %s", {test_dir,"/",tests[i]} );
	   load_ram({test_dir,"/",tests[i]});
	   repeat(3) @(posedge clk);
	   rst = 0;
	   test_complete=  0;
	   
	   while(!test_complete)
	     #1us;
	   
	   
	end
      end // initial begin
		    

   
   always@(posedge clk)
     if(dm_write)
       begin
	  if(dm_addr == 'h100000)
	    begin
	      // $display("\n ****** TX '%c' \n", dm_data_s[7:0]) ;
	       //	  $fwrite(f_exec_log,"\n ****** TX '%c' \n", dm_data_s[7:0]) ;
	       $write("%c", dm_data_s[7:0]);
	       $fwrite(f_console,"%c", dm_data_s[7:0]);
	       $fflush(f_console);
	    end
	  else if(dm_addr == 'h100004)
	    begin
//	       $display("Test complete." );
	       test_complete = 1;
	    end
       end
 
endmodule // main
