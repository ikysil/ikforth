PURPOSE: x86 CMP operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ CMP – Compare Two Operands

B# 00111000 CONSTANT ALUOP-CMP
B# 00111100 CONSTANT ALUOP-CMP-AI

ALUOP-CMP ALUOP->
ALU/RR8: CMP/RR8->, (S reg1 reg2 -- )
\G Append operation CMP reg2, reg1 between two 8 bit registers

ALUOP-CMP ALUOP<-
ALU/RR8: CMP/RR8<-, (S reg1 reg2 -- )
\G Append operation CMP reg1, reg2 between two 8 bit registers

ALUOP-CMP ALUOP->
ALU/RR16: CMP/RR16->, (S reg1 reg2 -- )
\G Append operation CMP reg2, reg1 between two 16 bit registers

ALUOP-CMP ALUOP<-
ALU/RR16: CMP/RR16<-, (S reg1 reg2 -- )
\G Append operation CMP reg1, reg2 between two 16 bit registers

ALUOP-CMP ALUOP->
ALU/RR32: CMP/RR32->, (S reg1 reg2 -- )
\G Append operation CMP reg2, reg1 between two 32 bit registers

ALUOP-CMP ALUOP<-
ALU/RR32: CMP/RR32<-, (S reg1 reg2 -- )
\G Append operation CMP reg1, reg2 between two 32 bit registers


ALUOP-CMP-AI
ALU/AI8: CMP/AI8<-, (S imm8 -- )
\G Append operation CMP AL, imm8

ALUOP-CMP-AI
ALU/AI16: CMP/AI16<-, (S imm16 -- )
\G Append operation CMP AX, imm16

ALUOP-CMP-AI
ALU/AI32: CMP/AI32<-, (S imm32 -- )
\G Append operation CMP EAX, imm32


\ EOF

CR

use32 .( use32 CMP) cr

here dl dh CMP/RR8->, 8 dump
here dl dh CMP/RR8<-, 8 dump

here dx bx CMP/RR16->, 8 dump
here dx bx CMP/RR16<-, 8 dump

here edx ebx CMP/RR32->, 8 dump
here edx ebx CMP/RR32<-, 8 dump

here h# 12345678 CMP/AI8<-, 8 dump
here h# 12345678 CMP/AI16<-, 8 dump
here h# 12345678 CMP/AI32<-, 8 dump

use16 .( use16 CMP) cr

here dl dh CMP/RR8->, 8 dump
here dl dh CMP/RR8<-, 8 dump

here dx bx CMP/RR16->, 8 dump
here dx bx CMP/RR16<-, 8 dump

here edx ebx CMP/RR32->, 8 dump
here edx ebx CMP/RR32<-, 8 dump

here h# 12345678 CMP/AI8<-, 8 dump
here h# 12345678 CMP/AI16<-, 8 dump
here h# 12345678 CMP/AI32<-, 8 dump
