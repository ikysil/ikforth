PURPOSE: x86 SHL – Shift Left operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SHL – Shift Left

B# 00100000 CONSTANT SHIFTOP-SHL

ALUOP-SHIFT
SHIFTOP-SHL
SHIFT/R8: SHL/R8,

ALUOP-SHIFT
SHIFTOP-SHL
SHIFT/R16: SHL/R16,

ALUOP-SHIFT
SHIFTOP-SHL
SHIFT/R32: SHL/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SHL
SHIFT/R8: SHL/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SHL
SHIFT/R16: SHL/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SHL
SHIFT/R32: SHL/R32CL,


ALUOP-SHIFT-IMM
SHIFTOP-SHL
SHIFT/R8I8: SHL/R8I8,

ALUOP-SHIFT-IMM
SHIFTOP-SHL
SHIFT/R16I8: SHL/R16I8,

ALUOP-SHIFT-IMM
SHIFTOP-SHL
SHIFT/R32I8: SHL/R32I8,


\ EOF

CR

use32 .( use32 SHL/1) cr

here dl SHL/R8, 8 dump

here dx SHL/R16, 8 dump

here edx SHL/R32, 8 dump

use16 .( use16 SHL/1) cr

here dl SHL/R8, 8 dump

here dx SHL/R16, 8 dump

here edx SHL/R32, 8 dump

use32 .( use32 SHL/CL) cr

here dl SHL/R8CL, 8 dump

here dx SHL/R16CL, 8 dump

here edx SHL/R32CL, 8 dump

use16 .( use16 SHL/CL) cr

here dl SHL/R8CL, 8 dump

here dx SHL/R16CL, 8 dump

here edx SHL/R32CL, 8 dump

use32 .( use32 SHL/IMM) cr

here dl h# 34 SHL/R8I8, 8 dump

here dx h# 34 SHL/R16I8, 8 dump

here edx h# 34 SHL/R32I8, 8 dump

use16 .( use16 SHL/IMM) cr

here dl h# 34 SHL/R8I8, 8 dump

here dx h# 34 SHL/R16I8, 8 dump

here edx h# 34 SHL/R32I8, 8 dump
