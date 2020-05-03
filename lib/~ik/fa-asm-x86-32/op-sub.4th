PURPOSE: x86 SUB operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SUB – Integer Subtraction

B# 00101000 CONSTANT ALUOP-SUB
B# 00101100 CONSTANT ALUOP-SUB-AI

ALUOP-SUB ALUOP->
ALU/RR8: SUB/RR8->, (S reg1 reg2 -- )
\G Append operation SUB reg2, reg1 between two 8 bit registers

ALUOP-SUB ALUOP<-
ALU/RR8: SUB/RR8<-, (S reg1 reg2 -- )
\G Append operation SUB reg1, reg2 between two 8 bit registers

ALUOP-SUB ALUOP->
ALU/RR16: SUB/RR16->, (S reg1 reg2 -- )
\G Append operation SUB reg2, reg1 between two 16 bit registers

ALUOP-SUB ALUOP<-
ALU/RR16: SUB/RR16<-, (S reg1 reg2 -- )
\G Append operation SUB reg1, reg2 between two 16 bit registers

ALUOP-SUB ALUOP->
ALU/RR32: SUB/RR32->, (S reg1 reg2 -- )
\G Append operation SUB reg2, reg1 between two 32 bit registers

ALUOP-SUB ALUOP<-
ALU/RR32: SUB/RR32<-, (S reg1 reg2 -- )
\G Append operation SUB reg1, reg2 between two 32 bit registers


ALUOP-SUB-AI
ALU/AI8: SUB/AI8<-, (S imm8 -- )
\G Append operation SUB AL, imm8

ALUOP-SUB-AI
ALU/AI16: SUB/AI16<-, (S imm16 -- )
\G Append operation SUB AX, imm16

ALUOP-SUB-AI
ALU/AI32: SUB/AI32<-, (S imm32 -- )
\G Append operation SUB EAX, imm32


\ EOF

CR

use32 .( use32 SUB) cr

here dl dh SUB/RR8->, 8 dump
here dl dh SUB/RR8<-, 8 dump

here dx bx SUB/RR16->, 8 dump
here dx bx SUB/RR16<-, 8 dump

here edx ebx SUB/RR32->, 8 dump
here edx ebx SUB/RR32<-, 8 dump

here h# 12345678 SUB/AI8<-, 8 dump
here h# 12345678 SUB/AI16<-, 8 dump
here h# 12345678 SUB/AI32<-, 8 dump

use16 .( use16 SUB) cr

here dl dh SUB/RR8->, 8 dump
here dl dh SUB/RR8<-, 8 dump

here dx bx SUB/RR16->, 8 dump
here dx bx SUB/RR16<-, 8 dump

here edx ebx SUB/RR32->, 8 dump
here edx ebx SUB/RR32<-, 8 dump

here h# 12345678 SUB/AI8<-, 8 dump
here h# 12345678 SUB/AI16<-, 8 dump
here h# 12345678 SUB/AI32<-, 8 dump
