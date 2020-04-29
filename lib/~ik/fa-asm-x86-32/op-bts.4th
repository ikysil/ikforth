PURPOSE: x86 BTS – Bit Test and Set operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BTS – Bit Test and Set

: BTSR, (S ra rb -- )
   \G Compile operation BTS ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10101011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BTSR16, (S r16a r16b -- )
   \G Compile operation BTS r16a, r16b.
   ?OP16,
   BTSR,
;

: BTSR32, (S r32a r32b -- )
   \G Compile operation BTS r32a, r32b.
   ?OP32,
   BTSR,
;

\ EOF

CR

use32 .( use32 BTS) cr

here cx dx BTSR16, 8 dump

here ecx edx BTSR32, 8 dump

use16 .( use16 BTS) cr

here cx dx BTSR16, 8 dump

here ecx edx BTSR32, 8 dump
