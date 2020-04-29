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

\ EOF

CR

use32 .( use32 IMUL) cr

here dl IMUL/AR8, 8 dump

here dx IMUL/AR16, 8 dump

here edx IMUL/AR32, 8 dump

use16 .( use16 IMUL) cr

here dl IMUL/AR8, 8 dump

here dx IMUL/AR16, 8 dump

here edx IMUL/AR32, 8 dump
