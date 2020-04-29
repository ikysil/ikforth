PURPOSE: x86 ADD operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ ADD – Add

B# 00000000 CONSTANT ALUOP-ADD

ALUOP-ADD ALUOP->
ALU/RR8: ADD/RR8->, (S reg1 reg2 -- )
\G Append operation ADD reg2, reg1 between two 8 bit registers

ALUOP-ADD ALUOP<-
ALU/RR8: ADD/RR8<-, (S reg1 reg2 -- )
\G Append operation ADD reg1, reg2 between two 8 bit registers

ALUOP-ADD ALUOP->
ALU/RR16: ADD/RR16->, (S reg1 reg2 -- )
\G Append operation ADD reg2, reg1 between two 16 bit registers

ALUOP-ADD ALUOP<-
ALU/RR16: ADD/RR16<-, (S reg1 reg2 -- )
\G Append operation ADD reg1, reg2 between two 16 bit registers

ALUOP-ADD ALUOP->
ALU/RR32: ADD/RR32->, (S reg1 reg2 -- )
\G Append operation ADD reg2, reg1 between two 32 bit registers

ALUOP-ADD ALUOP<-
ALU/RR32: ADD/RR32<-, (S reg1 reg2 -- )
\G Append operation ADD reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 ADD) cr

here dl dh ADD/RR8->, 8 dump
here dl dh ADD/RR8<-, 8 dump

here dx bx ADD/RR16->, 8 dump
here dx bx ADD/RR16<-, 8 dump

here edx ebx ADD/RR32->, 8 dump
here edx ebx ADD/RR32<-, 8 dump

use16 .( use16 ADD) cr

here dl dh ADD/RR8->, 8 dump
here dl dh ADD/RR8<-, 8 dump

here dx bx ADD/RR16->, 8 dump
here dx bx ADD/RR16<-, 8 dump

here edx ebx ADD/RR32->, 8 dump
here edx ebx ADD/RR32<-, 8 dump
