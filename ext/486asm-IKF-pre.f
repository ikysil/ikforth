\
\  486asm-IKF.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\
\  Definitions needed to load Jim Schneider's 486asm.f under IKForth
\

CR .( Loading 486ASM definitions )

: NOOP ;

VARIABLE CSP

: !CSP          ( -- )  \ save current stack pointer for later stack depth check
                SP@ CSP ! ;

: ?CSP          ( -- )  \ check current stack pointer against saved stack pointer
                SP@ CSP @ XOR ABORT" stack changed" ;

: COMPILE R> DUP @ SWAP CELL+ >R COMPILE, ;

DEFER ENTER-ASSEMBLER   ' NOOP IS ENTER-ASSEMBLER
DEFER EXIT-ASSEMBLER    ' NOOP IS EXIT-ASSEMBLER
