PURPOSE: x86 BSR – Bit Scan Reverse operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BSR – Bit Scan Reverse

: BSRR, (S ra rb -- )
   \G Compile operation BSR ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10111101 ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BSRR16, (S r16a r16b -- )
   \G Compile operation BSR r16a, r16b.
   ?OP16,
   BSRR,
;

: BSRR32, (S r32a r32b -- )
   \G Compile operation BSR r32a, r32b.
   ?OP32,
   BSRR,
;

\ EOF

CR

use32 .( use32 BSR) cr

here cx dx BSRR16, 8 dump

here ecx edx BSRR32, 8 dump

use16 .( use16 BSR) cr

here cx dx BSRR16, 8 dump

here ecx edx BSRR32, 8 dump
