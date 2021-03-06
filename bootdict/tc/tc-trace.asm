;******************************************************************************
;
;  tc-trace.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************

;******************************************************************************
;  Output text from threaded code
;******************************************************************************
                MACRO       $WRITE TEXT {
                LOCAL       __S_END
                CW          $PTYPE
                DB          __S_END - $ - 1
                DB          TEXT
__S_END:
                }

;******************************************************************************
;  Output EOL from threaded code
;******************************************************************************
                MACRO       $CR {
                CCLIT       13
                CW          $EMIT
                CCLIT       10
                CW          $EMIT
                }

;******************************************************************************
;  Output the name of the executed word for debugging purposes
;******************************************************************************
                MACRO       $TRACE_WORD NAME {
                $CR
                $WRITE      '>> TW '
                IF          NAME EQ
                CW          $LIT
                CC          LASTWORD + IMAGE_BASE
                CW          $ONE_PLUS, $COUNT, $TYPE
                ELSE
                $WRITE      NAME
                END IF
                $WRITE      '@'
                CW          $R_FETCH, $HOUT8
                }

;******************************************************************************
;  Output the content of the stack
;******************************************************************************
                MACRO       $TRACE_STACK LBL,CNT {
                $CR
                $WRITE      LBL
                $WRITE      ' '
                REPT CNT C \{
                CCLIT       CNT - C
                CW          $PICK
                CW          $HOUT8
                $WRITE      ' '
                \}
                $WRITE      ' <- TOS '
                }

