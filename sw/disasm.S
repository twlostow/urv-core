
hello.elf:     file format elf32-littleriscv


Disassembly of section .boot:

00000000 <_start>:
   0:	00000197          	auipc	gp,0x0
   4:	07018193          	addi	gp,gp,112 # 70 <_gp>
   8:	00010117          	auipc	sp,0x10
   c:	ff410113          	addi	sp,sp,-12 # fffc <_fstack>
  10:	00000297          	auipc	t0,0x0
  14:	07828293          	addi	t0,t0,120 # 88 <_fbss>
  18:	00000317          	auipc	t1,0x0
  1c:	0b030313          	addi	t1,t1,176 # c8 <_ebss>
  20:	0002a023          	sw	zero,0(t0)
  24:	00428293          	addi	t0,t0,4
  28:	fe62ece3          	bltu	t0,t1,20 <_start+0x20>
  2c:	004000ef          	jal	30 <main>

Disassembly of section .text:

00000030 <main>:
  30:	fe010113          	addi	sp,sp,-32
  34:	00812e23          	sw	s0,28(sp)
  38:	02010413          	addi	s0,sp,32
  3c:	08002783          	lw	a5,128(zero)
  40:	fef42623          	sw	a5,-20(s0)
  44:	01c0006f          	j	60 <main+0x30>
  48:	08402703          	lw	a4,132(zero)
  4c:	fec42783          	lw	a5,-20(s0)
  50:	00178693          	addi	a3,a5,1
  54:	fed42623          	sw	a3,-20(s0)
  58:	0007c783          	lbu	a5,0(a5)
  5c:	00f72023          	sw	a5,0(a4)
  60:	fec42783          	lw	a5,-20(s0)
  64:	0007c783          	lbu	a5,0(a5)
  68:	fe0790e3          	bnez	a5,48 <main+0x18>
  6c:	0000006f          	j	6c <main+0x3c>

Disassembly of section .rodata:

00000070 <.rodata>:
  70:	6548                	add	a0,a0,s2
  72:	6c6c                	add	s8,s8,s11
  74:	77202c6f          	jal	s8,27e6 <_ebss+0x271e>
  78:	646c726f          	jal	tp,c76be <_fstack+0xb76c2>
	...

Disassembly of section .sdata:

00000080 <hello>:
  80:	0070                	li	zero,28
	...

00000084 <TX_REG>:
  84:	0000                	unimp
  86:	0010                	li	zero,4

Disassembly of section .bss:

00000088 <_fbss>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	lui	a6,0x8
   6:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
   a:	3520                	lui	a0,0xfffe8
   c:	312e                	beqz	a1,b4 <_fbss+0x2c>
   e:	302e                	beqz	a1,36 <main+0x6>
	...
