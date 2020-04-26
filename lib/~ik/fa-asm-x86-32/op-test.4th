PURPOSE: x86 TEST operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ TEST – Logical Compare

B# 10000100 CONSTANT ALUOP-TEST

ALUOP-TEST
ALURR8: TESTRR8, (S reg1 reg2 -- )
\G Append operation TEST reg1, reg2 between two 8 bit registers

ALUOP-TEST
ALURR16: TESTRR16, (S reg1 reg2 -- )
\G Append operation TEST reg1, reg2 between two 16 bit registers

ALUOP-TEST
ALURR32: TESTRR32, (S reg1 reg2 -- )
\G Append operation TEST reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 TEST) cr

here dl dh TESTRR8, 8 dump

here dx bx TESTRR16, 8 dump

here edx ebx TESTRR32, 8 dump

use16 .( use16 TEST) cr

here dl dh TESTRR8, 8 dump

here dx bx TESTRR16, 8 dump

here edx ebx TESTRR32, 8 dump
