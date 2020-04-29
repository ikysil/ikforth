PURPOSE: x86 AND operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ AND – Logical AND

B# 00100000 CONSTANT ALUOP-AND

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


\ EOF

CR

use32 .( use32 AND) cr

here dl dh AND/RR8->, 8 dump
here dl dh AND/RR8<-, 8 dump

here dx bx AND/RR16->, 8 dump
here dx bx AND/RR16<-, 8 dump

here edx ebx AND/RR32->, 8 dump
here edx ebx AND/RR32<-, 8 dump

use16 .( use16 AND) cr

here dl dh AND/RR8->, 8 dump
here dl dh AND/RR8<-, 8 dump

here dx bx AND/RR16->, 8 dump
here dx bx AND/RR16<-, 8 dump

here edx ebx AND/RR32->, 8 dump
here edx ebx AND/RR32<-, 8 dump
