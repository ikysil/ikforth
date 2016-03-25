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

;  11.6.1.1717 INCLUDE-FILE
;  D: fileid --
                        $DEFER  'INCLUDE-FILE',$INCLUDE_FILE,$_INCLUDE_FILE

                        $NONAME $_INCLUDE_FILE

                        XT_$INPUT_TO_R
                        XT_$RESET_INPUT
                        XT_$SOURCE_ID_STORE
INCLUDE_FILE_LOOP:
                        XT_$SOURCE_ID
                        XT_$FILE_POSITION
                        XT_$DROP
                        XT_$CURRENT_FILE_POSITION
                        XT_$2STORE

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
                        XT_$DROP
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
                        XT_$1SUB
                        CWLIT   $RESTORE_INPUT_FILE
                        CCLIT   6
                        XT_$EXIT

                        $NONAME $RESTORE_INPUT_FILE

                        XT_$DROP
                        CSTORE  $INCLUDE_LINE_NUM
                        XT_$DUP
                        CSTORE  $TOIN
                        XT_$STOD
                        XT_$DADD
                        XT_$CURRENT_FILE_POSITION
                        XT_$2STORE
                        XT_$DUP
                        XT_$SOURCE_ID_STORE
                        XT_$ZEROGR
                        CQBR    @@PRESTORE_FILE_INPUT_EXIT
                          XT_$CURRENT_FILE_POSITION
                          XT_$2FETCH
                          XT_$SOURCE_ID
                          XT_$REPOSITION_FILE
                          XT_$DROP
@@PRESTORE_FILE_INPUT_EXIT:
                        XT_$EXIT

                        $NONAME $RESET_INPUT_FILE

                        XT_$ZERO
                        XT_$DUP
                        CSTORE  $TOIN
                        XT_$DUP
                        XT_$SOURCE_ID_STORE
                        XT_$DUP
                        CSTORE  $INCLUDE_LINE_NUM
                        XT_$DUP
                        CSTORE  $ERROR_LINE_NUM
                        XT_$STOD
                        XT_$CURRENT_FILE_POSITION
                        XT_$2STORE
                        XT_$EXIT
