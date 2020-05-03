PURPOSE: x86 ADD operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ ADD – Add

B# 00000000 CONSTANT ALUOP-ADD
B# 00000100 CONSTANT ALUOP-ADD-AI

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

ALUOP-ADD-AI
ALU/AI8: ADD/AI8<-, (S imm8 -- )
\G Append operation ADD AL, imm8

ALUOP-ADD-AI
ALU/AI16: ADD/AI16<-, (S imm16 -- )
\G Append operation ADD AX, imm16

ALUOP-ADD-AI
ALU/AI32: ADD/AI32<-, (S imm32 -- )
\G Append operation ADD EAX, imm32


\ EOF

CR

use32 .( use32 ADD) cr

here dl dh ADD/RR8->, 8 dump
here dl dh ADD/RR8<-, 8 dump

here dx bx ADD/RR16->, 8 dump
here dx bx ADD/RR16<-, 8 dump

here edx ebx ADD/RR32->, 8 dump
here edx ebx ADD/RR32<-, 8 dump

here h# 12345678 ADD/AI8<-, 8 dump
here h# 12345678 ADD/AI16<-, 8 dump
here h# 12345678 ADD/AI32<-, 8 dump

use16 .( use16 ADD) cr

here dl dh ADD/RR8->, 8 dump
here dl dh ADD/RR8<-, 8 dump

here dx bx ADD/RR16->, 8 dump
here dx bx ADD/RR16<-, 8 dump

here edx ebx ADD/RR32->, 8 dump
here edx ebx ADD/RR32<-, 8 dump

here h# 12345678 ADD/AI8<-, 8 dump
here h# 12345678 ADD/AI16<-, 8 dump
here h# 12345678 ADD/AI32<-, 8 dump
