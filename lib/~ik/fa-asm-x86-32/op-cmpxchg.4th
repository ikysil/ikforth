PURPOSE: x86 CMPXCHG – Compare and Exchange operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ CMPXCHG – Compare and Exchange

: CMPXCHG/RR8, (S r8a r8b -- )
   \G Compile operation CMPXCHG r8a, r8b.
   B# 00001111 ASM8,
   B# 10110000 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: CMPXCHG/RR, (S ra rb -- )
   \G Compile operation CMPXCHG ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10110001 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: CMPXCHG/RR16, (S r16a r16b -- )
   \G Compile operation CMPXCHG r16a, r16b.
   ?OP16,
   CMPXCHG/RR,
;

: CMPXCHG/RR32, (S r32a r32b -- )
   \G Compile operation CMPXCHG r32a, r32b.
   ?OP32,
   CMPXCHG/RR,
;

\ EOF

CR

use32 .( use32 CMPXCHG) cr

here ch bl CMPXCHG/RR8, 8 dump

here cx dx CMPXCHG/RR16, 8 dump

here ecx edx CMPXCHG/RR32, 8 dump

use16 .( use16 CMPXCHG) cr

here ch bl CMPXCHG/RR8, 8 dump

here cx dx CMPXCHG/RR16, 8 dump

here ecx edx CMPXCHG/RR32, 8 dump
