PURPOSE: x86 ROR – Rotate Right operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ ROR – Rotate Right

B# 00001000 CONSTANT SHIFTOP-ROR

ALUOP-SHIFT
SHIFTOP-ROR
SHIFT/R8: ROR/R8,

ALUOP-SHIFT
SHIFTOP-ROR
SHIFT/R16: ROR/R16,

ALUOP-SHIFT
SHIFTOP-ROR
SHIFT/R32: ROR/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-ROR
SHIFT/R8: ROR/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-ROR
SHIFT/R16: ROR/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-ROR
SHIFT/R32: ROR/R32CL,


ALUOP-SHIFT-IMM
SHIFTOP-ROR
SHIFT/R8I8: ROR/R8I8,

ALUOP-SHIFT-IMM
SHIFTOP-ROR
SHIFT/R16I8: ROR/R16I8,

ALUOP-SHIFT-IMM
SHIFTOP-ROR
SHIFT/R32I8: ROR/R32I8,


\ EOF

CR

use32 .( use32 ROR/1) cr

here dl ROR/R8, 8 dump

here dx ROR/R16, 8 dump

here edx ROR/R32, 8 dump

use16 .( use16 ROR/1) cr

here dl ROR/R8, 8 dump

here dx ROR/R16, 8 dump

here edx ROR/R32, 8 dump

use32 .( use32 ROR/CL) cr

here dl ROR/R8CL, 8 dump

here dx ROR/R16CL, 8 dump

here edx ROR/R32CL, 8 dump

use16 .( use16 ROR/CL) cr

here dl ROR/R8CL, 8 dump

here dx ROR/R16CL, 8 dump

here edx ROR/R32CL, 8 dump

use32 .( use32 ROR/IMM) cr

here dl h# 34 ROR/R8I8, 8 dump

here dx h# 34 ROR/R16I8, 8 dump

here edx h# 34 ROR/R32I8, 8 dump

use16 .( use16 ROR/IMM) cr

here dl h# 34 ROR/R8I8, 8 dump

here dx h# 34 ROR/R16I8, 8 dump

here edx h# 34 ROR/R32I8, 8 dump
