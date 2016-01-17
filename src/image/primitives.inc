;******************************************************************************
;
;  primitives.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
;
;******************************************************************************
;  Primitives
;******************************************************************************

;  (BRKP)
                        $CODE   '(BRKP)',$PBRKPP

                        $NEXT

;  ?BRANCH
;  Branch to address compiled next if flag on stack is zero
;  D: flag --
                        $CODE   '?BRANCH',$QBRANCH

                        POPDS   EAX
                        OR      EAX,EAX
                        LODSD
                        JNZ     SHORT NOQBRANCH
                        MOV     ESI,EAX
NOQBRANCH:
                        $NEXT

;  BRANCH
;  Branch to address compiled next
                        $CODE   'BRANCH',$BRANCH

                        LODSD
                        MOV     ESI,EAX
                        $NEXT

;  LIT
;  Compiled by LITERAL
                        $CODE   'LIT',$LIT

                        LODSD
                        PUSHDS  EAX
                        $NEXT

;  2LIT
;  Compiled by 2LITERAL
                        $CODE   '2LIT',$2LIT

                        LODSD
                        PUSHDS  EAX
                        LODSD
                        PUSHDS  EAX
                        $NEXT

;  (DO-VARIABLE)
                        $VAR    '(DO-VARIABLE)'

                        LABEL   CW_$DOVAR
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-:)
                        $VAR    '(DO-:)'

                        LABEL   CW_$ENTER
                        PUSHRS  ESI                     ; push current IP on return stack
                        ADD     EAX,CELL_SIZE
                        MOV     ESI,EAX
                        $NEXT                           ; fetch next word address and execute it

;  (DO-CONSTANT)
                        $VAR    '(DO-CONSTANT)'

                        LABEL   CW_$DOCONST
                        PUSHDS  <DWORD [EAX + CELL_SIZE]>
                        $NEXT

;  (DO-USER)
                        $VAR    '(DO-USER)'

                        LABEL   CW_$DOUSER
                        MOV     EBX,DWORD [EAX + CELL_SIZE]
                        ADD     EBX,EDI
                        PUSHDS  EBX
                        $NEXT

;  (DO-DEFER)
                        $VAR    '(DO-DEFER)'

                        LABEL   CW_$DODEFER
                        MOV     EAX,DWORD [EAX + CELL_SIZE]
                        $JMP

;  (DO-INT/COMP)
                        $VAR    '(DO-INT/COMP)'

                        LABEL   CW_$PDO_INT_COMP
                        ADD     EAX,CELL_SIZE
                        CMP     BYTE [VAR_STATE + IMAGE_BASE],F_FALSE
                        JZ      PDIC_INT
                        ADD     EAX,CELL_SIZE
PDIC_INT:
                        MOV     EAX,DWORD [EAX]
                        $JMP

