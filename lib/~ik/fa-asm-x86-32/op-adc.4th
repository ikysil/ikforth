PURPOSE: x86 ADC operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ ADC – ADD with Carry

B# 00010000 CONSTANT ALUOP-ADC

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


\ EOF

CR

use32 .( use32 ADC) cr

here dl dh ADC/RR8->, 8 dump
here dl dh ADC/RR8<-, 8 dump

here dx bx ADC/RR16->, 8 dump
here dx bx ADC/RR16<-, 8 dump

here edx ebx ADC/RR32->, 8 dump
here edx ebx ADC/RR32<-, 8 dump

use16 .( use16 ADC) cr

here dl dh ADC/RR8->, 8 dump
here dl dh ADC/RR8<-, 8 dump

here dx bx ADC/RR16->, 8 dump
here dx bx ADC/RR16<-, 8 dump

here edx ebx ADC/RR32->, 8 dump
here edx ebx ADC/RR32<-, 8 dump
