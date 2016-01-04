;******************************************************************************
;
;  file.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  FILE access words
;******************************************************************************

                        $CONST  'R/O',$R_O
                        CC      0

                        $CONST  'W/O',$W_O
                        CC      1

                        $CONST  'R/W',$R_W
                        CC      2

;  11.6.1.2090 READ-LINE 
;  (S c-addr u1 fileid -- u2 flag ior )
                        $DEFER  'READ-LINE',$READ_LINE
                        CW      $PREAD_LINE


                        $COLON  '(INCLUDED)',$PINCLUDED
                        CW      $R_O
                        CW      $OPEN_FILE
                        CW      $THROW
                        CW      $INCLUDE_FILE
                        CEXIT

;  11.6.1.1718 INCLUDED
;  D: c-addr count --
                        $DEFER  'INCLUDED',$INCLUDED
                        CW      $PINCLUDED

;  11.6.1.1717 INCLUDE-FILE
;  D: fileid --
                        $COLON  'INCLUDE-FILE',$INCLUDE_FILE
                        CW      $INPUTTOR
                        CW      $SOURCE_ID_STORE
                        CW      $ZERO
                        CSTORE  $BLK
                        CW      $ZERO
                        CW      $STOD
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE
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
                        CW      $INPUTFROMR
                        CW      $THROW
                        CEXIT
