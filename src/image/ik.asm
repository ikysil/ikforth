;******************************************************************************
;
;  ik.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  IK words
;******************************************************************************

;  INIT-USER
                        $CODE   'INIT-USER',$INIT_USER

                        CLD
                        MOV     DWORD [EDI + VAR_BASE],10
                        MOV     DWORD [EDI + VAR_CURRENT],FORTH_WORDLIST_EQU + IMAGE_BASE
                        $NEXT

;******************************************************************************
;  I/O
;******************************************************************************

;  (TYPE)
                        $COLON  '(TYPE)',$PTYPE

                        XT_$RFROM                  ; a
                        XT_$COUNT                  ; a+1 b
                        XT_$OVER                   ; a+1 b a+1
                        XT_$OVER                   ; a+1 b a+1 b
                        XT_$ADD                    ; a+1 b a+1+b
                        XT_$TOR                    ; a+1 b
                        XT_$TYPE
                        XT_$EXIT

