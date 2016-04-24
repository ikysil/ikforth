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

;******************************************************************************
;  STDCALL
;******************************************************************************
                MACRO       $STDCALL [rregs] {
                COMMON

                PUSHRS      EDI
                POPDS       EBX
                CALL        EBX
                POPRS       EDI

                IRPS        rreg, rregs \{
                PUSHDS      rreg
                \}

                }

; CALL-STDCALL-C0 (S addr -- )
; (G Call a procedure at addr with an STDCALL calling convention and no return value )
                $CODE       'CALL-STDCALL-C0'
                $STDCALL
                $NEXT

; CALL-STDCALL-C1 (S addr -- x )
; (G Call a procedure at addr with an STDCALL calling convention and cell return value )
                $CODE       'CALL-STDCALL-C1'
                $STDCALL    EAX
                $NEXT

; CALL-STDCALL-C2 (S addr -- x1 x2 )
; (G Call a procedure at addr with an STDCALL calling convention and double cell return value )
                $CODE       'CALL-STDCALL-C2'
                $STDCALL    EAX EDX
                $NEXT

;******************************************************************************
;  CDECL
;******************************************************************************
                MACRO       $CDECL [rregs] {
                COMMON

                PUSHRS      EDI
                POPDS       EBX
                POPDS       ECX
                PUSHRS      ECX
                CALL        EBX
                POPRS       ECX
                SHL         ECX,2
                ADD         ESP,ECX
                POPRS       EDI

                IRPS        rreg, rregs \{
                PUSHDS      rreg
                \}

                }

; CALL-CDECL-C0 (S x1 .. xn n addr -- )
; (G Call a procedure at addr with an CDECL calling convention and no return value )
                $CODE       'CALL-CDECL-C0'
                $CDECL
                $NEXT

; CALL-CDECL-C1 (S x1 .. xn n addr -- x )
; (G Call a procedure at addr with an CDECL calling convention and cell return value )
                $CODE       'CALL-CDECL-C1'
                $CDECL      EAX
                $NEXT

; CALL-CDECL-C2 (S x1 .. xn n addr -- x1 x2 )
; (G Call a procedure at addr with an CDECL calling convention and double cell return value )
                $CODE       'CALL-CDECL-C2'
                $CDECL      EAX EDX
                $NEXT
