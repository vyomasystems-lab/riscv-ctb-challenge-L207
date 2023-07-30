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
  
  #-- proof of bug: ori executing as xori
  #  -- instruction auto generated in random test that failed:
  li s0, 0x409d701b
  ori s5, s0, 1781 #last 3 bytes: value 6F5 or with 01b should be 6FF. instead get 6EE (XOR).
  li s0, 0xFFFFFFFF
  ori s5, s0, 0
  li s0, 0x00000000
  ori s5, s0, 0
  li s0, 0xFFFFFFFF
  ori s5, s0, -1    # should result in FFFFFFFF, get 00000000
  li s0, 0x00000000
  ori s5, s0, -1
  li s0, 0xAAAAAAAA
  ori s5, s0, -1366 # sign extends, therefore should get FFFFFAAA (OR). instead get 55555000 (XOR)
  li s0, 0x55555555
  ori s5, s0, 1365 # no sign extend, should get 55555555 (OR), instead get 55555000 (XOR)
  li s0, 0x99999999
  ori s5, s0, -1639
  li s0, 0x66666666
  ori s5, s0, 1638
  #prove its not the specific registers, same fault still occurs
  li x2, 0x409d701b
  ori x3, x2, 1781 #last 3 bytes: value 6F5 or with 01b should be 6FF. instead get 6EE (XOR).

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
