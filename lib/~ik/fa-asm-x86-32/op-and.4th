PURPOSE: x86 AND operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ AND – Logical AND

B# 00100000 CONSTANT ALUOP-AND

ALUOP-AND ALUOP->
ALURR8: ANDRR8->, (S reg1 reg2 -- )
\G Append operation AND reg2, reg1 between two 8 bit registers

ALUOP-AND ALUOP<-
ALURR8: ANDRR8<-, (S reg1 reg2 -- )
\G Append operation AND reg1, reg2 between two 8 bit registers

ALUOP-AND ALUOP->
ALURR16: ANDRR16->, (S reg1 reg2 -- )
\G Append operation AND reg2, reg1 between two 16 bit registers

ALUOP-AND ALUOP<-
ALURR16: ANDRR16<-, (S reg1 reg2 -- )
\G Append operation AND reg1, reg2 between two 16 bit registers

ALUOP-AND ALUOP->
ALURR32: ANDRR32->, (S reg1 reg2 -- )
\G Append operation AND reg2, reg1 between two 32 bit registers

ALUOP-AND ALUOP<-
ALURR32: ANDRR32<-, (S reg1 reg2 -- )
\G Append operation AND reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 AND) cr

here dl dh ANDRR8->, 8 dump
here dl dh ANDRR8<-, 8 dump

here dx bx ANDRR16->, 8 dump
here dx bx ANDRR16<-, 8 dump

here edx ebx ANDRR32->, 8 dump
here edx ebx ANDRR32<-, 8 dump

use16 .( use16 AND) cr

here dl dh ANDRR8->, 8 dump
here dl dh ANDRR8<-, 8 dump

here dx bx ANDRR16->, 8 dump
here dx bx ANDRR16<-, 8 dump

here edx ebx ANDRR32->, 8 dump
here edx ebx ANDRR32<-, 8 dump
