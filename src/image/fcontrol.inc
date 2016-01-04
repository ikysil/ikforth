;******************************************************************************
;
;  fcontrol.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Flow control words
;******************************************************************************

;  6.1.1370 EXECUTE
                        $CODE   'EXECUTE',$EXECUTE

                        POPDS   EAX                     ; pop new IP from data stack
                        $JMP

;******************************************************************************
;  Loop support words
;******************************************************************************

;  (?DO)
                        $CODE   '(?DO)'

                        LODSD
                        POPDS   ECX
                        POPDS   EBX
                        CMP     ECX,EBX
                        JZ      SHORT PQDO_EXIT
                        PUSHRS  EAX                     ; address for LEAVE
                        PUSHRS  EBX                     ; limit
                        PUSHRS  ECX                     ; current
                        $NEXT
PQDO_EXIT:
                        MOV     ESI,EAX
                        $NEXT

;  (LOOP)
                        $CODE   '(LOOP)'

                        LODSD
                        POPRS   ECX                     ; current
                        FETCHRS EBX                     ; limit
                        INC     ECX
                        CMP     ECX,EBX
                        JNZ     SHORT PLOOP_NOEQ
                        POPRS   EAX
                        POPRS   EAX
                        $NEXT
PLOOP_NOEQ:
                        PUSHRS  ECX                     ; current
                        MOV     ESI,EAX
                        $NEXT

;  (+LOOP)
                        $CODE   '(+LOOP)'

                        LODSD                           ; loop addr
                        POPDS   EDX                     ; loop index increment
                        POPRS   ECX                     ; current
                        FETCHRS EBX                     ; limit
                        SUB     EBX,ECX
                        OR      EDX,EDX
                        JS      PADDLOOP_NEGATIVE       ; jump if increment is negative
                        CMP     EBX,EDX
                        JLE     SHORT PADDLOOP_LOOP_EXIT
PADDLOOP_LOOP_CONT:
                        ADD     ECX,EDX
                        PUSHRS  ECX                     ; current
                        MOV     ESI,EAX
                        $NEXT
PADDLOOP_LOOP_EXIT:
                        POPRS   EAX
                        POPRS   EAX
                        $NEXT

PADDLOOP_NEGATIVE:
                        CMP     EBX,EDX
                        JG      SHORT PADDLOOP_LOOP_EXIT
                        JMP     SHORT PADDLOOP_LOOP_CONT

