PURPOSE: x86 SAL – Shift Arithmetic Left operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ SAL – Shift Arithmetic Left same instruction as SHL

B# 00100000 CONSTANT SHIFTOP-SAL

ALUOP-SHIFT
SHIFTOP-SAL
SHIFT/R8: SAL/R8,

ALUOP-SHIFT
SHIFTOP-SAL
SHIFT/R16: SAL/R16,

ALUOP-SHIFT
SHIFTOP-SAL
SHIFT/R32: SAL/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SAL
SHIFT/R8: SAL/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SAL
SHIFT/R16: SAL/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-SAL
SHIFT/R32: SAL/R32CL,

\ EOF

CR

use32 .( use32 SAL/1) cr

here dl SAL/R8, 8 dump

here dx SAL/R16, 8 dump

here edx SAL/R32, 8 dump

use16 .( use16 SAL/1) cr

here dl SAL/R8, 8 dump

here dx SAL/R16, 8 dump

here edx SAL/R32, 8 dump

use32 .( use32 SAL/CL) cr

here dl SAL/R8CL, 8 dump

here dx SAL/R16CL, 8 dump

here edx SAL/R32CL, 8 dump

use16 .( use16 SAL/CL) cr

here dl SAL/R8CL, 8 dump

here dx SAL/R16CL, 8 dump

here edx SAL/R32CL, 8 dump
