PURPOSE: x86 PUSH – Push Operand onto the Stack operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ PUSH – Push Operand onto the Stack

: PUSHR16, (S reg16 -- )
   \G Compile operation PUSH reg16.
   ?OP16,
   B# 11111111 ASM8,
   B# 11110000 OR ASM8,
;

: PUSHR32, (S reg32 -- )
   \G Compile operation PUSH reg32.
   ?OP32,
   B# 11111111 ASM8,
   B# 11110000 OR ASM8,
;

B# 01010000 CONSTANT OP-PUSH-ALT

: PUSHR16a, (S reg16 -- )
   \G Compile operation PUSH reg16 (alternative encoding).
   ?OP16,
   OP-PUSH-ALT OR ASM8,
;

: PUSHR32a, (S reg32 -- )
   \G Compile operation PUSH reg32 (alternative encoding).
   ?OP32,
   OP-PUSH-ALT OR ASM8,
;

\ EOF

CR

use32 .( use32 PUSH) cr

here dx PUSHR16, 8 dump

here edx PUSHR32, 8 dump

here dx PUSHR16a, 8 dump

here edx PUSHR32a, 8 dump

use16 .( use16 PUSH) cr

here dx PUSHR16, 8 dump

here edx PUSHR32, 8 dump

here dx PUSHR16a, 8 dump

here edx PUSHR32a, 8 dump
