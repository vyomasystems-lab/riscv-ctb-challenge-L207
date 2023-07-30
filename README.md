# riscv_ctb_challenges

# challenge_level1/challenge1_logical

line 15855
register z4 does not exist so assuming register s4 intended.

line 25584
"andi" instruction does not match the syntax used (add). Assume "and" is correct in test context.

with these changes applied runs successfully.

# challenge_level1/challenge2_loop

line 14 defines number of test cases but this is not used by the loop to exit.

added new line at start of "loop:"
beq t5, zero, test_end

add new line above previous line 23 (original beq instruction for loop):
addi t5, t5, -1

with these changes applied runs successfully.

# challenge_level1/challenge3_illegal

function of mret and mepc is that the return is to the same address the exception was taken. mtval handler therefore needed to be modified to change mepc return address.

it was noted that if the behaviour is to return to the same address, then the j fail below the illegal instruction is clearly there to catch a bad return that is PC+4. therefore the test count has been used to detect the first entry and NOT modify the MEPC value, and modify on the second entry to add 8 so as to skip the j fail instruction and complete the test instead.

Due to the way this was implemented the TESTNUM needed to be changed from 2 to 3 to prevent a false entry into the fail routine on test complete.

# challenge_level2/challenge1_instructions

line 66 change from rel_rv64m: 10 to rel_rev64m: 0 as test should include rv32i only. test runs successfully after change.

# challenge_level2/challenge2_exceptions

applied some exception tests but had issues with locking up of test harness. Skipped this task in interests of available time.

# challenge_level3

used provided RV32I RTL model. focused on using the AAPG random test generator to detect events, then look for the instructions that triggered the event and recreate using direct test.

random_test/Makefile and directed_test/Makefile both needed modifications using information copied from each other to fix the Spike: section as neither functioned correctly.

--BUG1:

ORI is executing as XORI instruction. Tested a number of diffrent input values to confirm. e.g.

    li s0, 0x409d701b
    ori s5, s0, 1781 
        1781 (6F5) or with last 3 bytes of s0 (01b) should be 6FF. instead get 6EE (XOR).

see file testORI-XORI.S for proof test.

--BUG2:

OR is executing as XOR instruction. found and tested in similar way to ORI bug. e.g.

  li s0, 0xFFFFFFFF
  li s1, 0xFF55AA00
  or s2, s0, s1 
    result should be FFFFFFFF instead get 00AA55FF, proving XOR output.

see file testOR-XOR.S for proof test.

--BUG3:

Load Word is occasionally failing to load the correct value, but this does not always seem to be consistent. suspect this is an issue with caching.

--BUG4 (may not be a bug, SPIKE/RTL implementation difference):

CSRRC instruction on mhpmcounter CSRs causes an exception on RTL model, does not cause exceptoin on SPIKE. However, RISCV spec allows this register to be READ-ONLY 0, so an attempt to clear (write) would be an acceptable cause for an exception. observed difference between SPIKE and the RTL model therefore, but is not neccesarily out of spec.

--BUG5 (may not be a bug, SPIKE/RTL implementation difference):

Initial value of PMPADDR register varies between SPIKE and RTL models. However there does not appear to be a definition in the RISCV specification for initial value.

















