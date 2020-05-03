PURPOSE: x86 RCR – Rotate thru Carry Right operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ RCR – Rotate thru Carry Right

B# 00011000 CONSTANT SHIFTOP-RCR

ALUOP-SHIFT
SHIFTOP-RCR
SHIFT/R8: RCR/R8,

ALUOP-SHIFT
SHIFTOP-RCR
SHIFT/R16: RCR/R16,

ALUOP-SHIFT
SHIFTOP-RCR
SHIFT/R32: RCR/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-RCR
SHIFT/R8: RCR/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-RCR
SHIFT/R16: RCR/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-RCR
SHIFT/R32: RCR/R32CL,


ALUOP-SHIFT-IMM
SHIFTOP-RCR
SHIFT/R8I8: RCR/R8I8,

ALUOP-SHIFT-IMM
SHIFTOP-RCR
SHIFT/R16I8: RCR/R16I8,

ALUOP-SHIFT-IMM
SHIFTOP-RCR
SHIFT/R32I8: RCR/R32I8,


\ EOF

CR

use32 .( use32 RCR/1) cr

here dl RCR/R8, 8 dump

here dx RCR/R16, 8 dump

here edx RCR/R32, 8 dump

use16 .( use16 RCR/1) cr

here dl RCR/R8, 8 dump

here dx RCR/R16, 8 dump

here edx RCR/R32, 8 dump

use32 .( use32 RCR/CL) cr

here dl RCR/R8CL, 8 dump

here dx RCR/R16CL, 8 dump

here edx RCR/R32CL, 8 dump

use16 .( use16 RCR/CL) cr

here dl RCR/R8CL, 8 dump

here dx RCR/R16CL, 8 dump

here edx RCR/R32CL, 8 dump

use32 .( use32 RCR/IMM) cr

here dl h# 34 RCR/R8I8, 8 dump

here dx h# 34 RCR/R16I8, 8 dump

here edx h# 34 RCR/R32I8, 8 dump

use16 .( use16 RCR/IMM) cr

here dl h# 34 RCR/R8I8, 8 dump

here dx h# 34 RCR/R16I8, 8 dump

here edx h# 34 RCR/R32I8, 8 dump
