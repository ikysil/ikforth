PURPOSE: x86 NOT – One's Complement Negation operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ NOT – One's Complement Negation

: NOT/R8, (S r8 -- )
   \G Compile operation NOT r8.
   B# 11110110 ASM8,
   B# 11010000 OR ASM8,
;

: NOT/R16, (S r16 -- )
   \G Compile operation NOT r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11010000 OR ASM8,
;

: NOT/R32, (S r32 -- )
   \G Compile operation NOT r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11010000 OR ASM8,
;

\ EOF

CR

use32 .( use32 NOT) cr

here dl NOT/R8, 8 dump

here dx NOT/R16, 8 dump

here edx NOT/R32, 8 dump

use16 .( use16 NOT) cr

here dl NOT/R8, 8 dump

here dx NOT/R16, 8 dump

here edx NOT/R32, 8 dump
