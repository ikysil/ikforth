;******************************************************************************
;
;  file.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
;
;******************************************************************************
;  FILE access words
;******************************************************************************

                        $CONST  'R/O',$R_O

                        CC      0

;  11.6.1.2090 READ-LINE 
;  (S c-addr u1 fileid -- u2 flag ior )
                        $DEFER  'READ-LINE',$READ_LINE

                        CW      $_READ_LINE


                        $COLON  0,$_INCLUDED

                        CW      $R_O
                        CW      $OPEN_FILE
                        CW      $THROW
                        CW      $INCLUDE_FILE
                        CEXIT

;  11.6.1.1718 INCLUDED
;  D: c-addr count --
                        $DEFER  'INCLUDED',$INCLUDED

                        CW      $_INCLUDED

;  11.6.1.1717 INCLUDE-FILE
;  D: fileid --
                        $DEFER  'INCLUDE-FILE',$INCLUDE_FILE

                        CW      $_INCLUDE_FILE

                        $COLON  0,$_INCLUDE_FILE

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

                        $COLON  0,$SAVE_INPUT_FILE

                        CW      $SOURCE_ID
                        CW      $CURRENT_FILE_POSITION
                        CW      $2FETCH
                        CFETCH  $TOIN
                        CWLIT   $RESTORE_INPUT_FILE
                        CCLIT   5
                        CEXIT

                        $COLON  0,$RESTORE_INPUT_FILE

                        CW      $DROP
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
                          CW      $REFILL
                          CW      $2DROP
@@PRESTORE_FILE_INPUT_EXIT:
                        CEXIT

                        $COLON  0,$RESET_INPUT_FILE

                        CW      $ZERO
                        CW      $DUP
                        CSTORE  $TOIN
                        CW      $DUP
                        CW      $SOURCE_ID_STORE
                        CW      $STOD
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE
                        CEXIT

                        