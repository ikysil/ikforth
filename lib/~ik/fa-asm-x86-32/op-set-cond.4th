PURPOSE: x86 SETcc – Byte Set on Condition operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SETcc – Byte Set on Condition

: SETR8?, (S reg8 condition -- )
   \G Compile operation SETcc reg.
   B# 00001111 ASM8,
   B# 10010000 OR ASM8,
   B# 11000000 OR ASM8,
;

\ EOF

CR

.( use32 SETR8?,) cr

here dl ?A SETR8?, 8 dump

here dl ?NLE SETR8?, 8 dump
