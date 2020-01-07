;******************************************************************************
;
;  recognizer-num.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Number recognizers
;******************************************************************************

;  >NUMBER-SIGNED
                $USER       '>NUMBER-SIGNED',$TONUMBER_SIGNED,VAR_TONUMBER_SIGNED

;  IL-CHECK-SIGN
;  ( c-addr u -- c-addr' u' )
;  Check sign prefix at c-addr.
;  Set >NUMBER-SIGNED according to the sign and advance c-addr' if present.
                $COLON      'IL-CHECK-SIGN',$ILCS
                CW          $FALSE
                CSTORE      $TONUMBER_SIGNED
                CW          $OVER, $CFETCH, $DUP
                CCLIT       '-'
                CW          $NOEQ
                CQBR        ILCS_SIGNED
                CCLIT       '+'
                CW          $NOEQ
                CQBR        ILCS_UNSIGNED
                CBR         ILCS_EXIT
ILCS_SIGNED:
                CW          $DROP, $TRUE
                CSTORE      $TONUMBER_SIGNED
ILCS_UNSIGNED:
                CW          $SWAP, $CHARADD, $SWAP, $1SUB
ILCS_EXIT:
                $END_COLON

;  IL-CHECK-LIT
;  ( c-addr u - n TRUE | c-addr u FALSE )
;  Try to convert number literal at c-addr with >NUMBER.
;  Return literal and TRUE if successful.
;  Return remaining literal string to convert and FALSE if not successful.
                $COLON      'IL-CHECK-LIT',$ILCL
                CW          $ZERO, $DUP, $2SWAP, $TONUMBER, $DUP, $ZEROEQ
                _IF         ILCL_TONUMBER_SUCCESS
                CW          $2DROP, $DROP
                CFETCH      $TONUMBER_SIGNED
                _IF         ILCL_SIGNED
                CW          $NEGATE
                _THEN       ILCL_SIGNED
                CW          $TRUE
                _ELSE       ILCL_TONUMBER_SUCCESS
                CW          $FALSE
                _THEN       ILCL_TONUMBER_SUCCESS
                $END_COLON

;  IL-CHECK-2LIT
;  ( d c-addr u - d TRUE | FALSE )
;  Check that number literal at c-addr ends with DOT (.) and return literal and TRUE.
;  Otherwise return FALSE.
                $COLON      'IL-CHECK-2LIT',$ILC2L
                CW          $1SUB, $ZEROEQ      ; S: d c-addr flag
                CQBR        ILC2L_TOO_SHORT
                CW          $CFETCH             ; S: d char
                CCLIT       '.'
                CW          $EQ
                CQBR        ILC2L_NOT_DOUBLE
                CFETCH      $TONUMBER_SIGNED
                CQBR        ILC2L_UNSIGNED
                CW          $DNEGATE
ILC2L_UNSIGNED:
                CW          $TRUE
                CBR         ILC2L_EXIT
ILC2L_TOO_SHORT:
                CW          $DROP               ; S: d
ILC2L_NOT_DOUBLE:
                CW          $2DROP, $FALSE
ILC2L_EXIT:
                $END_COLON

;  R:NUM-COMP - number COMPILE and POSTPONE action
;  ( n -- )
                $NONAME     R_NUM_COMP
                CW          $LITERAL
                $END_COLON

                $RTABLE     'R:NUM',R_NUM,$NOOP,R_NUM_COMP,R_NUM_COMP

;  R:DNUM-COMP - double COMPILE and POSTPONE action
;  ( d -- )
                $NONAME     R_DNUM_COMP
                CW          $2LITERAL
                $END_COLON

                $RTABLE     'R:DNUM',R_DNUM,$NOOP,R_DNUM_COMP,R_DNUM_COMP

;  REC:NUM
;  ( addr len -- n R:NUM | d R:DNUM | R:FAIL )
                $COLON      'REC:NUM',REC_NUM
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:NUM'
                $TRACE_STACK 'REC:NUM-A:',2
                }
                CW          $DUP, $ZERO, $NOEQ
                CQBR        RECN_FAIL
                CW          $ILCS       ; c-addr u
                CW          $DUP        ; c-addr u u
                CCLIT       1
                CW          $EQ
                CQBR        RECN_OK1    ; branch if u <> 1
                CW          $OVER       ; c-addr u c-addr
                CW          $CFETCH
                CCLIT       '.'
                CW          $EQ
                CQBR        RECN_OK1    ; branch if c-addr @ <> '.'
                CW          $2DROP
                CBR         RECN_FAIL   ; do not accept DOT (.) as literal
RECN_OK1:
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:NUM'
                $TRACE_STACK 'REC:NUM-B:',2
                }
                CW          $ILCL
                CQBR        RECN_CHECK_2LIT
                CW          R_NUM
                CBR         RECN_EXIT
RECN_CHECK_2LIT:
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:NUM'
                $TRACE_STACK 'REC:NUM-C:',2
                }
                CW          $ILC2L
                CQBR        RECN_FAIL
                CW          R_DNUM
                CBR         RECN_EXIT
RECN_FAIL:
                CW          R_FAIL
RECN_EXIT:
                $END_COLON
