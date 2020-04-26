PURPOSE: x86 XCHG operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ XCHG – Exchange Register/Memory with Register

B# 10000110 CONSTANT ALUOP-XCHG

ALUOP-XCHG
ALURR8: XCHGRR8, (S reg1 reg2 -- )
\G Append operation XCHG reg1, reg2 between two 8 bit registers

ALUOP-XCHG
ALURR16: XCHGRR16, (S reg1 reg2 -- )
\G Append operation XCHG reg1, reg2 between two 16 bit registers

ALUOP-XCHG
ALURR32: XCHGRR32, (S reg1 reg2 -- )
\G Append operation XCHG reg1, reg2 between two 32 bit registers


\ EOF

CR

use32 .( use32 XCHG) cr

here dl dh XCHGRR8, 8 dump

here dx bx XCHGRR16, 8 dump

here edx ebx XCHGRR32, 8 dump

use16 .( use16 XCHG) cr

here dl dh XCHGRR8, 8 dump

here dx bx XCHGRR16, 8 dump

here edx ebx XCHGRR32, 8 dump
