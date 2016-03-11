;******************************************************************************
;
;  call-ffl.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Words for calling functions implemented in foreign languages
;******************************************************************************

; CALL-STDCALL-R0 (S addr -- )
; (G Call a procedure at addr with an STDCALL calling convention and no return value )
                        $CODE   'CALL-STDCALL-R0'
                        PUSHRS  EDI
                        POP     EBX
                        CALL    EBX
                        POPRS   EDI
                        $NEXT

; CALL-STDCALL-R1 (S addr -- x )
; (G Call a procedure at addr with an STDCALL calling convention and 32 bits return value )
                        $CODE   'CALL-STDCALL-R1'
                        PUSHRS  EDI
                        POP     EBX
                        CALL    EBX
                        PUSH    EAX
                        POPRS   EDI
                        $NEXT

; CALL-STDCALL-R2 (S addr -- x1 x2 )
; (G Call a procedure at addr with an STDCALL calling convention and 64 bits return value )
                        $CODE   'CALL-STDCALL-R2'
                        PUSHRS  EDI
                        POP     EBX
                        CALL    EBX
                        PUSH    EAX
                        PUSH    EDX
                        POPRS   EDI
                        $NEXT
