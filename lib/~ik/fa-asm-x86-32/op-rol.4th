PURPOSE: x86 ROL – Rotate Left operation encoding
LICENSE: Unlicense since 1999 by Illya Kysil

\ ROL – Rotate Left

B# 00000000 CONSTANT SHIFTOP-ROL

ALUOP-SHIFT
SHIFTOP-ROL
SHIFT/R8: ROL/R8,

ALUOP-SHIFT
SHIFTOP-ROL
SHIFT/R16: ROL/R16,

ALUOP-SHIFT
SHIFTOP-ROL
SHIFT/R32: ROL/R32,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-ROL
SHIFT/R8: ROL/R8CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-ROL
SHIFT/R16: ROL/R16CL,

ALUOP-SHIFT SHIFT/CL
SHIFTOP-ROL
SHIFT/R32: ROL/R32CL,


ALUOP-SHIFT-IMM
SHIFTOP-ROL
SHIFT/R8I8: ROL/R8I8,

ALUOP-SHIFT-IMM
SHIFTOP-ROL
SHIFT/R16I8: ROL/R16I8,

ALUOP-SHIFT-IMM
SHIFTOP-ROL
SHIFT/R32I8: ROL/R32I8,


\ EOF

CR

use32 .( use32 ROL/1) cr

here dl ROL/R8, 8 dump

here dx ROL/R16, 8 dump

here edx ROL/R32, 8 dump

use16 .( use16 ROL/1) cr

here dl ROL/R8, 8 dump

here dx ROL/R16, 8 dump

here edx ROL/R32, 8 dump

use32 .( use32 ROL/CL) cr

here dl ROL/R8CL, 8 dump

here dx ROL/R16CL, 8 dump

here edx ROL/R32CL, 8 dump

use16 .( use16 ROL/CL) cr

here dl ROL/R8CL, 8 dump

here dx ROL/R16CL, 8 dump

here edx ROL/R32CL, 8 dump

use32 .( use32 ROL/IMM) cr

here dl h# 34 ROL/R8I8, 8 dump

here dx h# 34 ROL/R16I8, 8 dump

here edx h# 34 ROL/R32I8, 8 dump

use16 .( use16 ROL/IMM) cr

here dl h# 34 ROL/R8I8, 8 dump

here dx h# 34 ROL/R16I8, 8 dump

here edx h# 34 ROL/R32I8, 8 dump
