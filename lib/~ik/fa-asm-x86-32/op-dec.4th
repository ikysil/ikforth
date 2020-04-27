PURPOSE: x86 DEC – Decrement by 1 operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ DEC – Decrement by 1

: DECR8, (S reg8 -- )
   \G Compile operation DEC reg8.
   B# 11111110 ASM8,
   B# 11001000 OR ASM8,
;

: DECR16, (S reg16 -- )
   \G Compile operation DEC reg16.
   ?OP16,
   B# 11111111 ASM8,
   B# 11001000 OR ASM8,
;

: DECR32, (S reg32 -- )
   \G Compile operation DEC reg32.
   ?OP32,
   B# 11111111 ASM8,
   B# 11001000 OR ASM8,
;

B# 01001000 CONSTANT OP-DEC-ALT

: DECR16a, (S reg16 -- )
   \G Compile operation DEC reg16 (alternative encoding).
   ?OP16,
   OP-DEC-ALT OR ASM8,
;

: DECR32a, (S reg32 -- )
   \G Compile operation DEC reg32 (alternative encoding).
   ?OP32,
   OP-DEC-ALT OR ASM8,
;

\ EOF

CR

use32 .( use32 DEC) cr

here dl DECR8, 8 dump

here dx DECR16, 8 dump

here edx DECR32, 8 dump

here dx DECR16a, 8 dump

here edx DECR32a, 8 dump

use16 .( use16 DEC) cr

here dl DECR8, 8 dump

here dx DECR16, 8 dump

here edx DECR32, 8 dump

here dx DECR16a, 8 dump

here edx DECR32a, 8 dump
