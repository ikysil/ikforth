PURPOSE: x86 NOP – No Operation operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ NOP – No Operation
B# 10010000
   I1B:  NOP,

\ NOP – Multi-byte No Operation 1

: NOP/R16, (S r16 -- )
   \G Compile operation NOP r16.
   B# 00001111 ASM8,
   B# 00011111 ASM8,
   B# 11000000 OR ASM8,
;

SYNONYM NOP/R32, NOP/R16,
\G Compile operation NOP r32.

\ EOF

CR

use32 .( use32 NOP) cr

here NOP, 8 dump

here dx NOP/R16, 8 dump

here edx NOP/R32, 8 dump

use16 .( use16 NOP) cr

here NOP, 8 dump

here dx NOP/R16, 8 dump

here edx NOP/R32, 8 dump
