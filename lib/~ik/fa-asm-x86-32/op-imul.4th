PURPOSE: x86 IMUL – Signed Multiply operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ IMUL – Signed Multiply

: IMUL/AR8, (S r8 -- )
   \G Compile operation IMUL r8.
   B# 11110110 ASM8,
   B# 11101000 OR ASM8,
;

: IMUL/AR16, (S r16 -- )
   \G Compile operation IMUL r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11101000 OR ASM8,
;

: IMUL/AR32, (S r32 -- )
   \G Compile operation IMUL r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11101000 OR ASM8,
;

: IMUL/RR, (S ra rb -- )
   \G Compile operation IMUL ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10101111 ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: IMUL/RR16, (S r16a r16b -- )
   \G Compile operation IMUL r16a, r16b.
   ?OP16,
   IMUL/RR,
;

: IMUL/RR32, (S r32a r32b -- )
   \G Compile operation IMUL r32a, r32b.
   ?OP32,
   IMUL/RR,
;

\ EOF

CR

use32 .( use32 IMUL) cr

here dl IMUL/AR8, 8 dump

here dx IMUL/AR16, 8 dump

here edx IMUL/AR32, 8 dump

here bx dx IMUL/RR16, 8 dump

here ebx edx IMUL/RR32, 8 dump

use16 .( use16 IMUL) cr

here dl IMUL/AR8, 8 dump

here dx IMUL/AR16, 8 dump

here edx IMUL/AR32, 8 dump

here bx dx IMUL/RR16, 8 dump

here ebx edx IMUL/RR32, 8 dump
