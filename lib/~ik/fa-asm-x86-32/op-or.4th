PURPOSE: x86 OR operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ OR – Logical Inclusive OR

B# 00001000 CONSTANT ALUOP-OR

ALUOP-OR ALUOP->
ALURR8: ORRR8->, (S reg1 reg2 -- )
\G Append operation OR reg2, reg1 between two 8 bit registers

ALUOP-OR ALUOP<-
ALURR8: ORRR8<-, (S reg1 reg2 -- )
\G Append operation OR reg1, reg2 between two 8 bit registers

ALUOP-OR ALUOP->
ALURR16: ORRR16->, (S reg1 reg2 -- )
\G Append operation OR reg2, reg1 between two 16 bit registers

ALUOP-OR ALUOP<-
ALURR16: ORRR16<-, (S reg1 reg2 -- )
\G Append operation OR reg1, reg2 between two 16 bit registers

ALUOP-OR ALUOP->
ALURR32: ORRR32->, (S reg1 reg2 -- )
\G Append operation OR reg2, reg1 between two 32 bit registers

ALUOP-OR ALUOP<-
ALURR32: ORRR32<-, (S reg1 reg2 -- )
\G Append operation OR reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 OR) cr

here dl dh ORRR8->, 8 dump
here dl dh ORRR8<-, 8 dump

here dx bx ORRR16->, 8 dump
here dx bx ORRR16<-, 8 dump

here edx ebx ORRR32->, 8 dump
here edx ebx ORRR32<-, 8 dump

use16 .( use16 OR) cr

here dl dh ORRR8->, 8 dump
here dl dh ORRR8<-, 8 dump

here dx bx ORRR16->, 8 dump
here dx bx ORRR16<-, 8 dump

here edx ebx ORRR32->, 8 dump
here edx ebx ORRR32<-, 8 dump
