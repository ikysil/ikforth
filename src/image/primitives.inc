;******************************************************************************
;
;  primitives.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Primitives
;******************************************************************************

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
                 $DOVAR LABEL   FAR
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-:)
                        $VAR    '(DO-:)'
                 $ENTER LABEL   FAR
                        PUSHRS  ESI                     ; push current IP on return stack
                        ADD     EAX,CELL_SIZE
                        MOV     ESI,EAX
                        $NEXT                           ; fetch next word address and execute it

;  (DO-CONSTANT)
                        $VAR    '(DO-CONSTANT)'
               $DOCONST LABEL   FAR
                        PUSHDS  [EAX + CELL_SIZE]
                        $NEXT

;  (DO-USER)
                        $VAR    '(DO-USER)'
                $DOUSER LABEL   FAR
                        MOV     EBX,DWORD PTR [EAX + CELL_SIZE]
                        ADD     EBX,EDI
                        PUSHDS  EBX
                        $NEXT

;  (DO-DEFER)
                        $VAR    '(DO-DEFER)'
               $DODEFER LABEL   FAR
                        MOV     EAX,DWORD PTR [EAX + CELL_SIZE]
                        $JMP

;  (DO-INT/COMP)
                        $VAR    '(DO-INT/COMP)'
          $PDO_INT_COMP LABEL   FAR
                        ADD     EAX,CELL_SIZE
                        CMP     BYTE PTR [STATE_VAR - SIGN + DESIRED_BASE_EQU],F_FALSE
                        JZ      PDIC_INT
                        ADD     EAX,CELL_SIZE
PDIC_INT:
                        MOV     EAX,DWORD PTR [EAX]
                        $JMP

