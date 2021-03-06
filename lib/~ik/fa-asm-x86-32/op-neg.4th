PURPOSE: x86 NEG – Two's Complement Negation operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ NEG – Two's Complement Negation

: NEG/R8, (S r8 -- )
   \G Compile operation NEG r8.
   B# 11110110 ASM8,
   B# 11011000 OR ASM8,
;

: NEG/R16, (S r16 -- )
   \G Compile operation NEG r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11011000 OR ASM8,
;

: NEG/R32, (S r32 -- )
   \G Compile operation NEG r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11011000 OR ASM8,
;

\ EOF

CR

use32 .( use32 NEG) cr

here dl NEG/R8, 8 dump

here dx NEG/R16, 8 dump

here edx NEG/R32, 8 dump

use16 .( use16 NEG) cr

here dl NEG/R8, 8 dump

here dx NEG/R16, 8 dump

here edx NEG/R32, 8 dump
