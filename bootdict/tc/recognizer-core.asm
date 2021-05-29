;******************************************************************************
;
;  recognizer-core.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Core RECOGNIZERs
;******************************************************************************

                $NONAME     $R_FAIL_OP
                CTHROW      -13
                $END_COLON

                $RTABLE     'R:FAIL',$R_FAIL,$R_FAIL_OP,$R_FAIL_OP,$R_FAIL_OP

;  R>INT
;  R:TABLE -- XT-INTERPRET
                $COLON      'R>INT',$R2INT
                CW          $FETCH
                $END_COLON

;  R>COMP
;  R:TABLE -- XT-COMPILE
                $COLON      'R>COMP',$R2COMP
                CW          $CELL_PLUS, $FETCH
                $END_COLON

;  R>POST
;  R:TABLE -- XT-POSTPONE
                $COLON      'R>POST',$R2POST
                CW          $CELL_PLUS, $CELL_PLUS, $FETCH
                $END_COLON

;  DO-RECOGNIZER
;  c-addr len rec-id -- i*x R:TABLE | R:FAIL
                $COLON      'DO-RECOGNIZER',$DO_RECOGNIZER
                CW          $DUPE, $TO_R, $FETCH
                _BEGIN      DO_REC_LOOP
                ; S: c-addr len rec-count
                CW          $DUPE
                _WHILE      DO_REC_LOOP
                CW          $DUPE, $CELLS, $R_FETCH, $PLUS, $FETCH
                ; S: c-addr len rec-count rec-xt R: rec-id
                CW          $TWO_OVER, $TWO_TO_R, $SWAP, $ONE_MINUS, $TO_R
                ; S: c-addr len rec-xt R: rec-id c-addr len rec-count'
                CW          $EXECUTE
                CW          $DUPE, $R_FAIL, $NOT_EQUALS
                _IF         DO_REC_FOUND
                CW          $TWO_R_FROM, $TWO_DROP, $TWO_R_FROM, $TWO_DROP
                ; S: R:TABLE
                CW          $EXIT
                _THEN       DO_REC_FOUND
                CW          $DROP, $R_FROM, $TWO_R_FROM, $ROT
                _REPEAT     DO_REC_LOOP
                CW          $DROP, $TWO_DROP, $R_FROM, $DROP, $R_FAIL
                $END_COLON

                $RTABLE     'R:NOT-FOUND',$R_NOT_FOUND,$NOOP,$NOOP,$NOOP

;  REC:NOT-FOUND
;  ( addr len -- R:NOT-FOUND )
                $COLON      'REC:NOT-FOUND',$REC_NOT_FOUND
                CW          $INTERPRET_WORD_NOT_FOUND
                CW          $R_NOT_FOUND
                $END_COLON

                $CREATE     'CORE-RECOGNIZER',$CORE_RECOGNIZER
                CC          3
                ; ATTENTION - the first recognizer in the list will be executed last by DO-RECOGNIZER
                CW          $REC_NOT_FOUND
                CW          $REC_NUM
                CW          $REC_WORD

                $VALUE      'FORTH-RECOGNIZER',$FORTH_RECOGNIZER,PFA_$CORE_RECOGNIZER + IMAGE_BASE
