PURPOSE: x86 BTC – Bit Test and Complement operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BTC – Bit Test and Complement

: BTCR, (S ra rb -- )
   \G Compile operation BTC ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10111011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BTCR16, (S r16a r16b -- )
   \G Compile operation BTC r16a, r16b.
   ?OP16,
   BTCR,
;

: BTCR32, (S r32a r32b -- )
   \G Compile operation BTC r32a, r32b.
   ?OP32,
   BTCR,
;

\ EOF

CR

use32 .( use32 BTC) cr

here cx dx BTCR16, 8 dump

here ecx edx BTCR32, 8 dump

use16 .( use16 BTC) cr

here cx dx BTCR16, 8 dump

here ecx edx BTCR32, 8 dump
