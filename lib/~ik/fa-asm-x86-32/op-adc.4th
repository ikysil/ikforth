PURPOSE: x86 ADC operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ ADC – ADD with Carry

B# 00010000 CONSTANT ALUOP-ADC
B# 00010100 CONSTANT ALUOP-ADC-AI

ALUOP-ADC ALUOP->
ALU/RR8: ADC/RR8->, (S reg1 reg2 -- )
\G Append operation ADC reg2, reg1 between two 8 bit registers

ALUOP-ADC ALUOP<-
ALU/RR8: ADC/RR8<-, (S reg1 reg2 -- )
\G Append operation ADC reg1, reg2 between two 8 bit registers

ALUOP-ADC ALUOP->
ALU/RR16: ADC/RR16->, (S reg1 reg2 -- )
\G Append operation ADC reg2, reg1 between two 16 bit registers

ALUOP-ADC ALUOP<-
ALU/RR16: ADC/RR16<-, (S reg1 reg2 -- )
\G Append operation ADC reg1, reg2 between two 16 bit registers

ALUOP-ADC ALUOP->
ALU/RR32: ADC/RR32->, (S reg1 reg2 -- )
\G Append operation ADC reg2, reg1 between two 32 bit registers

ALUOP-ADC ALUOP<-
ALU/RR32: ADC/RR32<-, (S reg1 reg2 -- )
\G Append operation ADC reg1, reg2 between two 32 bit registers

ALUOP-ADC-AI
ALU/AI8: ADC/AI8<-, (S imm8 -- )
\G Append operation ADC AL, imm8

ALUOP-ADC-AI
ALU/AI16: ADC/AI16<-, (S imm16 -- )
\G Append operation ADC AX, imm16

ALUOP-ADC-AI
ALU/AI32: ADC/AI32<-, (S imm32 -- )
\G Append operation ADC EAX, imm32


\ EOF

CR

use32 .( use32 ADC) cr

here dl dh ADC/RR8->, 8 dump
here dl dh ADC/RR8<-, 8 dump

here dx bx ADC/RR16->, 8 dump
here dx bx ADC/RR16<-, 8 dump

here edx ebx ADC/RR32->, 8 dump
here edx ebx ADC/RR32<-, 8 dump

here h# 12345678 ADC/AI8<-, 8 dump
here h# 12345678 ADC/AI16<-, 8 dump
here h# 12345678 ADC/AI32<-, 8 dump

use16 .( use16 ADC) cr

here dl dh ADC/RR8->, 8 dump
here dl dh ADC/RR8<-, 8 dump

here dx bx ADC/RR16->, 8 dump
here dx bx ADC/RR16<-, 8 dump

here edx ebx ADC/RR32->, 8 dump
here edx ebx ADC/RR32<-, 8 dump

here h# 12345678 ADC/AI8<-, 8 dump
here h# 12345678 ADC/AI16<-, 8 dump
here h# 12345678 ADC/AI32<-, 8 dump
