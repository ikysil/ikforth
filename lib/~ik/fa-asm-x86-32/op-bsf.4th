PURPOSE: x86 BSF – Bit Scan Forward operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BSF – Bit Scan Forward

: BSF/RR, (S ra rb -- )
   \G Compile operation BSF ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10111100 ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BSF/RR16, (S r16a r16b -- )
   \G Compile operation BSF r16a, r16b.
   ?OP16,
   BSF/RR,
;

: BSF/RR32, (S r32a r32b -- )
   \G Compile operation BSF r32a, r32b.
   ?OP32,
   BSF/RR,
;

\ EOF

CR

use32 .( use32 BSF) cr

here cx dx BSF/RR16, 8 dump

here ecx edx BSF/RR32, 8 dump

use16 .( use16 BSF) cr

here cx dx BSF/RR16, 8 dump

here ecx edx BSF/RR32, 8 dump
