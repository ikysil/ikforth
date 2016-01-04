;******************************************************************************
;
;  ik.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  IK words
;******************************************************************************

;  INIT-USER
                        $CODE   'INIT-USER',$INIT_USER

                        CLD
                        MOV     DWORD PTR [EDI + BASE_VAR],10
                        MOV     DWORD PTR [EDI + CURRENT_VAR],OFFSET FORTH_WORDLIST_EQU - SIGN + DESIRED_BASE_EQU
                        $NEXT

;******************************************************************************
;  I/O
;******************************************************************************

;  (TYPE)
                        $COLON  '(TYPE)',$PTYPE

                        CW      $RFROM                  ; a
                        CW      $COUNT                  ; a+1 b
                        CW      $OVER                   ; a+1 b a+1
                        CW      $OVER                   ; a+1 b a+1 b
                        CW      $ADD                    ; a+1 b a+1+b
                        CW      $TOR                    ; a+1 b
                        CW      $TYPE
                        CEXIT

