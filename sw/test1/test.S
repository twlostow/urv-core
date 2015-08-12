  .section    .boot, "ax", @progbits

 .global _start
_start:


    la a5, lab1
    lw a5, 0(a5)
    lw a5, 0(a5)
    lw a5, 0(a5)

	nop
	nop
	nop

    forever:
	j forever    


lab1:
	.word lab2

lab2:
	.word lab3

lab3:
	.word 0xdeadbeef


/*	sw x5,-16(x1)


	nop
	nop

	lw x31, -16(x1)
	la x30, 0x1235
	beq x30, x31, pass1

fail1:
	nop
	j fail1

pass1:

	lw x20,-8(x1) // x20 = 0xffec
	lw x20,0(x20) // x20 = 0x1235
	addi x20,x20,1
	sw x20,-20(x1)	
*/

/*	
	slli t0, t0, 0x1
	sw t0,-4(sp)
	slli t0, t0, 0x1
	sw t0,-8(sp)

	la t0, 0xffffffa0
	srli t0, t0, 0x1
	sw t0,-4(sp)
	srli t0, t0, 0x1
	sw t0,-8(sp)
	
*/
