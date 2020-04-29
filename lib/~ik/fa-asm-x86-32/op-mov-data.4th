PURPOSE: x86 MOV – Move Data operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ MOV – Move Data

B# 10001000 CONSTANT ALUOP-MOV

ALUOP-MOV ALUOP->
ALU/RR8: MOV/RR8->, (S reg1 reg2 -- )
\G Append operation MOV reg2, reg1 between two 8 bit registers

ALUOP-MOV ALUOP<-
ALU/RR8: MOV/RR8<-, (S reg1 reg2 -- )
\G Append operation MOV reg1, reg2 between two 8 bit registers

ALUOP-MOV ALUOP->
ALU/RR16: MOV/RR16->, (S reg1 reg2 -- )
\G Append operation MOV reg2, reg1 between two 16 bit registers

ALUOP-MOV ALUOP<-
ALU/RR16: MOV/RR16<-, (S reg1 reg2 -- )
\G Append operation MOV reg1, reg2 between two 16 bit registers

ALUOP-MOV ALUOP->
ALU/RR32: MOV/RR32->, (S reg1 reg2 -- )
\G Append operation MOV reg2, reg1 between two 32 bit registers

ALUOP-MOV ALUOP<-
ALU/RR32: MOV/RR32<-, (S reg1 reg2 -- )
\G Append operation MOV reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 MOV) cr

here dl dh MOV/RR8->, 8 dump
here dl dh MOV/RR8<-, 8 dump

here dx bx MOV/RR16->, 8 dump
here dx bx MOV/RR16<-, 8 dump

here edx ebx MOV/RR32->, 8 dump
here edx ebx MOV/RR32<-, 8 dump

use16 .( use16 MOV) cr

here dl dh MOV/RR8->, 8 dump
here dl dh MOV/RR8<-, 8 dump

here dx bx MOV/RR16->, 8 dump
here dx bx MOV/RR16<-, 8 dump

here edx ebx MOV/RR32->, 8 dump
here edx ebx MOV/RR32<-, 8 dump
