PURPOSE: x86 SAR – Shift Arithmetic Right operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SAR – Shift Arithmetic Right

B# 00111000 CONSTANT SHIFTOP-SAR

ALUOP-SHIFT
SHIFTOP-SAR
SHIFT/R8: SAR/R8,

ALUOP-SHIFT
SHIFTOP-SAR
SHIFT/R16: SAR/R16,

ALUOP-SHIFT
SHIFTOP-SAR
SHIFT/R32: SAR/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SAR
SHIFT/R8: SAR/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SAR
SHIFT/R16: SAR/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SAR
SHIFT/R32: SAR/R32CL,


ALUOP-SHIFT-IMM
SHIFTOP-SAR
SHIFT/R8I8: SAR/R8I8,

ALUOP-SHIFT-IMM
SHIFTOP-SAR
SHIFT/R16I8: SAR/R16I8,

ALUOP-SHIFT-IMM
SHIFTOP-SAR
SHIFT/R32I8: SAR/R32I8,


\ EOF

CR

use32 .( use32 SAR/1) cr

here dl SAR/R8, 8 dump

here dx SAR/R16, 8 dump

here edx SAR/R32, 8 dump

use16 .( use16 SAR/1) cr

here dl SAR/R8, 8 dump

here dx SAR/R16, 8 dump

here edx SAR/R32, 8 dump

use32 .( use32 SAR/CL) cr

here dl SAR/R8CL, 8 dump

here dx SAR/R16CL, 8 dump

here edx SAR/R32CL, 8 dump

use16 .( use16 SAR/CL) cr

here dl SAR/R8CL, 8 dump

here dx SAR/R16CL, 8 dump

here edx SAR/R32CL, 8 dump

use32 .( use32 SAR/IMM) cr

here dl h# 34 SAR/R8I8, 8 dump

here dx h# 34 SAR/R16I8, 8 dump

here edx h# 34 SAR/R32I8, 8 dump

use16 .( use16 SAR/IMM) cr

here dl h# 34 SAR/R8I8, 8 dump

here dx h# 34 SAR/R16I8, 8 dump

here edx h# 34 SAR/R32I8, 8 dump
