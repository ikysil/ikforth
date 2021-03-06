PURPOSE: x86 MUL – Unsigned Multiply operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ MUL – Unsigned Multiply

: MUL/AR8, (S r8 -- )
   \G Compile operation MUL r8.
   B# 11110110 ASM8,
   B# 11100000 OR ASM8,
;

: MUL/AR16, (S r16 -- )
   \G Compile operation MUL r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11100000 OR ASM8,
;

: MUL/AR32, (S r32 -- )
   \G Compile operation MUL r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11100000 OR ASM8,
;

\ EOF

CR

use32 .( use32 MUL) cr

here dl MUL/AR8, 8 dump

here dx MUL/AR16, 8 dump

here edx MUL/AR32, 8 dump

use16 .( use16 MUL) cr

here dl MUL/AR8, 8 dump

here dx MUL/AR16, 8 dump

here edx MUL/AR32, 8 dump
