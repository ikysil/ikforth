PURPOSE: x86 TEST operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ TEST – Logical Compare

B# 10000100 CONSTANT ALUOP-TEST
B# 10101000 CONSTANT ALUOP-TEST-AI

ALUOP-TEST
ALU/RR8: TEST/RR8, (S reg1 reg2 -- )
\G Append operation TEST reg1, reg2 between two 8 bit registers

ALUOP-TEST
ALU/RR16: TEST/RR16, (S reg1 reg2 -- )
\G Append operation TEST reg1, reg2 between two 16 bit registers

ALUOP-TEST
ALU/RR32: TEST/RR32, (S reg1 reg2 -- )
\G Append operation TEST reg1, reg2 between two 32 bit registers


ALUOP-TEST-AI
ALU/AI8: TEST/AI8, (S imm8 -- )
\G Append operation TEST AL, imm8

ALUOP-TEST-AI
ALU/AI16: TEST/AI16, (S imm16 -- )
\G Append operation TEST AX, imm16

ALUOP-TEST-AI
ALU/AI32: TEST/AI32, (S imm32 -- )
\G Append operation TEST EAX, imm32


\ EOF

CR

use32 .( use32 TEST) cr

here dl dh TEST/RR8, 8 dump

here dx bx TEST/RR16, 8 dump

here edx ebx TEST/RR32, 8 dump

here h# 12345678 TEST/AI8, 8 dump
here h# 12345678 TEST/AI16, 8 dump
here h# 12345678 TEST/AI32, 8 dump

use16 .( use16 TEST) cr

here dl dh TEST/RR8, 8 dump

here dx bx TEST/RR16, 8 dump

here edx ebx TEST/RR32, 8 dump

here h# 12345678 TEST/AI8, 8 dump
here h# 12345678 TEST/AI16, 8 dump
here h# 12345678 TEST/AI32, 8 dump
