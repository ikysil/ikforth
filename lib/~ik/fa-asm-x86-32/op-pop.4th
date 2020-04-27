PURPOSE: x86 POP – Pop a Word from the Stack operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ POP – Pop a Word from the Stack

: POPR16, (S reg16 -- )
   \G Compile operation POP reg16.
   ?OP16,
   B# 10001111 ASM8,
   B# 11000000 OR ASM8,
;

: POPR32, (S reg32 -- )
   \G Compile operation POP reg32.
   ?OP32,
   B# 10001111 ASM8,
   B# 11000000 OR ASM8,
;

B# 01011000 CONSTANT OP-POP-ALT

: POPR16a, (S reg16 -- )
   \G Compile operation POP reg16 (alternative encoding).
   ?OP16,
   OP-POP-ALT OR ASM8,
;

: POPR32a, (S reg32 -- )
   \G Compile operation POP reg32 (alternative encoding).
   ?OP32,
   OP-POP-ALT OR ASM8,
;

\ EOF

CR

use32 .( use32 POP) cr

here dx POPR16, 8 dump

here edx POPR32, 8 dump

here dx POPR16a, 8 dump

here edx POPR32a, 8 dump

use16 .( use16 POP) cr

here dx POPR16, 8 dump

here edx POPR32, 8 dump

here dx POPR16a, 8 dump

here edx POPR32a, 8 dump
