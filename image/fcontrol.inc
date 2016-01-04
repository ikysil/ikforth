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

;  6.1.1760 LEAVE
                        $DEF    'LEAVE',$LEAVE,,VEF_COMPILE_ONLY
                        POPRS   EAX
                        POPRS   EAX
                        POPRS   ESI
                        $NEXT

;  6.1.1680 I
;  D: ( -- loop-index )
                        $DEF    'I',$I,,VEF_COMPILE_ONLY
                        FETCHRS EAX
                        PUSHDS  EAX
                        $NEXT

;  6.1.1730 J
;  D: ( -- outer-loop-index )
                        $DEF    'J',$J,,VEF_COMPILE_ONLY
                        FETCHRS EAX,3
                        PUSHDS  EAX
                        $NEXT                   

;  I'
;  D: ( -- loop-limit )
                        $DEF    'I''',$ITICK,,VEF_COMPILE_ONLY
                        FETCHRS EAX,1
                        PUSHDS  EAX
                        $NEXT

;  6.1.1370 EXECUTE
                        $DEF    'EXECUTE',$EXECUTE
                        POPDS   EAX                     ; pop new IP from data stack
                        $JMP

                        $DEF    '@EXECUTE',$FETCH_EXECUTE
                        POPDS   EAX
                        MOV     EAX,[DWORD PTR EAX]
                        $JMP

;******************************************************************************
;  Loop support words
;******************************************************************************
;  (DO)
                        $DEF    '(DO)',$PDO
                        LODSD
                        PUSHRS  EAX                     ; address for LEAVE
                        POPDS   EAX
                        POPDS   EBX
                        PUSHRS  EBX                     ; limit
                        PUSHRS  EAX                     ; current
                        $NEXT

;  (?DO)
                        $DEF    '(?DO)',$PQDO
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
                        $DEF    '(LOOP)',$PLOOP
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
                        $DEF    '(+LOOP)',$PADDLOOP
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

