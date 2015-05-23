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

`define BRA_EQ 3'b000
`define BRA_NEQ  3'b001
`define BRA_LT 3'b100
`define BRA_GE 3'b100
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

