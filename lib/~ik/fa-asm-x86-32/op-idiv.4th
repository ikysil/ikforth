PURPOSE: x86 IDIV – Signed Divide operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ IDIV – Signed Divide

: IDIVR8, (S r8 -- )
   \G Compile operation IDIV r8.
   B# 11110110 ASM8,
   B# 11111000 OR ASM8,
;

: IDIVR16, (S r16 -- )
   \G Compile operation IDIV r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11111000 OR ASM8,
;

: IDIVR32, (S r32 -- )
   \G Compile operation IDIV r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11111000 OR ASM8,
;

\ EOF

CR

use32 .( use32 IDIV) cr

here dl IDIVR8, 8 dump

here dx IDIVR16, 8 dump

here edx IDIVR32, 8 dump

use16 .( use16 IDIV) cr

here dl IDIVR8, 8 dump

here dx IDIVR16, 8 dump

here edx IDIVR32, 8 dump
