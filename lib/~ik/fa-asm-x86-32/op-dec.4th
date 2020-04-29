PURPOSE: x86 DEC – Decrement by 1 operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ DEC – Decrement by 1

: DEC/RR8, (S reg8 -- )
   \G Compile operation DEC reg8.
   B# 11111110 ASM8,
   B# 11001000 OR ASM8,
;

: DEC/RR16, (S reg16 -- )
   \G Compile operation DEC reg16.
   ?OP16,
   B# 11111111 ASM8,
   B# 11001000 OR ASM8,
;

: DEC/RR32, (S reg32 -- )
   \G Compile operation DEC reg32.
   ?OP32,
   B# 11111111 ASM8,
   B# 11001000 OR ASM8,
;

B# 01001000 CONSTANT OP-DEC-ALT

: DEC/RR16a, (S reg16 -- )
   \G Compile operation DEC reg16 (alternative encoding).
   ?OP16,
   OP-DEC-ALT OR ASM8,
;

: DEC/RR32a, (S reg32 -- )
   \G Compile operation DEC reg32 (alternative encoding).
   ?OP32,
   OP-DEC-ALT OR ASM8,
;

\ EOF

CR

use32 .( use32 DEC) cr

here dl DEC/RR8, 8 dump

here dx DEC/RR16, 8 dump

here edx DEC/RR32, 8 dump

here dx DEC/RR16a, 8 dump

here edx DEC/RR32a, 8 dump

use16 .( use16 DEC) cr

here dl DEC/RR8, 8 dump

here dx DEC/RR16, 8 dump

here edx DEC/RR32, 8 dump

here dx DEC/RR16a, 8 dump

here edx DEC/RR32a, 8 dump
