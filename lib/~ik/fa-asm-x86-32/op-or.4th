PURPOSE: x86 OR operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ OR – Logical Inclusive OR

B# 00001000 CONSTANT ALUOP-OR
B# 00001100 CONSTANT ALUOP-OR-AI

ALUOP-OR ALUOP->
ALU/RR8: OR/RR8->, (S reg1 reg2 -- )
\G Append operation OR reg2, reg1 between two 8 bit registers

ALUOP-OR ALUOP<-
ALU/RR8: OR/RR8<-, (S reg1 reg2 -- )
\G Append operation OR reg1, reg2 between two 8 bit registers

ALUOP-OR ALUOP->
ALU/RR16: OR/RR16->, (S reg1 reg2 -- )
\G Append operation OR reg2, reg1 between two 16 bit registers

ALUOP-OR ALUOP<-
ALU/RR16: OR/RR16<-, (S reg1 reg2 -- )
\G Append operation OR reg1, reg2 between two 16 bit registers

ALUOP-OR ALUOP->
ALU/RR32: OR/RR32->, (S reg1 reg2 -- )
\G Append operation OR reg2, reg1 between two 32 bit registers

ALUOP-OR ALUOP<-
ALU/RR32: OR/RR32<-, (S reg1 reg2 -- )
\G Append operation OR reg1, reg2 between two 32 bit registers


ALUOP-OR-AI
ALU/AI8: OR/AI8<-, (S imm8 -- )
\G Append operation OR AL, imm8

ALUOP-OR-AI
ALU/AI16: OR/AI16<-, (S imm16 -- )
\G Append operation OR AX, imm16

ALUOP-OR-AI
ALU/AI32: OR/AI32<-, (S imm32 -- )
\G Append operation OR EAX, imm32


\ EOF

CR

use32 .( use32 OR) cr

here dl dh OR/RR8->, 8 dump
here dl dh OR/RR8<-, 8 dump

here dx bx OR/RR16->, 8 dump
here dx bx OR/RR16<-, 8 dump

here edx ebx OR/RR32->, 8 dump
here edx ebx OR/RR32<-, 8 dump

here h# 12345678 OR/AI8<-, 8 dump
here h# 12345678 OR/AI16<-, 8 dump
here h# 12345678 OR/AI32<-, 8 dump

use16 .( use16 OR) cr

here dl dh OR/RR8->, 8 dump
here dl dh OR/RR8<-, 8 dump

here dx bx OR/RR16->, 8 dump
here dx bx OR/RR16<-, 8 dump

here edx ebx OR/RR32->, 8 dump
here edx ebx OR/RR32<-, 8 dump

here h# 12345678 OR/AI8<-, 8 dump
here h# 12345678 OR/AI16<-, 8 dump
here h# 12345678 OR/AI32<-, 8 dump
