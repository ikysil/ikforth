PURPOSE: x86 BTS – Bit Test and Set operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BTS – Bit Test and Set

: BTS/RR, (S ra rb -- )
   \G Compile operation BTS ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10101011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BTS/RR16, (S r16a r16b -- )
   \G Compile operation BTS r16a, r16b.
   ?OP16,
   BTS/RR,
;

: BTS/RR32, (S r32a r32b -- )
   \G Compile operation BTS r32a, r32b.
   ?OP32,
   BTS/RR,
;


: BTS/RI8, (S r imm8 -- )
   \G Compile operation BTS r, imm8 without operand size prefix.
   B# 00001111 ASM8,
   B# 10111010 ASM8,
   SWAP B# 11101000 OR ASM8,
   ASM8,
;

: BTS/R16I8, (S r16 imm8 -- )
   \G Compile operation BTS r16, imm8.
   ?OP16,
   BTS/RI8,
;

: BTS/R32I8, (S r32 imm8 -- )
   \G Compile operation BTS r32, imm8.
   ?OP32,
   BTS/RI8,
;


\ EOF

CR

use32 .( use32 BTS) cr

here cx dx BTS/RR16, 8 dump

here ecx edx BTS/RR32, 8 dump

here cx h# 56 BTS/R16I8, 8 dump

here ecx h# 56 BTS/R32I8, 8 dump

use16 .( use16 BTS) cr

here cx dx BTS/RR16, 8 dump

here ecx edx BTS/RR32, 8 dump

here cx h# 56 BTS/R16I8, 8 dump

here ecx h# 56 BTS/R32I8, 8 dump
