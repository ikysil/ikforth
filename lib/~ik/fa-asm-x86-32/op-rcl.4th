PURPOSE: x86 RCL – Rotate thru Carry Left operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ RCL – Rotate thru Carry Left

B# 00010000 CONSTANT SHIFTOP-RCL

ALUOP-SHIFT
SHIFTOP-RCL
SHIFT/R8: RCL/R8,

ALUOP-SHIFT
SHIFTOP-RCL
SHIFT/R16: RCL/R16,

ALUOP-SHIFT
SHIFTOP-RCL
SHIFT/R32: RCL/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-RCL
SHIFT/R8: RCL/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-RCL
SHIFT/R16: RCL/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-RCL
SHIFT/R32: RCL/R32CL,

\ EOF

CR

use32 .( use32 RCL/1) cr

here dl RCL/R8, 8 dump

here dx RCL/R16, 8 dump

here edx RCL/R32, 8 dump

use16 .( use16 RCL/1) cr

here dl RCL/R8, 8 dump

here dx RCL/R16, 8 dump

here edx RCL/R32, 8 dump

use32 .( use32 RCL/CL) cr

here dl RCL/R8CL, 8 dump

here dx RCL/R16CL, 8 dump

here edx RCL/R32CL, 8 dump

use16 .( use16 RCL/CL) cr

here dl RCL/R8CL, 8 dump

here dx RCL/R16CL, 8 dump

here edx RCL/R32CL, 8 dump
