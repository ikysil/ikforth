;******************************************************************************
;
;  file.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  FILE access words
;******************************************************************************

;  R/O
                $CONST      'R/O',$R_O,0

;  REFILL-FILE
                $COLON      'REFILL-FILE',$REFILL_FILE
                CW          $SOURCE_ID
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REFILL-FILE'
                $TRACE_STACK 'REFILL-FILE-A:',1
                }
                CW          $FILE_POSITION
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REFILL-FILE'
                $TRACE_STACK 'REFILL-FILE-B:',3
                }
                CW          $THROW, $CURRENT_FILE_POSITION, $2STORE

                CW          $FILE_LINE
                CCLIT       MAX_FILE_LINE_LENGTH
                CW          $SOURCE_ID, $READ_LINE, $THROW, $SWAP
                CSTORE      $HASH_FILE_LINE
                CW          $ZERO
                CSTORE      $TOIN

                CFETCH      $INCLUDE_LINE_NUM
                CW          $1ADD
                CSTORE      $INCLUDE_LINE_NUM

                CW          $REPORT_SOURCE_STORE

                MATCH       =TRUE, DEBUG {
                $CR
                $WRITE      'REFILL: '
                CW          $REPORT_REFILL
                }

                $END_COLON

;  11.6.1.1717 INCLUDE-FILE
;  D: fileid --
                $DEFER      'INCLUDE-FILE',$INCLUDE_FILE,$_INCLUDE_FILE

;  INCLUDE-FILE for bootstrap
                $NONAME     $_INCLUDE_FILE
                CW          $INPUT_TO_R, $RESET_INPUT, $SOURCE_ID_STORE
INCLUDE_FILE_LOOP:
                CW          $ZERO ; FOR THROW
                CW          $REFILL
                CQBR        INCLUDE_FILE_EXIT
                CW          $DROP
                CWLIT       $INTERPRET
                CW          $CATCH, $QDUP
                CQBR        INCLUDE_FILE_LOOP
INCLUDE_FILE_EXIT:
                CW          $SOURCE_ID, $CLOSE_FILE, $THROW, $R_TO_INPUT, $THROW
                $END_COLON

;  INCLUDED for bootstrap
                $NONAME     $_INCLUDED
                CW          $R_O, $OPEN_FILE, $THROW, $INCLUDE_FILE
                $END_COLON

;  11.6.1.1718 INCLUDED
;  D: c-addr count --
                $DEFER      'INCLUDED',$INCLUDED,$_INCLUDED

SAVE_INPUT_FILE_DATA_SIZE EQU 6

;  SAVE-INPUT for file
                $NONAME     $SAVE_INPUT_FILE
                CW          $SOURCE_ID, $CURRENT_FILE_POSITION, $2FETCH
                CFETCH      $TOIN
                CFETCH      $INCLUDE_LINE_NUM
                CWLIT       $RESTORE_INPUT_FILE
                CCLIT       SAVE_INPUT_FILE_DATA_SIZE
                $END_COLON

;  RESTORE-INPUT for file
                $NONAME     $RESTORE_INPUT_FILE
;  FIXME check the number of values
                CW          $DROP
                CSTORE      $INCLUDE_LINE_NUM
                CSTORE      $TOIN
                CW          $CURRENT_FILE_POSITION, $2STORE, $DUP, $SOURCE_ID_STORE, $ZEROGR
                _IF         RESTORE_INPUT_FILE_FILE
                ; restore file position
                CW          $CURRENT_FILE_POSITION, $2FETCH, $SOURCE_ID, $REPOSITION_FILE, $THROW
                ; re-read last line
                CW          $FILE_LINE
                CCLIT       MAX_FILE_LINE_LENGTH
                CW          $SOURCE_ID, $READ_LINE, $THROW, $DROP, $DUP
                CSTORE      $HASH_FILE_LINE
                CFETCH      $TOIN
                CW          $GR
                _IF         RESTORE_INPUT_FILE_MORE_CURRENT_LINE
                ; if value of #FILE-LINE is larger than value of >IN
                ; then we have more things to process on this line
                ; save the information for error reporting purposes
                CW          $INTERPRET_TEXT_STORE
                _THEN       RESTORE_INPUT_FILE_MORE_CURRENT_LINE
                _THEN       RESTORE_INPUT_FILE_FILE
                $END_COLON

;  RESET-INPUT for file
                $NONAME     $RESET_INPUT_FILE
                CW          $ZERO, $DUP
                CSTORE      $TOIN
                CW          $DUP, $SOURCE_ID_STORE
                CW          $ZERO
                CW          $DUP
                CSTORE      $INCLUDE_LINE_NUM
                CSTORE      $ERROR_LINE_NUM
                CW          $STOD, $CURRENT_FILE_POSITION, $2STORE
                $END_COLON
