;******************************************************************************
;
;  source.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;
;******************************************************************************

;  6.1.2216 SOURCE
;  c-addr is the address of, and u is the number of characters in
;  the input buffer.
;  D: -- c-addr u
                $NONAME     $_SOURCE
                CW          $FILE_LINE
                CFETCH      $HASH_FILE_LINE
                $END_COLON

                $DEFER      'SOURCE',$SOURCE,$_SOURCE

;  (REPORT-SOURCE)
;  D: c-addr u line-u --
                $COLON      '(REPORT-SOURCE)',$PREPORT_SOURCE
                $WRITE      'LINE# H# '
                CW          $HOUT8
                $WRITE      '  '
                CW          $TYPE
                $END_COLON

;  REPORT-REFILL
                $COLON      'REPORT-REFILL',$REPORT_REFILL
                CW          $REFILL_SOURCE, $TWO_FETCH
                CFETCH      $INCLUDE_LINE_NUM
                CW          $PREPORT_SOURCE
                $END_COLON

;  REPORT-SOURCE
                $COLON      'REPORT-SOURCE',$REPORT_SOURCE
                CW          $INTERPRET_TEXT
                CFETCH      $HASH_INTERPRET_TEXT
                CFETCH      $ERROR_LINE_NUM
                CW          $PREPORT_SOURCE
                $END_COLON

;  REPORT-SOURCE!
                $COLON      'REPORT-SOURCE!',$REPORT_SOURCE_STORE
                CW          $SOURCE, $REFILL_SOURCE, $TWO_STORE
                CFETCH      $INCLUDE_LINE_NUM
                CSTORE      $ERROR_LINE_NUM
                $END_COLON

;  11.6.1.2090 READ-LINE
;  (S c-addr u1 fileid -- u2 flag ior )
                $DEFER      'READ-LINE',$READ_LINE,$_READ_LINE

;  6.2.2125 REFILL
;  D: -- flag
                $DEFER      'REFILL',$REFILL,$REFILL_FILE

                $DEFER      '(SAVE-INPUT)',$PSAVE_INPUT,$SAVE_INPUT_FILE

;  SAVE-INPUT
                $COLON      'SAVE-INPUT',$SAVE_INPUT
                CW          $PSAVE_INPUT
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'SAVE-INPUT',12
                }
                $END_COLON

;  RESTORE-INPUT
                $COLON      'RESTORE-INPUT',$RESTORE_INPUT
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'RESTORE-INPUT-A',12
                }
                CW          $ONE_MINUS, $SWAP, $CATCH
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'RESTORE-INPUT-B',1
                }
                $END_COLON

                $DEFER      '(RESET-INPUT)',$PRESET_INPUT,$RESET_INPUT_FILE

;  RESET-INPUT
                $COLON      'RESET-INPUT',$RESET_INPUT
                CW          $PRESET_INPUT
                $END_COLON

;  INPUT>R
                $COLON      'INPUT>R',$INPUT_TO_R,VEF_COMPILE_ONLY
                CW          $R_FROM, $SAVE_INPUT
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'INPUT>R',12
                }
                CW          $N_TO_R, $TO_R
                $END_COLON

;  R>INPUT
                $COLON      'R>INPUT',$R_TO_INPUT,VEF_COMPILE_ONLY
                CW          $R_FROM, $N_R_FROM
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'R>INPUT',12
                }
                CW          $RESTORE_INPUT, $THROW, $TO_R
                $END_COLON
