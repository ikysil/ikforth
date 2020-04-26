PURPOSE: x86 XOR operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ XOR – Logical Exclusive OR

B# 00110000 CONSTANT ALUOP-XOR

ALUOP-XOR ALUOP->
ALURR8: XORRR8->, (S reg1 reg2 -- )
\G Append operation XOR reg2, reg1 between two 8 bit registers

ALUOP-XOR ALUOP<-
ALURR8: XORRR8<-, (S reg1 reg2 -- )
\G Append operation XOR reg1, reg2 between two 8 bit registers

ALUOP-XOR ALUOP->
ALURR16: XORRR16->, (S reg1 reg2 -- )
\G Append operation XOR reg2, reg1 between two 16 bit registers

ALUOP-XOR ALUOP<-
ALURR16: XORRR16<-, (S reg1 reg2 -- )
\G Append operation XOR reg1, reg2 between two 16 bit registers

ALUOP-XOR ALUOP->
ALURR32: XORRR32->, (S reg1 reg2 -- )
\G Append operation XOR reg2, reg1 between two 32 bit registers

ALUOP-XOR ALUOP<-
ALURR32: XORRR32<-, (S reg1 reg2 -- )
\G Append operation XOR reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 XOR) cr

here dl dh XORRR8->, 8 dump
here dl dh XORRR8<-, 8 dump

here dx bx XORRR16->, 8 dump
here dx bx XORRR16<-, 8 dump

here edx ebx XORRR32->, 8 dump
here edx ebx XORRR32<-, 8 dump

use16 .( use16 XOR) cr

here dl dh XORRR8->, 8 dump
here dl dh XORRR8<-, 8 dump

here dx bx XORRR16->, 8 dump
here dx bx XORRR16<-, 8 dump

here edx ebx XORRR32->, 8 dump
here edx ebx XORRR32<-, 8 dump
