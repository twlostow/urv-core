// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#include "../encoding.h"
#include "../hwacha_xcpt.h"

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV64UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV64UV                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  RVTEST_VEC_ENABLE;                                                    \
  .endm

#define RVTEST_RV32U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV32UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV32UV                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  RVTEST_VEC_ENABLE;                                                    \
  .endm

#define RVTEST_RV64M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV64S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_RV64SV                                                   \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  RVTEST_VEC_ENABLE;                                                    \
  .endm

#define RVTEST_RV32M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#ifdef __riscv64
# define CHECK_XLEN csrr a0, mcpuid; bltz a0, 1f; RVTEST_PASS; 1:
#else
# define CHECK_XLEN csrr a0, mcpuid; bgez a0, 1f; RVTEST_PASS; 1:
#endif

#define RVTEST_ENABLE_SUPERVISOR                                        \
  li a0, MSTATUS_PRV1 & (MSTATUS_PRV1 >> 1);                            \
  csrs mstatus, a0;                                                     \

#define RVTEST_ENABLE_MACHINE                                           \
  li a0, MSTATUS_PRV1;                                                  \
  csrs mstatus, a0;                                                     \

#define RVTEST_FP_ENABLE                                                \
  li a0, MSTATUS_FS & (MSTATUS_FS >> 1);                                \
  csrs mstatus, a0;                                                     \
  csrwi fcsr, 0

#define RVTEST_VEC_ENABLE                                               \
  li a0, SSTATUS_XS & (SSTATUS_XS >> 1);                                \
  csrs sstatus, a0;                                                     \

#define RISCV_MULTICORE_DISABLE                                         \
  csrr a0, mhartid;                                                     \
  1: bnez a0, 1b

#define EXTRA_TVEC_USER
#define EXTRA_TVEC_SUPERVISOR
#define EXTRA_TVEC_HYPERVISOR
#define EXTRA_TVEC_MACHINE
#define EXTRA_INIT
#define EXTRA_INIT_TIMER

#define RVTEST_CODE_BEGIN                                               \
	.text;\
	.global main;	\
	main:	\

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \
ecall:  ecall;                                                          \
        j ecall

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define TESTNUM x28

#define RVTEST_PASS                                                     \
	la sp, _fstack;  la gp, _gp; jal rv_test_pass; \
	la t0, 0x100004; sw t0, 0(t0); j ecall;

#define RVTEST_FAIL                                                     \
        la sp, _fstack; la gp, _gp; mv a0, TESTNUM; jal rv_test_fail;\
	la t0, 0x100004; sw t0, 0(t0); j ecall;

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA

#define RVTEST_DATA_BEGIN EXTRA_DATA .align 4; .global begin_signature; begin_signature:
#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#endif
