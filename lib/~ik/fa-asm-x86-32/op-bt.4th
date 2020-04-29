PURPOSE: x86 BT – Bit Test operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BT – Bit Test

: BTR, (S ra rb -- )
   \G Compile operation BT ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10100011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BTR16, (S r16a r16b -- )
   \G Compile operation BT r16a, r16b.
   ?OP16,
   BTR,
;

: BTR32, (S r32a r32b -- )
   \G Compile operation BT r32a, r32b.
   ?OP32,
   BTR,
;

\ EOF

CR

use32 .( use32 BT) cr

here cx dx BTR16, 8 dump

here ecx edx BTR32, 8 dump

use16 .( use16 BT) cr

here cx dx BTR16, 8 dump

here ecx edx BTR32, 8 dump
