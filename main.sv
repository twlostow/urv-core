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

   const int dump_insns = 1;
   const int dump_mem_accesses = 1;
 
   
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


   
   initial begin
      load_ram("sw/test2/test2.ram");
      repeat(3) @(posedge clk);
      rst = 0;
   end

   function string decode_op(bit[2:0] fun);
      
     case(fun)
       `FUNC_ADD: return "add";
       `FUNC_XOR:return "xor";
       `FUNC_OR: return "or";
       `FUNC_AND:return "and";
       `FUNC_SLT:return "slt";
       `FUNC_SLTU:return "sltu";
       `FUNC_SL: return "sl";
       `FUNC_SR:return"sr";
     endcase // case (fun)
   endfunction // decode_op

      function string decode_cond(bit[2:0] fun);
      
     case(fun)
       `BRA_EQ: return "eq";
       `BRA_NEQ: return "neq";
       `BRA_LT: return "lt";
       `BRA_GE: return "ge";
       `BRA_LTU:return "ltu";
       `BRA_GEU:return "geu";
     endcase // case (fun)
   endfunction // decode_op

         function string decode_size(bit[2:0] fun);
      
     case(fun)
       `LDST_B: return "s8";
       `LDST_BU: return "u8";
       `LDST_H: return "s16";
       `LDST_HU: return "u16";
       `LDST_L:return "32";
     endcase // case (fun)
   endfunction // decode_op

   function string decode_regname(bit[4:0] r);
      case(r)
	0: return "zero";
	1: return "ra";
	2: return "sp";
	3: return "gp";
	4: return "tp";
	5: return "t0";
	6: return "t1";
	7: return "t2";
	8: return "s0";
	9: return "s1";
	10: return "a0";
	11: return "a1";
	12: return "a2";
	13: return "a3";
	14: return "a4";
	15: return "a5";
	16: return "a6";
	17: return "a7";
	18: return "s2";
	19: return "s3";
	20: return "s4";
	21: return "s5";
	22: return "s6";
	23: return "s7";
	24: return "s8";
	25: return "s9";
	26: return "s10";
	27: return "s11";
	28: return "t3";
	29: return "t4";
	30: return "t5";
	31: return "t6";
      endcase // case (fun)
   endfunction // decode_regname
   

   function automatic string s_hex(int x);
      return $sformatf("%s0x%-08x", x<0?"-":" ", (x<0)?(-x):x);
   endfunction // s_hex

   reg[31:0] dm_addr_d0;
   

   always@(posedge clk)
     begin
	if(dump_mem_accesses)
	  begin
	dm_addr_d0 <= dm_addr;
	
	if(dm_write)
	  $display("DM Write addr %x data %x", dm_addr, dm_data_s);
	if (DUT.writeback.x_load_i && DUT.writeback.rf_rd_write_o)
	  begin
/* -----\/----- EXCLUDED -----\/-----
	     if ($isunknown(dm_data_l))
	       begin
		  $error("Attempt to load uninitialized entry from memory");
		  $stop;
	       end
 -----/\----- EXCLUDED -----/\----- */
	     

     $display("DM Load addr %x data %x -> %s", dm_addr_d0, DUT.writeback.rf_rd_value_o, decode_regname(DUT.writeback.x_rd_i));
	  end
	end
     end
   
   integer f_console;
   
   initial begin
      f_console = $fopen("console.txt","wb");
      #500us;

//      $fclose(f_console);
     

   end
   
   
   always@(posedge clk)
     if(dm_write && dm_addr == 'h100000)
       begin
	  $display("\n ****** TX '%c' \n", dm_data_s[7:0]) ;
//	  byte x = dm_data_s[7:0];
	  $fwrite(f_console,"%c", dm_data_s[7:0]);
	  $fflush(f_console);
	  
       end
   
   

   
   always@(posedge clk)
   
     if(dump_insns && DUT.execute.d_valid_i && !DUT.execute.x_stall_i && !DUT.execute.x_kill_i)
       begin
	  automatic string opc="<unk>", fun="", args="";

	  automatic string rs1 = decode_regname(DUT.d2x_rs1);
	  automatic string rs2 = decode_regname(DUT.d2x_rs2);
	  automatic string rd = decode_regname(DUT.d2x_rd);

	  
	  
	  reg [31:0] imm;
	  
	  //	  $display("Opcode %x", DUT.d2x_opcode);
	  
	  case (DUT.d2x_opcode)
	    `OPC_AUIPC: 
	      begin 
		 opc = "auipc"; 
		 fun = ""; 
		 args =		 $sformatf("%-3s %-3s %s", rd, " ", s_hex(DUT.d2x_imm)); 
		 
	      end

	    `OPC_LUI: 
	      begin 
		 opc = "lui"; 
		 fun = ""; 
		 args =		 $sformatf("%-3s %-3s %s", rd, " ", s_hex(DUT.d2x_imm)); 
		 
	      end
	    
	    `OPC_OP_IMM: 
	      begin 
		 opc = "op-imm";
		 fun = decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s %-3s %s", rd, rs1, s_hex(DUT.d2x_imm));
	      end

	    `OPC_OP: 
	      begin 
		 opc = "op-imm";
		 fun = decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s %-3s %-3s", rd, rs1, rs2);
	      end

	    `OPC_JAL: 
	      begin 
		 opc = "jal";
		 fun = "";
//decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s      0x%-08x", rd, DUT.execute.branch_target);
	      end
	    `OPC_JALR: 
	      begin 
		 opc = "jalr";
		 fun = "";
//decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s %-3s 0x%-08x", rd, rs1, DUT.execute.branch_target);
	      end
	    `OPC_BRANCH: 
	      begin 
		 opc = "branch";
		 fun = decode_cond(DUT.d2x_fun);
//decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s %-3s 0x%-08x %s", rs1, rs2, DUT.execute.branch_target, DUT.execute.branch_take?"TAKE":"IGNORE");
	      end
	    `OPC_LOAD: 
	      begin 
		 opc = "ld";
		 fun = decode_size(DUT.d2x_fun);
//decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s %-3s [0x%-08x + %s]", rd, rs1, DUT.execute.rs1, s_hex($signed(DUT.execute.d_imm_i)));
	      end
	    `OPC_STORE: 
	      begin 
		 opc = "st";
		 fun = decode_size(DUT.d2x_fun);
//decode_op(DUT.d2x_fun);
		 args = $sformatf("%-3s %-3s [0x%-08x + %s]", rs2, rs1, DUT.execute.rs1, s_hex($signed(DUT.execute.d_imm_i)));
	      end

	  endcase // case (d2x_opcode)

	  $display("%08x: %-8s %-3s %s", DUT.execute.d_pc_i, opc, fun, args);
	  
	  
	  
	  
       end
 
endmodule // main
