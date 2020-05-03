PURPOSE: x86 BTC/RR – Bit Test and Complement operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BTC – Bit Test and Complement

: BTC/RR, (S ra rb -- )
   \G Compile operation BTC ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10111011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BTC/RR16, (S r16a r16b -- )
   \G Compile operation BTC r16a, r16b.
   ?OP16,
   BTC/RR,
;

: BTC/RR32, (S r32a r32b -- )
   \G Compile operation BTC r32a, r32b.
   ?OP32,
   BTC/RR,
;


: BTC/RI8, (S r imm8 -- )
   \G Compile operation BTC r, imm8 without operand size prefix.
   B# 00001111 ASM8,
   B# 10111010 ASM8,
   SWAP B# 11111000 OR ASM8,
   ASM8,
;

: BTC/R16I8, (S r16 imm8 -- )
   \G Compile operation BTC r16, imm8.
   ?OP16,
   BTC/RI8,
;

: BTC/R32I8, (S r32 imm8 -- )
   \G Compile operation BTC r32, imm8.
   ?OP32,
   BTC/RI8,
;


\ EOF

CR

use32 .( use32 BTC) cr

here cx dx BTC/RR16, 8 dump

here ecx edx BTC/RR32, 8 dump

here cx h# 56 BTC/R16I8, 8 dump

here ecx h# 56 BTC/R32I8, 8 dump

use16 .( use16 BTC) cr

here cx dx BTC/RR16, 8 dump

here ecx edx BTC/RR32, 8 dump

here cx h# 56 BTC/R16I8, 8 dump

here ecx h# 56 BTC/R32I8, 8 dump
