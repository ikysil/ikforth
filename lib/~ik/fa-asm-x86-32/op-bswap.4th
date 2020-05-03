PURPOSE: x86 BSWAP – Byte Swap operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BSWAP – Byte Swap

: BSWAP/R32, (S r32 -- )
   \G Compile operation BSWAP r32.
   ?OP32,
   B# 00001111 ASM8,
   B# 11001000 OR ASM8,
;

\ EOF

CR

use32 .( use32 BSWAP) cr

here edx BSWAP/R32, 8 dump

use16 .( use16 BSWAP) cr

here edx BSWAP/R32, 8 dump
