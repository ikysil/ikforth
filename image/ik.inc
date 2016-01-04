;******************************************************************************
;
;  ik.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  IK words
;******************************************************************************

;  INIT-USER
                        $DEF    'INIT-USER',$INIT_USER
                        CLD
                        MOV     [DWORD PTR EDI + BASE_VAR],10
                        MOV     [DWORD PTR EDI + STATE_VAR],FALSE
                        MOV     [DWORD PTR EDI + CURRENT_VAR],OFFSET FORTH_WORDLIST_EQU + DESIRED_BASE_EQU
                        $NEXT

;  SMUDGE
;  Makes latest word hidden/visible in search
                        $COLON  'SMUDGE',$SMUDGE
                        CW      $LATEST_FETCH
                        CW      $LIT
                        CC      VEF_HIDDEN
                        CW      $TOGGLE
                        CW      $EXIT

;  TOGGLE
;  D: c-addr mask --
                        $DEF    'TOGGLE',$TOGGLE
                        POPDS   ECX
                        POPDS   EBX
                        XOR     [BYTE PTR EBX],CL
                        $NEXT

