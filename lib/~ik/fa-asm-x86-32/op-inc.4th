PURPOSE: x86 INC – Increment by 1 operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ INC – Increment by 1

: INCR8, (S r8 -- )
   \G Compile operation INC r8.
   B# 11111110 ASM8,
   B# 11000000 OR ASM8,
;

: INCR16, (S r16 -- )
   \G Compile operation INC r16.
   ?OP16,
   B# 11111111 ASM8,
   B# 11000000 OR ASM8,
;

: INCR32, (S r32 -- )
   \G Compile operation INC r32.
   ?OP32,
   B# 11111111 ASM8,
   B# 11000000 OR ASM8,
;

B# 01000000 CONSTANT OP-INC-ALT

: INCR16a, (S r16 -- )
   \G Compile operation INC r16 (alternative encoding).
   ?OP16,
   OP-INC-ALT OR ASM8,
;

: INCR32a, (S r32 -- )
   \G Compile operation INC r32 (alternative encoding).
   ?OP32,
   OP-INC-ALT OR ASM8,
;

\ EOF

CR

use32 .( use32 INC) cr

here dl INCR8, 8 dump

here dx INCR16, 8 dump

here edx INCR32, 8 dump

here dx INCR16a, 8 dump

here edx INCR32a, 8 dump

use16 .( use16 INC) cr

here dl INCR8, 8 dump

here dx INCR16, 8 dump

here edx INCR32, 8 dump

here dx INCR16a, 8 dump

here edx INCR32a, 8 dump
