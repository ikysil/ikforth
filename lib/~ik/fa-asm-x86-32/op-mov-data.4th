PURPOSE: x86 MOV – Move Data operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ MOV – Move Data

B# 10001000 CONSTANT ALUOP-MOV

ALUOP-MOV ALUOP->
ALURR8: MOVRR8->, (S reg1 reg2 -- )
\G Append operation MOV reg2, reg1 between two 8 bit registers

ALUOP-MOV ALUOP<-
ALURR8: MOVRR8<-, (S reg1 reg2 -- )
\G Append operation MOV reg1, reg2 between two 8 bit registers

ALUOP-MOV ALUOP->
ALURR16: MOVRR16->, (S reg1 reg2 -- )
\G Append operation MOV reg2, reg1 between two 16 bit registers

ALUOP-MOV ALUOP<-
ALURR16: MOVRR16<-, (S reg1 reg2 -- )
\G Append operation MOV reg1, reg2 between two 16 bit registers

ALUOP-MOV ALUOP->
ALURR32: MOVRR32->, (S reg1 reg2 -- )
\G Append operation MOV reg2, reg1 between two 32 bit registers

ALUOP-MOV ALUOP<-
ALURR32: MOVRR32<-, (S reg1 reg2 -- )
\G Append operation MOV reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 MOV) cr

here dl dh MOVRR8->, 8 dump
here dl dh MOVRR8<-, 8 dump

here dx bx MOVRR16->, 8 dump
here dx bx MOVRR16<-, 8 dump

here edx ebx MOVRR32->, 8 dump
here edx ebx MOVRR32<-, 8 dump

use16 .( use16 MOV) cr

here dl dh MOVRR8->, 8 dump
here dl dh MOVRR8<-, 8 dump

here dx bx MOVRR16->, 8 dump
here dx bx MOVRR16<-, 8 dump

here edx ebx MOVRR32->, 8 dump
here edx ebx MOVRR32<-, 8 dump
