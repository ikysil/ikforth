;******************************************************************************
;
;  file.inc
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  FILE access words
;******************************************************************************

                        $CONST  'R/O',$R_O,0

;  11.6.1.2090 READ-LINE 
;  (S c-addr u1 fileid -- u2 flag ior )
                        $DEFER  'READ-LINE',$READ_LINE,$_READ_LINE


                        $NONAME $_INCLUDED

                        CW      $R_O
                        CW      $OPEN_FILE
                        CW      $THROW
                        CW      $INCLUDE_FILE
                        CEXIT

;  11.6.1.1718 INCLUDED
;  D: c-addr count --
                        $DEFER  'INCLUDED',$INCLUDED,$_INCLUDED

;  11.6.1.1717 INCLUDE-FILE
;  D: fileid --
                        $DEFER  'INCLUDE-FILE',$INCLUDE_FILE,$_INCLUDE_FILE

                        $NONAME $_INCLUDE_FILE

                        CW      $INPUT_TO_R
                        CW      $RESET_INPUT
                        CW      $SOURCE_ID_STORE
INCLUDE_FILE_LOOP:
                        CW      $SOURCE_ID
                        CW      $FILE_POSITION
                        CW      $DROP
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE

                        CW      $ZERO                   ; FOR THROW
                        CW      $REFILL
                        CQBR    INCLUDE_FILE_EXIT
                          CW      $DROP
                          CWLIT   $INTERPRET
                          CW      $CATCH
                          CW      $QDUP
                        CQBR    INCLUDE_FILE_LOOP
INCLUDE_FILE_EXIT:
                        CW      $SOURCE_ID
                        CW      $CLOSE_FILE
                        CW      $DROP
                        CW      $R_TO_INPUT
                        CW      $THROW
                        CEXIT

                        $NONAME $SAVE_INPUT_FILE

                        CW      $SOURCE_ID
                        CW      $CURRENT_FILE_POSITION
                        CW      $2FETCH
                        CFETCH  $TOIN
                        CFETCH  $INCLUDE_LINE_NUM
                        CW      $1SUB
                        CWLIT   $RESTORE_INPUT_FILE
                        CCLIT   6
                        CEXIT

                        $NONAME $RESTORE_INPUT_FILE

                        CW      $DROP
                        CSTORE  $INCLUDE_LINE_NUM
                        CW      $DUP
                        CSTORE  $TOIN
                        CW      $STOD
                        CW      $DADD
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE
                        CW      $DUP
                        CW      $SOURCE_ID_STORE
                        CW      $ZEROGR
                        CQBR    @@PRESTORE_FILE_INPUT_EXIT
                          CW      $CURRENT_FILE_POSITION
                          CW      $2FETCH
                          CW      $SOURCE_ID
                          CW      $REPOSITION_FILE
                          CW      $DROP
@@PRESTORE_FILE_INPUT_EXIT:
                        CEXIT

                        $NONAME $RESET_INPUT_FILE

                        CW      $ZERO
                        CW      $DUP
                        CSTORE  $TOIN
                        CW      $DUP
                        CW      $SOURCE_ID_STORE
                        CW      $DUP
                        CSTORE  $INCLUDE_LINE_NUM
                        CW      $DUP
                        CSTORE  $ERROR_LINE_NUM
                        CW      $STOD
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE
                        CEXIT

                        
