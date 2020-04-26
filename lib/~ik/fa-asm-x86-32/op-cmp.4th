PURPOSE: x86 CMP operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ CMP – Compare Two Operands

B# 00111000 CONSTANT ALUOP-CMP

ALUOP-CMP ALUOP->
ALURR8: CMPRR8->, (S reg1 reg2 -- )
\G Append operation CMP reg2, reg1 between two 8 bit registers

ALUOP-CMP ALUOP<-
ALURR8: CMPRR8<-, (S reg1 reg2 -- )
\G Append operation CMP reg1, reg2 between two 8 bit registers

ALUOP-CMP ALUOP->
ALURR16: CMPRR16->, (S reg1 reg2 -- )
\G Append operation CMP reg2, reg1 between two 16 bit registers

ALUOP-CMP ALUOP<-
ALURR16: CMPRR16<-, (S reg1 reg2 -- )
\G Append operation CMP reg1, reg2 between two 16 bit registers

ALUOP-CMP ALUOP->
ALURR32: CMPRR32->, (S reg1 reg2 -- )
\G Append operation CMP reg2, reg1 between two 32 bit registers

ALUOP-CMP ALUOP<-
ALURR32: CMPRR32<-, (S reg1 reg2 -- )
\G Append operation CMP reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 CMP) cr

here dl dh CMPRR8->, 8 dump
here dl dh CMPRR8<-, 8 dump

here dx bx CMPRR16->, 8 dump
here dx bx CMPRR16<-, 8 dump

here edx ebx CMPRR32->, 8 dump
here edx ebx CMPRR32<-, 8 dump

use16 .( use16 CMP) cr

here dl dh CMPRR8->, 8 dump
here dl dh CMPRR8<-, 8 dump

here dx bx CMPRR16->, 8 dump
here dx bx CMPRR16<-, 8 dump

here edx ebx CMPRR32->, 8 dump
here edx ebx CMPRR32<-, 8 dump
