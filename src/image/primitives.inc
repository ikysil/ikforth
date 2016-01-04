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
                        LABEL   $DOVAR FAR
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  (DO-:)
                        $VAR    '(DO-:)'
                        LABEL   $ENTER FAR
                        PUSHRS  ESI                     ; push current IP on return stack
                        ADD     EAX,CELL_SIZE
                        MOV     ESI,EAX
                        $NEXT                           ; fetch next word address and execute it

;  (DO-CONSTANT)
                        $VAR    '(DO-CONSTANT)'
                        LABEL   $DOCONST FAR
                        PUSHDS  <[DWORD PTR EAX + CELL_SIZE]>
                        $NEXT

;  (DO-USER)
                        $VAR    '(DO-USER)'
                        LABEL   $DOUSER FAR
                        MOV     EBX,[DWORD PTR EAX + CELL_SIZE]
                        ADD     EBX,EDI
                        PUSHDS  EBX
                        $NEXT

;  (DO-DEFER)
                        $VAR    '(DO-DEFER)'
                        LABEL   $DODEFER FAR
                        MOV     EAX,[DWORD PTR EAX + CELL_SIZE]
                        $JMP

;  (DO-INT/COMP)
                        $VAR    '(DO-INT/COMP)'
                        LABEL   $PDO_INT_COMP FAR
                        ADD     EAX,CELL_SIZE
                        CMP     [DWORD PTR STATE_VAR + DESIRED_BASE_EQU],F_FALSE
                        JZ      SHORT PDIC_INT
                        ADD     EAX,CELL_SIZE
PDIC_INT:
                        MOV     EAX,[DWORD PTR EAX]
                        $JMP

