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

`define OPC_OP_IMM 5'b00100
`define OPC_LUI 5'b01101
`define OPC_AUIPC 5'b00101
`define OPC_OP 5'b01100
`define OPC_JAL 5'b11011
`define OPC_JALR 5'b11001
`define OPC_BRANCH 5'b11000
`define OPC_LOAD 5'b00000
`define OPC_STORE 5'b01000
`define OPC_SYSTEM 5'b11100
`define OPC_MULDIV 5'b

`define BRA_EQ 3'b000
`define BRA_NEQ  3'b001
`define BRA_LT 3'b100
`define BRA_GE 3'b101
`define BRA_LTU 3'b110
`define BRA_GEU 3'b111

`define LDST_B 3'b000
`define LDST_H 3'b001
`define LDST_L 3'b010
`define	LDST_BU 3'b100
`define LDST_HU 3'b101

`define FUNC_ADD 3'b000
`define FUNC_SLT 3'b010
`define FUNC_SLTU 3'b011
`define FUNC_XOR 3'b100
`define FUNC_OR 3'b110
`define FUNC_AND 3'b111
`define FUNC_SL 3'b001
`define FUNC_SR 3'b101

`define FUNC_MUL 3'b000
`define FUNC_MULH 3'b001
`define FUNC_MULHSU 3'b010
`define FUNC_MULHU 3'b011

`define FUNC_DIV 3'b100
`define FUNC_DIVU 3'b101
`define FUNC_REM 3'b110
`define FUNC_REMU 3'b111

`define RD_SOURCE_ALU 3'b000 
`define RD_SOURCE_SHIFTER 3'b010
`define RD_SOURCE_MULTIPLY 3'b001
`define RD_SOURCE_DIVIDE 3'b011
`define RD_SOURCE_CSR 3'b011

`define CSR_ID_CYCLESH 12'hc80
`define CSR_ID_CYCLESL 12'hc00 
`define CSR_ID_TIMEH 12'hc81
`define CSR_ID_TIMEL 12'hc01 
`define CSR_ID_MSCRATCH 12'h340
`define CSR_ID_MEPC 12'h341
`define CSR_ID_MSTATUS 12'h300
`define CSR_ID_MCAUSE 12'h342
`define CSR_ID_MIP 12'h344
`define CSR_ID_MIE 12'h304

`define CSR_OP_CSRRW 3'b001
`define CSR_OP_CSRRS 3'b010
`define CSR_OP_CSRRC 3'b011
`define CSR_OP_CSRRWI 3'b101
`define CSR_OP_CSRRSI 3'b110
`define CSR_OP_CSRRCI 3'b111

`define URV_RESET_VECTOR 32'h00000000
`define URV_TRAP_VECTOR 32'h00000040

`define EXCEPT_ILLEGAL_INSN 2
`define EXCEPT_BREAKPOINT 3
`define EXCEPT_UNALIGNED_LOAD 4
`define EXCEPT_UNALIGNED_STORE 6
`define EXCEPT_TIMER 9
`define EXCEPT_IRQ 10

`define OP_SEL_BYPASS_X 0
`define OP_SEL_BYPASS_W 1
`define OP_SEL_DIRECT 2
`define OP_SEL_IMM 3
