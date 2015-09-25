/*

 uRV - a tiny and dumb RISC-V core
 Copyright (c) 2015 CERN
 Author: Tomasz Włostowski <tomasz.wlostowski@cern.ch>

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

`include "urv_defs.v"

`timescale 1ns/1ps

module urv_timer
  (
   input 	 clk_i,
   input 	 rst_i,

   output [39:0] csr_time_o,
   output [39:0] csr_cycles_o,
  
   output 	 sys_tick_o
   );

   parameter g_timer_frequency = 1000;
   parameter g_clock_frequency = 62500000;

   localparam g_prescaler = (g_clock_frequency / g_timer_frequency ) - 1;
   
   reg [23:0] 	 presc;
   reg 		 presc_tick;
   
   reg [39:0] 	 cycles;
   reg [39:0] 	 ticks;
   
   always@(posedge clk_i)
     if(rst_i)
       begin
	  presc <= 0;
	  presc_tick <= 0;
       end else begin
	  if(presc == g_prescaler) begin
	     presc <= 0;
	     presc_tick <= 1;
	  end else begin
	     presc_tick <= 0;
	     presc <= presc + 1;
	  end // else: !if(rst_i)
       end // else: !if(rst_i)

   always @(posedge clk_i)
     if (rst_i)
       ticks <= 0;
     else if (presc_tick)
       ticks <= ticks + 1;
   
   always @(posedge clk_i)
     if (rst_i)
       cycles <= 0;
     else
       cycles <= cycles + 1;
   
   
   assign csr_time_o = ticks;
   assign csr_cycles_o = cycles;
   assign sys_tick_o = presc_tick;
   
endmodule // urv_timer
