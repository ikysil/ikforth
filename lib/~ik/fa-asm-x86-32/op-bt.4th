PURPOSE: x86 BT – Bit Test operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ BT – Bit Test

: BT/RR, (S ra rb -- )
   \G Compile operation BT ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10100011 ASM8,
   3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: BT/RR16, (S r16a r16b -- )
   \G Compile operation BT r16a, r16b.
   ?OP16,
   BT/RR,
;

: BT/RR32, (S r32a r32b -- )
   \G Compile operation BT r32a, r32b.
   ?OP32,
   BT/RR,
;


: BT/RI8, (S r imm8 -- )
   \G Compile operation BT r, imm8 without operand size prefix.
   B# 00001111 ASM8,
   B# 10111010 ASM8,
   SWAP B# 11100000 OR ASM8,
   ASM8,
;

: BT/R16I8, (S r16 imm8 -- )
   \G Compile operation BT r16, imm8.
   ?OP16,
   BT/RI8,
;

: BT/R32I8, (S r32 imm8 -- )
   \G Compile operation BT r32, imm8.
   ?OP32,
   BT/RI8,
;


\ EOF

CR

use32 .( use32 BT) cr

here cx dx BT/RR16, 8 dump

here ecx edx BT/RR32, 8 dump

here cx h# 56 BT/R16I8, 8 dump

here ecx h# 56 BT/R32I8, 8 dump

use16 .( use16 BT) cr

here cx dx BT/RR16, 8 dump

here ecx edx BT/RR32, 8 dump

here cx h# 56 BT/R16I8, 8 dump

here ecx h# 56 BT/R32I8, 8 dump
