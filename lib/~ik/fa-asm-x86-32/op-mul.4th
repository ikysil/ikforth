PURPOSE: x86 MUL – Unsigned Multiply operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ MUL – Unsigned Multiply

: MULAR8, (S r8 -- )
   \G Compile operation MUL r8.
   B# 11110110 ASM8,
   B# 11100000 OR ASM8,
;

: MULAR16, (S r16 -- )
   \G Compile operation MUL r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11100000 OR ASM8,
;

: MULAR32, (S r32 -- )
   \G Compile operation MUL r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11100000 OR ASM8,
;

\ EOF

CR

use32 .( use32 MUL) cr

here dl MULAR8, 8 dump

here dx MULAR16, 8 dump

here edx MULAR32, 8 dump

use16 .( use16 MUL) cr

here dl MULAR8, 8 dump

here dx MULAR16, 8 dump

here edx MULAR32, 8 dump
