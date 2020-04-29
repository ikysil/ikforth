PURPOSE: x86 SBB operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SBB – Integer Subtraction with Borrow

B# 00011000 CONSTANT ALUOP-SBB

ALUOP-SBB ALUOP->
ALU/RR8: SBB/RR8->, (S reg1 reg2 -- )
\G Append operation SBB reg2, reg1 between two 8 bit registers

ALUOP-SBB ALUOP<-
ALU/RR8: SBB/RR8<-, (S reg1 reg2 -- )
\G Append operation SBB reg1, reg2 between two 8 bit registers

ALUOP-SBB ALUOP->
ALU/RR16: SBB/RR16->, (S reg1 reg2 -- )
\G Append operation SBB reg2, reg1 between two 16 bit registers

ALUOP-SBB ALUOP<-
ALU/RR16: SBB/RR16<-, (S reg1 reg2 -- )
\G Append operation SBB reg1, reg2 between two 16 bit registers

ALUOP-SBB ALUOP->
ALU/RR32: SBB/RR32->, (S reg1 reg2 -- )
\G Append operation SBB reg2, reg1 between two 32 bit registers

ALUOP-SBB ALUOP<-
ALU/RR32: SBB/RR32<-, (S reg1 reg2 -- )
\G Append operation SBB reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 SBB) cr

here dl dh SBB/RR8->, 8 dump
here dl dh SBB/RR8<-, 8 dump

here dx bx SBB/RR16->, 8 dump
here dx bx SBB/RR16<-, 8 dump

here edx ebx SBB/RR32->, 8 dump
here edx ebx SBB/RR32<-, 8 dump

use16 .( use16 SBB) cr

here dl dh SBB/RR8->, 8 dump
here dl dh SBB/RR8<-, 8 dump

here dx bx SBB/RR16->, 8 dump
here dx bx SBB/RR16<-, 8 dump

here edx ebx SBB/RR32->, 8 dump
here edx ebx SBB/RR32<-, 8 dump
