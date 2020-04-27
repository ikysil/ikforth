PURPOSE: x86 NOT – One's Complement Negation operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ NOT – One's Complement Negation

: NOTR8, (S r8 -- )
   \G Compile operation NOT r8.
   B# 11110110 ASM8,
   B# 11010000 OR ASM8,
;

: NOTR16, (S r16 -- )
   \G Compile operation NOT r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11010000 OR ASM8,
;

: NOTR32, (S r32 -- )
   \G Compile operation NOT r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11010000 OR ASM8,
;

\ EOF

CR

use32 .( use32 NOT) cr

here dl NOTR8, 8 dump

here dx NOTR16, 8 dump

here edx NOTR32, 8 dump

use16 .( use16 NOT) cr

here dl NOTR8, 8 dump

here dx NOTR16, 8 dump

here edx NOTR32, 8 dump
