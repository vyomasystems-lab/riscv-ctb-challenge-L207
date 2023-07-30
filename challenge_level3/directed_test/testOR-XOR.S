# See LICENSE for license details.

#*****************************************************************************
# add.S
#-----------------------------------------------------------------------------
#
# Test add instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  #TEST_RR_OP( 2,  add, 0x00000001, 0x00000001, 0x00000000 );

	#.text
	#.align		2
  #.option norvc
  
  #-- proof of bug: OR executing as XOR
  #  -- instruction auto generated in random test that failed:
  li s0, 0xFFFFFFFF
  li s1, 0xFFFFFFFF
  or s2, s0, s1
  li s1, 0xFF55AA00
  or s2, s0, s1

  #was having problems with test closing, RVTEST_PASS call directly ends test
  #using this file currently to prove out specific bugs
  RVTEST_PASS
  #TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN
test_data_addr:

.word 0x00000000
.word 0x00000001
.word 0x00000002
.word 0x00000003
.word 0x00000004
.word 0x00000005
.word 0x00000006
.word 0x00000007
.word 0x00000008
.word 0x00000009
  #TEST_DATA

RVTEST_DATA_END
