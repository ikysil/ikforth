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

                        $CONST  'R/O',$R_O,0

                        $COLON  'REFILL-FILE',$REFILL_FILE
                        XT_$SOURCE_ID
                        MATCH   =TRUE, DEBUG {
                           $TRACE_WORD  'REFILL-FILE'
                           $TRACE_STACK 'REFILL-FILE-A:',1
                        }
                        XT_$FILE_POSITION
                        MATCH   =TRUE, DEBUG {
                           $TRACE_WORD  'REFILL-FILE'
                           $TRACE_STACK 'REFILL-FILE-B:',3
                        }
                        XT_$THROW
                        XT_$CURRENT_FILE_POSITION
                        XT_$2STORE

                        XT_$FILE_LINE
                        CCLIT   MAX_FILE_LINE_LENGTH
                        XT_$SOURCE_ID
                        XT_$READ_LINE
                        XT_$THROW
                        XT_$SWAP
                        CSTORE  $HASH_FILE_LINE
                        XT_$ZERO
                        CSTORE  $TOIN

                        CFETCH  $INCLUDE_LINE_NUM
                        XT_$1ADD
                        CSTORE  $INCLUDE_LINE_NUM

                        XT_$REPORT_SOURCE_STORE

                        MATCH   =TRUE, DEBUG {
                        $CR
                        $WRITE  'REFILL: '
                        XT_$REPORT_SOURCE
                        }

                        XT_$EXIT

;  11.6.1.1717 INCLUDE-FILE
;  D: fileid --
                        $DEFER  'INCLUDE-FILE',$INCLUDE_FILE,$_INCLUDE_FILE

                        $NONAME $_INCLUDE_FILE
                        XT_$INPUT_TO_R
                        XT_$RESET_INPUT
                        XT_$SOURCE_ID_STORE
INCLUDE_FILE_LOOP:
                        XT_$ZERO                   ; FOR THROW
                        XT_$REFILL
                        CQBR    INCLUDE_FILE_EXIT
                          XT_$DROP
                          CWLIT   $INTERPRET
                          XT_$CATCH
                          XT_$QDUP
                        CQBR    INCLUDE_FILE_LOOP
INCLUDE_FILE_EXIT:
                        XT_$SOURCE_ID
                        XT_$CLOSE_FILE
                        XT_$THROW
                        XT_$R_TO_INPUT
                        XT_$THROW
                        XT_$EXIT

                        $NONAME $_INCLUDED
                        XT_$R_O
                        XT_$OPEN_FILE
                        XT_$THROW
                        XT_$INCLUDE_FILE
                        XT_$EXIT

;  11.6.1.1718 INCLUDED
;  D: c-addr count --
                        $DEFER  'INCLUDED',$INCLUDED,$_INCLUDED

                        $NONAME $SAVE_INPUT_FILE
                        XT_$SOURCE_ID
                        XT_$CURRENT_FILE_POSITION
                        XT_$2FETCH
                        CFETCH  $TOIN
                        CFETCH  $INCLUDE_LINE_NUM
                        CWLIT   $RESTORE_INPUT_FILE
                        CCLIT   6
                        XT_$EXIT

                        $NONAME $RESTORE_INPUT_FILE
                        XT_$DROP
                        CSTORE  $INCLUDE_LINE_NUM
                        CSTORE  $TOIN
                        XT_$CURRENT_FILE_POSITION
                        XT_$2STORE
                        XT_$DUP
                        XT_$SOURCE_ID_STORE
                        XT_$ZEROGR
                        CQBR    @@PRESTORE_FILE_INPUT_EXIT
                          ; restore file position
                          XT_$CURRENT_FILE_POSITION
                          XT_$2FETCH
                          XT_$SOURCE_ID
                          XT_$REPOSITION_FILE
                          XT_$THROW
                          ; re-read last line
                          XT_$FILE_LINE
                          CCLIT   MAX_FILE_LINE_LENGTH
                          XT_$SOURCE_ID
                          XT_$READ_LINE
                          XT_$THROW
                          XT_$DROP
                          CSTORE  $HASH_FILE_LINE
                          ; store information for errors tracing
                          XT_$REPORT_SOURCE_STORE
@@PRESTORE_FILE_INPUT_EXIT:
                        XT_$EXIT

                        $NONAME $RESET_INPUT_FILE
                        XT_$ZERO
                        XT_$DUP
                        CSTORE  $TOIN
                        XT_$DUP
                        XT_$SOURCE_ID_STORE
                        CCLIT   0
                        XT_$DUP
                        CSTORE  $INCLUDE_LINE_NUM
                        CSTORE  $ERROR_LINE_NUM
                        XT_$STOD
                        XT_$CURRENT_FILE_POSITION
                        XT_$2STORE
                        XT_$EXIT
