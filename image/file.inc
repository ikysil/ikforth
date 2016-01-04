;******************************************************************************
;
;  file.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
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

                        $DEF    'CLOSE-FILE',$CLOSE_FILE
                        $CALL   FILE_CLOSE_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'CREATE-FILE',$CREATE_FILE
                        $CALL   FILE_CREATE_FUNC
                        PUSH    EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'FILE-POSITION',$FILE_POSITION
                        $CALL   FILE_POSITION_FUNC
                        PUSH    EAX
                        PUSH    EDX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'OPEN-FILE',$OPEN_FILE
                        $CALL   FILE_OPEN_FUNC
                        PUSH    EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'READ-FILE',$READ_FILE
                        $CALL   FILE_READ_FUNC
                        PUSH    EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'REPOSITION-FILE',$REPOSITION_FILE
                        $CALL   FILE_REPOSITION_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'WRITE-FILE',$WRITE_FILE
                        $CALL   FILE_WRITE_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

                        $DEF    'READ-LINE',$READ_LINE
                        $CALL   FILE_READ_LINE_FUNC
                        PUSH    EAX
                        PUSH    EDX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

;  INCLUDED
;  D: c-addr count --
                        $COLON  'INCLUDED',$INCLUDED
                        CW      $R_O
                        CW      $OPEN_FILE
                        CW      $THROW
                        CW      $INCLUDE_FILE
                        CW      $EXIT

                        $COLON  'INCLUDE-FILE',$INCLUDE_FILE
                        CW      $INPUTTOR
                        CW      $SOURCE_ID_STORE
                        CW      $ZERO
                        CW      $BLK
                        CW      $STORE
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
                        CW      $QBRANCH
                        CW      INCLUDE_FILE_EXIT
                          CW      $DROP
                          CW      $LIT
                          CW      $INTERPRET
                          CW      $CATCH
                          CW      $QDUP
                        CW      $QBRANCH
                        CW      INCLUDE_FILE_LOOP
INCLUDE_FILE_EXIT:
                        CW      $SOURCE_ID
                        CW      $CLOSE_FILE
                        CW      $DROP
                        CW      $INPUTFROMR
                        CW      $THROW
                        CW      $EXIT

;  11.6.1.2147 RESIZE-FILE 
;  ( ud fileid -- ior )
;  Set the size of the file identified by fileid to ud. ior is the
;  implementation-defined I/O result code. 
;  If the resultant file is larger than the file before the operation,
;  the portion of the file added as a result of the operation might not have
;  been written. At the conclusion of the operation, FILE-SIZE returns
;  the value ud and FILE-POSITION returns an unspecified value. 
                        $DEF    'RESIZE-FILE',$RESIZE_FILE
                        $CALL   FILE_RESIZE_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSH    EAX
                        $NEXT

