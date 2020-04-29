PURPOSE: x86 MOVZX – Move with Zero-Extend operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ MOVZX – Move with Zero-Extend

: MOVZX/RR8, (S ra rb -- )
   \G Compile operation MOVZX ra, rb without operand size prefix.
   B# 00001111 ASM8,
   B# 10110110 ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR ASM8,
;

: MOVZX/R16R8, (S r16 r8 -- )
   \G Compile operation MOVZX r16, r8.
   ?OP16,
   MOVZX/RR8,
;

: MOVZX/R32R8, (S r32 r8 -- )
   \G Compile operation MOVZX r32, r8.
   ?OP32,
   MOVZX/RR8,
;

: MOVZX/R32R16, (S r32 r16 -- )
   \G Compile operation MOVZX r32, r16.
   ?OP32,
   B# 00001111 ASM8,
   B# 10110111 ASM8,
   SWAP 3 LSHIFT OR
   B# 11000000 OR ASM8,
;

\ EOF

CR

use32 .( use32 MOVZX) cr

here cx dh MOVZX/R16R8, 8 dump

here ecx dh MOVZX/R32R8, 8 dump

here ebx dh MOVZX/R32R16, 8 dump

use16 .( use16 MOVZX) cr

here cx dh MOVZX/R16R8, 8 dump

here ecx dh MOVZX/R32R8, 8 dump

here ebx dh MOVZX/R32R16, 8 dump
