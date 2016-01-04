;******************************************************************************
;
;  data.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Data space
;******************************************************************************

;  6.1.0150 ,
;  Reserve one cell of data space and store x in the cell
;  D: x --
                        $DEF    ',',$COMMA
                        POPDS   EAX
                        MOV     EBX,[DWORD PTR DP_VAR + DESIRED_BASE_EQU]
                        MOV     [DWORD PTR EBX],EAX
                        ADD     [DWORD PTR DP_VAR + DESIRED_BASE_EQU],CELL_SIZE
                        $NEXT

;  COMPILE,
                        $COLON  'COMPILE,',$COMPILEC,<VEF_COMPILE_ONLY>
                        CW      $COMMA
                        CEXIT

;  6.1.0710 ALLOT
;  Allocates n memory cells on the top of vocabulary
;  D: n --
                        $DEF    'ALLOT',$ALLOT
                        POPDS   EAX
                        ADD     [DWORD PTR DP_VAR + DESIRED_BASE_EQU],EAX
                        $NEXT

;  6.1.0860 C,
;  Reserve one character of data space and store x in the cell
;  D: x --
                        $DEF    'C,',$CCOMMA
                        POPDS   EAX
                        MOV     EBX,[DWORD PTR DP_VAR + DESIRED_BASE_EQU]
                        MOV     [BYTE PTR EBX],AL
                        INC     [DWORD PTR DP_VAR + DESIRED_BASE_EQU]
                        $NEXT

;  (;)
                        $DEF    '(;)',$EXIT,,VEF_COMPILE_ONLY
                        POPRS   ESI                     ; pop previous IP from return stack
                        $NEXT

;  6.1.1380 EXIT
                        $DEF    'EXIT',,,VEF_COMPILE_ONLY
                        POPRS   ESI                     ; pop previous IP from return stack
                        $NEXT

;  6.1.0950 CONSTANT
                        $COLON  'CONSTANT',$CONSTANT
                        CWLIT   $DOCONST
                        CCLIT   VEF_USUAL
                        CW      $PARSE_CHECK_HEADERC
                        CW      $DROP
                        CW      $COMMA
                        CEXIT

;  6.1.1780 LITERAL
                        $COLON  'LITERAL',$LITERAL,<VEF_IMMEDIATE OR VEF_COMPILE_ONLY>
                        CWLIT   $LIT
                        CW      $COMPILEC
                        CW      $COMMA
                        CEXIT

;  6.1.1650 HERE
;  addr is the data-space pointer.
;  D: -- addr
                        $COLON  'HERE',$HERE
                        CFETCH  $DP
                        CEXIT
