PURPOSE: x86 BT – Bit Test operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BT – Bit Test

: BT/RR, (S ra rb -- )
   \G Compile operation BT ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10100011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BT/RR16, (S r16a r16b -- )
   \G Compile operation BT r16a, r16b.
   ?OP16,
   BT/RR,
;

: BT/RR32, (S r32a r32b -- )
   \G Compile operation BT r32a, r32b.
   ?OP32,
   BT/RR,
;

\ EOF

CR

use32 .( use32 BT) cr

here cx dx BT/RR16, 8 dump

here ecx edx BT/RR32, 8 dump

use16 .( use16 BT) cr

here cx dx BT/RR16, 8 dump

here ecx edx BT/RR32, 8 dump
