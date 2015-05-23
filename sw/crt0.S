  .section    .boot, "ax", @progbits

 .global _start
_start:
        la      gp, _gp                 # Initialize global pointer
	la      sp, _fstack

# clear the bss segment
	la	t0, _fbss
	la	t1, _end
1:
#ifdef __riscv64
	sd	zero,0(t0)
	addi	t0, t0, 8
#else
	sw	zero,0(t0)
	addi	t0, t0, 4
#endif
	bltu	t0, t1, 1b

        call    main