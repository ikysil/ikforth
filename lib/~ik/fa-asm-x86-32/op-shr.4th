PURPOSE: x86 SHR – Shift Right operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SHR – Shift Right

B# 00101000 CONSTANT SHIFTOP-SHR

ALUOP-SHIFT
SHIFTOP-SHR
SHIFT/R8: SHR/R8,

ALUOP-SHIFT
SHIFTOP-SHR
SHIFT/R16: SHR/R16,

ALUOP-SHIFT
SHIFTOP-SHR
SHIFT/R32: SHR/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SHR
SHIFT/R8: SHR/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SHR
SHIFT/R16: SHR/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SHR
SHIFT/R32: SHR/R32CL,


ALUOP-SHIFT-IMM
SHIFTOP-SHR
SHIFT/R8I8: SHR/R8I8,

ALUOP-SHIFT-IMM
SHIFTOP-SHR
SHIFT/R16I8: SHR/R16I8,

ALUOP-SHIFT-IMM
SHIFTOP-SHR
SHIFT/R32I8: SHR/R32I8,


\ EOF

CR

use32 .( use32 SHR/1) cr

here dl SHR/R8, 8 dump

here dx SHR/R16, 8 dump

here edx SHR/R32, 8 dump

use16 .( use16 SHR/1) cr

here dl SHR/R8, 8 dump

here dx SHR/R16, 8 dump

here edx SHR/R32, 8 dump

use32 .( use32 SHR/CL) cr

here dl SHR/R8CL, 8 dump

here dx SHR/R16CL, 8 dump

here edx SHR/R32CL, 8 dump

use16 .( use16 SHR/CL) cr

here dl SHR/R8CL, 8 dump

here dx SHR/R16CL, 8 dump

here edx SHR/R32CL, 8 dump

use32 .( use32 SHR/IMM) cr

here dl h# 34 SHR/R8I8, 8 dump

here dx h# 34 SHR/R16I8, 8 dump

here edx h# 34 SHR/R32I8, 8 dump

use16 .( use16 SHR/IMM) cr

here dl h# 34 SHR/R8I8, 8 dump

here dx h# 34 SHR/R16I8, 8 dump

here edx h# 34 SHR/R32I8, 8 dump
