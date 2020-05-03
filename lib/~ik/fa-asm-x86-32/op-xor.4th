PURPOSE: x86 XOR operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ XOR – Logical Exclusive OR

B# 00110000 CONSTANT ALUOP-XOR
B# 00110100 CONSTANT ALUOP-XOR-AI

ALUOP-XOR ALUOP->
ALU/RR8: XOR/RR8->, (S reg1 reg2 -- )
\G Append operation XOR reg2, reg1 between two 8 bit registers

ALUOP-XOR ALUOP<-
ALU/RR8: XOR/RR8<-, (S reg1 reg2 -- )
\G Append operation XOR reg1, reg2 between two 8 bit registers

ALUOP-XOR ALUOP->
ALU/RR16: XOR/RR16->, (S reg1 reg2 -- )
\G Append operation XOR reg2, reg1 between two 16 bit registers

ALUOP-XOR ALUOP<-
ALU/RR16: XOR/RR16<-, (S reg1 reg2 -- )
\G Append operation XOR reg1, reg2 between two 16 bit registers

ALUOP-XOR ALUOP->
ALU/RR32: XOR/RR32->, (S reg1 reg2 -- )
\G Append operation XOR reg2, reg1 between two 32 bit registers

ALUOP-XOR ALUOP<-
ALU/RR32: XOR/RR32<-, (S reg1 reg2 -- )
\G Append operation XOR reg1, reg2 between two 32 bit registers


ALUOP-XOR-AI
ALU/AI8: XOR/AI8<-, (S imm8 -- )
\G Append operation XOR AL, imm8

ALUOP-XOR-AI
ALU/AI16: XOR/AI16<-, (S imm16 -- )
\G Append operation XOR AX, imm16

ALUOP-XOR-AI
ALU/AI32: XOR/AI32<-, (S imm32 -- )
\G Append operation XOR EAX, imm32


\ EOF

CR

use32 .( use32 XOR) cr

here dl dh XOR/RR8->, 8 dump
here dl dh XOR/RR8<-, 8 dump

here dx bx XOR/RR16->, 8 dump
here dx bx XOR/RR16<-, 8 dump

here edx ebx XOR/RR32->, 8 dump
here edx ebx XOR/RR32<-, 8 dump

here h# 12345678 XOR/AI8<-, 8 dump
here h# 12345678 XOR/AI16<-, 8 dump
here h# 12345678 XOR/AI32<-, 8 dump

use16 .( use16 XOR) cr

here dl dh XOR/RR8->, 8 dump
here dl dh XOR/RR8<-, 8 dump

here dx bx XOR/RR16->, 8 dump
here dx bx XOR/RR16<-, 8 dump

here edx ebx XOR/RR32->, 8 dump
here edx ebx XOR/RR32<-, 8 dump

here h# 12345678 XOR/AI8<-, 8 dump
here h# 12345678 XOR/AI16<-, 8 dump
here h# 12345678 XOR/AI32<-, 8 dump
