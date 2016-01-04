;******************************************************************************
;
;  primitives.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Primitives
;******************************************************************************

;  ?BRANCH
;  Branch to address compiled next if flag on stack is zero
;  D: flag --
                        $DEF    '?BRANCH',$QBRANCH
                        POPDS   EAX
                        OR      EAX,EAX
                        LODSD
                        JNZ     SHORT NOQBRANCH
                        MOV     ESI,EAX
NOQBRANCH:
                        $NEXT

;  BRANCH
;  Branch to address compiled next
                        $DEF    'BRANCH',$BRANCH
                        LODSD
                        MOV     ESI,EAX
                        $NEXT

;  LIT
;  Compiled by LITERAL
                        $DEF    'LIT',$LIT
                        LODSD
                        PUSHDS  EAX
                        $NEXT

;  2LIT
;  Compiled by 2LITERAL
                        $DEF    '2LIT',$2LIT
                        LODSD
                        PUSHDS  EAX
                        LODSD
                        PUSHDS  EAX
                        $NEXT

;  (DO-VARIABLE)
                        $DEF    '(DO-VARIABLE)',,$DOVAR
                        LABEL   $DOVAR FAR
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-:)
                        $DEF    '(DO-:)',,$DOVAR
                        LABEL   $ENTER FAR
                        PUSHRS  ESI                     ; push current IP on return stack
                        ADD     EAX,CELL_SIZE
                        MOV     ESI,EAX
                        $NEXT                           ; fetch next word address and execute it

;  (DO-CREATE)
                        $DEF    '(DO-CREATE)',,$DOVAR
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-CONSTANT)
                        $DEF    '(DO-CONSTANT)',,$DOVAR
                        LABEL   $DOCONST FAR
                        PUSHDS  <[DWORD PTR EAX + CELL_SIZE]>
                        $NEXT

;  (DO-USER)
                        $DEF    '(DO-USER)',,$DOVAR
                        LABEL   $DOUSER FAR
                        MOV     EBX,[DWORD PTR EAX + CELL_SIZE]
                        ADD     EBX,EDI
                        PUSHDS  EBX
                        $NEXT

;  (DO-DEFER)
                        $DEF    '(DO-DEFER)',,$DOVAR
                        LABEL   $DODEFER FAR
                        MOV     EAX,[DWORD PTR EAX + CELL_SIZE]
                        $JMP

;  (DO-INT/COMP)
                        $DEF    '(DO-INT/COMP)',,$DOVAR
                        LABEL   $PDO_INT_COMP FAR
                        ADD     EAX,CELL_SIZE
                        CMP     [DWORD PTR EDI + STATE_VAR],FALSE
                        JZ      PDIC_INT
                        ADD     EAX,CELL_SIZE
PDIC_INT:
                        MOV     EAX,[DWORD PTR EAX]
                        $JMP
