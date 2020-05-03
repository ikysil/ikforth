PURPOSE: x86 AND operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ AND – Logical AND

B# 00100000 CONSTANT ALUOP-AND
B# 00100100 CONSTANT ALUOP-AND-AI

ALUOP-AND ALUOP->
ALU/RR8: AND/RR8->, (S reg1 reg2 -- )
\G Append operation AND reg2, reg1 between two 8 bit registers

ALUOP-AND ALUOP<-
ALU/RR8: AND/RR8<-, (S reg1 reg2 -- )
\G Append operation AND reg1, reg2 between two 8 bit registers

ALUOP-AND ALUOP->
ALU/RR16: AND/RR16->, (S reg1 reg2 -- )
\G Append operation AND reg2, reg1 between two 16 bit registers

ALUOP-AND ALUOP<-
ALU/RR16: AND/RR16<-, (S reg1 reg2 -- )
\G Append operation AND reg1, reg2 between two 16 bit registers

ALUOP-AND ALUOP->
ALU/RR32: AND/RR32->, (S reg1 reg2 -- )
\G Append operation AND reg2, reg1 between two 32 bit registers

ALUOP-AND ALUOP<-
ALU/RR32: AND/RR32<-, (S reg1 reg2 -- )
\G Append operation AND reg1, reg2 between two 32 bit registers

ALUOP-AND-AI
ALU/AI8: AND/AI8<-, (S imm8 -- )
\G Append operation AND AL, imm8

ALUOP-AND-AI
ALU/AI16: AND/AI16<-, (S imm16 -- )
\G Append operation AND AX, imm16

ALUOP-AND-AI
ALU/AI32: AND/AI32<-, (S imm32 -- )
\G Append operation AND EAX, imm32


\ EOF

CR

use32 .( use32 AND) cr

here dl dh AND/RR8->, 8 dump
here dl dh AND/RR8<-, 8 dump

here dx bx AND/RR16->, 8 dump
here dx bx AND/RR16<-, 8 dump

here edx ebx AND/RR32->, 8 dump
here edx ebx AND/RR32<-, 8 dump

here h# 12345678 AND/AI8<-, 8 dump
here h# 12345678 AND/AI16<-, 8 dump
here h# 12345678 AND/AI32<-, 8 dump

use16 .( use16 AND) cr

here dl dh AND/RR8->, 8 dump
here dl dh AND/RR8<-, 8 dump

here dx bx AND/RR16->, 8 dump
here dx bx AND/RR16<-, 8 dump

here edx ebx AND/RR32->, 8 dump
here edx ebx AND/RR32<-, 8 dump

here h# 12345678 AND/AI8<-, 8 dump
here h# 12345678 AND/AI16<-, 8 dump
here h# 12345678 AND/AI32<-, 8 dump
