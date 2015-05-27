  .section    .boot, "ax", @progbits

 .global _start
_start:

	
	la      x1, 1234
	j lab2
	sll x1, x1, 1
	nop
	addi x1,x1,1
lab2:


	nop
	nop
	nop

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
	nop
	nop
forever:
	j forever
/*
# clear the bss segment
#	la	t0, _fbss
#	la	t1, _end
#1:
##ifdef __riscv64
#	sd	zero,0(t0)
#	addi	t0, t0, 8
#else
#	sw	zero,0(t0)
#	addi	t0, t0, 4
#endif
#	bltu	t0, t1, 1b

#        call    main*/