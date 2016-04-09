;******************************************************************************
;
;  fcontrol.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Flow control words
;******************************************************************************

;  6.1.1370 EXECUTE
                        $CODE   'EXECUTE',$EXECUTE

                        POPDS   EAX                     ; pop new IP from data stack
                        $JMP

;  EXECUTE-IP
;  S: token-addr --
;  Execute a list of tokens starting at token-addr.
                        $CODE   'EXECUTE-IP'
                        PUSHRS  ESI                     ; push current IP on return stack
                        POPDS   ESI                     ; pop new IP from data stack
                        $NEXT                           ; fetch next word address and execute it

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
                        POPRS   ECX                     ; ECX - i  - index
                        FETCHRS EBX                     ; EBX - l  - limit
                        POPDS   EDX                     ; EDX - ii - index increment
                        MOV     EAX,ECX
                        SUB     EAX,EBX                 ; EAX = t0 = i - l
                        XOR     EAX,EDX
                        JGE     SHORT PAL_NEXT          ; if (t0 ^ ii) >= 0
                        MOV     EAX,ECX
                        SUB     EAX,EBX                 ; EAX = t0 = i - l
                        MOV     EBX,EAX
                        ADD     EAX,EDX                 ; EBX = t0 + ii
                        XOR     EAX,EBX
                        JGE     SHORT PAL_NEXT          ; if (t0 ^ (t0 + ii)) >= 0
PAL_EXIT:
                        POPRS   EAX
                        POPRS   EAX
                        LODSD
                        $NEXT
PAL_NEXT:
                        ADD     ECX,EDX
                        PUSHRS  ECX                     ; current
                        LODSD
                        MOV     ESI,EAX
                        $NEXT
