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
                $CODE       'INIT-USER',$INIT_USER
                CLD
                MOV         DWORD [EDI + VAR_BASE],10
                MOV         DWORD [EDI + VAR_CURRENT],FORTH_WORDLIST_EQU + IMAGE_BASE
                $NEXT

;******************************************************************************
;  I/O
;******************************************************************************

;  (TYPE)
                $COLON      '(TYPE)',$PTYPE
                CW          $RFROM                  ; a
                CW          $COUNT                  ; a+1 b
                CW          $OVER                   ; a+1 b a+1
                CW          $OVER                   ; a+1 b a+1 b
                CW          $ADD                    ; a+1 b a+1+b
                CW          $TOR                    ; a+1 b
                CW          $TYPE
                $END_COLON

