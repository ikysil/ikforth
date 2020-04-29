PURPOSE: x86 BTR – Bit Test and Reset operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BTR – Bit Test and Reset

: BTR/RR, (S ra rb -- )
   \G Compile operation BTR ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10110011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BTR/RR16, (S r16a r16b -- )
   \G Compile operation BTR r16a, r16b.
   ?OP16,
   BTR/RR,
;

: BTR/RR32, (S r32a r32b -- )
   \G Compile operation BTR r32a, r32b.
   ?OP32,
   BTR/RR,
;

\ EOF

CR

use32 .( use32 BTR) cr

here cx dx BTR/RR16, 8 dump

here ecx edx BTR/RR32, 8 dump

use16 .( use16 BTR) cr

here cx dx BTR/RR16, 8 dump

here ecx edx BTR/RR32, 8 dump
