PURPOSE: x86 DIV – Unsigned Divide operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ DIV – Unsigned Divide

: DIVAR8, (S r8 -- )
   \G Compile operation DIV r8.
   B# 11110110 ASM8,
   B# 11110000 OR ASM8,
;

: DIVAR16, (S r16 -- )
   \G Compile operation DIV r16.
   ?OP16,
   B# 11110111 ASM8,
   B# 11110000 OR ASM8,
;

: DIVAR32, (S r32 -- )
   \G Compile operation DIV r32.
   ?OP32,
   B# 11110111 ASM8,
   B# 11110000 OR ASM8,
;

\ EOF

CR

use32 .( use32 DIV) cr

here dl DIVAR8, 8 dump

here dx DIVAR16, 8 dump

here edx DIVAR32, 8 dump

use16 .( use16 DIV) cr

here dl DIVAR8, 8 dump

here dx DIVAR16, 8 dump

here edx DIVAR32, 8 dump
