# See LICENSE for license details.

#*****************************************************************************
# csr.S
#-----------------------------------------------------------------------------
#
# Test CSRRx and CSRRxI instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64S
RVTEST_CODE_BEGIN

  csrwi mscratch, 3
  TEST_CASE( 2, a0,         3, csrr a0, mscratch);
  TEST_CASE( 3, a1,         3, csrrci a1, mscratch, 1);
  TEST_CASE( 4, a2,         2, csrrsi a2, mscratch, 4);
  TEST_CASE( 5, a3,         6, csrrwi a3, mscratch, 2);
  TEST_CASE( 6, a1,         2, li a0, 0xbad1dea; csrrw a1, mscratch, a0);
  TEST_CASE( 7, a0, 0xbad1dea, li a0, 0x0001dea; csrrc a0, mscratch, a0);
  TEST_CASE( 8, a0, 0xbad0000, li a0, 0x000beef; csrrs a0, mscratch, a0);
  TEST_CASE( 9, a0, 0xbadbeef, csrr a0, mscratch);

  j pass

    TEST_PASSFAIL
RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
