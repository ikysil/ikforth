PURPOSE: x86 XCHG operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ XCHG – Exchange Register/Memory with Register

B# 10000110 CONSTANT ALUOP-XCHG

ALUOP-XCHG
ALU/RR8: XCHG/RR8, (S reg1 reg2 -- )
\G Append operation XCHG reg1, reg2 between two 8 bit registers

ALUOP-XCHG
ALU/RR16: XCHG/RR16, (S reg1 reg2 -- )
\G Append operation XCHG reg1, reg2 between two 16 bit registers

ALUOP-XCHG
ALU/RR32: XCHG/RR32, (S reg1 reg2 -- )
\G Append operation XCHG reg1, reg2 between two 32 bit registers

: XCHG/AR, (S reg -- )
   \G Compile operation XCHG [E]AX, reg (without operand size prefix).
   B# 10010000 OR ASM8,
;

: XCHG/AR16, (S reg -- )
   \G Compile operation XCHG AX, reg.
   ?OP16,
   XCHG/AR,
;

: XCHG/AR32, (S reg -- )
   \G Compile operation XCHG EAX, reg.
   ?OP32,
   XCHG/AR,
;


\ EOF

CR

use32 .( use32 XCHG) cr

here dl dh XCHG/RR8, 8 dump

here dx bx XCHG/RR16, 8 dump

here edx ebx XCHG/RR32, 8 dump

here cx XCHG/AR16, 8 dump

here ecx XCHG/AR32, 8 dump

use16 .( use16 XCHG) cr

here dl dh XCHG/RR8, 8 dump

here dx bx XCHG/RR16, 8 dump

here edx ebx XCHG/RR32, 8 dump

here cx XCHG/AR16, 8 dump

here ecx XCHG/AR32, 8 dump
