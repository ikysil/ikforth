PURPOSE: x86 OR operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ OR – Logical Inclusive OR

B# 00001000 CONSTANT ALUOP-OR

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


\ EOF

CR

use32 .( use32 OR) cr

here dl dh OR/RR8->, 8 dump
here dl dh OR/RR8<-, 8 dump

here dx bx OR/RR16->, 8 dump
here dx bx OR/RR16<-, 8 dump

here edx ebx OR/RR32->, 8 dump
here edx ebx OR/RR32<-, 8 dump

use16 .( use16 OR) cr

here dl dh OR/RR8->, 8 dump
here dl dh OR/RR8<-, 8 dump

here dx bx OR/RR16->, 8 dump
here dx bx OR/RR16<-, 8 dump

here edx ebx OR/RR32->, 8 dump
here edx ebx OR/RR32<-, 8 dump
