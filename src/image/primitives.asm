;******************************************************************************
;
;  primitives.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
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

;  (DO-CREATE)
                        $CREATE '(DO-CREATE)'
                        LABEL   CFA_$DOCREATE
                        ADD     EAX,CFA_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-VARIABLE)
                        $CREATE '(DO-VARIABLE)'
                        LABEL   CFA_$DOVAR
                        ADD     EAX,CFA_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-:)
                        $CREATE '(DO-:)'
                        LABEL   CFA_$ENTER
                        PUSHRS  ESI                     ; push current IP on return stack
                        ADD     EAX,CFA_SIZE
                        MOV     ESI,EAX
                        $NEXT                           ; fetch next word address and execute it

;  (;)
                        $CODE   '(;)',$END_COLON,VEF_COMPILE_ONLY
                        POPRS   ESI                     ; pop previous IP from return stack
                        $NEXT

;  (DO-CONSTANT)
                        $CREATE '(DO-CONSTANT)'
                        LABEL   CFA_$DOCONST
                        PUSHDS  <DWORD [EAX + CFA_SIZE]>
                        $NEXT

;  (DO-USER)
                        $CREATE '(DO-USER)'
                        LABEL   CFA_$DOUSER
                        MOV     EBX,DWORD [EAX + CFA_SIZE]
                        ADD     EBX,EDI
                        PUSHDS  EBX
                        $NEXT

;  (DO-DEFER)
                        $CREATE '(DO-DEFER)'
                        LABEL   CFA_$DODEFER
                        MOV     DWORD [EDI + VAR_DEFER_XT],EAX
                        MOV     EAX,DWORD [EAX + CFA_SIZE]
                        $JMP

;  (DO-VALUE)
                $CREATE     '(DO-VALUE)'
                LABEL       CFA_$DOVALUE
                PUSHDS      <DWORD [EAX + CFA_SIZE + CELL_SIZE]> ; first cell in VALUE body is reserved for VT
                $NEXT

;  (DO-INT/COMP)
                $CREATE     '(DO-INT/COMP)'
                LABEL       CFA_$PDO_INT_COMP
                ADD         EAX,CFA_SIZE
                CMP         BYTE [VAR_STATE + IMAGE_BASE],F_FALSE
                JZ          PDIC_INT
                ADD         EAX,CELL_SIZE
PDIC_INT:
                MOV         EAX,DWORD [EAX]
                $JMP
