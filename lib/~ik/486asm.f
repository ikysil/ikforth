\
\  486asm.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  Definitions needed to load Jim Schneider's 486asm.f under IKForth
\

CR .( Loading 486ASM definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS ALSO ASSEMBLER DEFINITIONS

: NOOP ;

VARIABLE CSP

: !CSP          ( -- )  \ save current stack pointer for later stack depth check
                SP@ CSP ! ;

: ?CSP          ( -- )  \ check current stack pointer against saved stack pointer
                SP@ CSP @ XOR ABORT" stack changed" ;

: COMPILE R> DUP @ SWAP CELL+ >R COMPILE, ;

DEFER ENTER-ASSEMBLER   ' NOOP IS ENTER-ASSEMBLER
DEFER EXIT-ASSEMBLER    ' NOOP IS EXIT-ASSEMBLER

: DEFER@
  ' STATE @ IF POSTPONE LITERAL POSTPONE DEFER@ ELSE DEFER@ THEN ; IMMEDIATE

REQUIRES" lib/~js/486asm/486ASM.F"

ALSO ASSEMBLER ALSO ASM-HIDDEN DEFINITIONS

:NONAME ( start a native code definition )
  code-header 0 (CFA,) hide !csp init-asm
; IS CODE

HOST-ITC? [IF]

MACRO: JMP-NEXT
  MOV     EBX , [EAX]
  JMP     EBX
ENDM

[THEN]

HOST-DTC? [IF]

MACRO: JMP-NEXT
  MOV     EBX , EAX
  JMP     EBX
ENDM

[THEN]

\  Last word in CODE definitions
MACRO: NEXT
  LODSD
  JMP-NEXT
ENDM

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
