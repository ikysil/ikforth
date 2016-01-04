;******************************************************************************
;
;  host.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Contains words, provided my hosting application.
;******************************************************************************

;******************************************************************************
;  FACILITY words
;******************************************************************************

;  10.6.1.0742 AT-XY
                        $DEF    'AT-XY',$AT_XY
                        $CALL   AT_XY_FUNC
                        $NEXT

;  10.6.1.2005 PAGE
                        $DEF    'PAGE'
                        $CALL   PAGE_FUNC
                        $NEXT

;  (BYE)
                        $DEF    '(BYE)',$PBYE
                        $CALL   BYE_FUNC
                        $NEXT

;******************************************************************************
;  DLL support
;******************************************************************************

;  GetLastError
                        $DEF    'GetLastError'
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

;  (LoadLibrary)
                        $DEF    '(LoadLibrary)',$LOAD_LIBRARY
                        $CALL   LOAD_LIBRARY_FUNC
                        PUSHDS  EAX
                        $NEXT

;  FreeLibrary
                        $DEF    'FreeLibrary',$FREE_LIBRARY
                        $CALL   FREE_LIBRARY_FUNC
                        $NEXT

;  (GetProcAddress)
                        $DEF    '(GetProcAddress)'
                        $CALL   GET_PROC_ADDRESS_FUNC
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  Block words
;******************************************************************************

;  READ-BLOCK
                        $DEF    'READ-BLOCK'
                        $CALL   READ_BLOCK_FUNC
                        $NEXT

;  WRITE-BLOCK
                        $DEF    'WRITE-BLOCK'
                        $CALL   WRITE_BLOCK_FUNC
                        $NEXT

;******************************************************************************
;  FILE access words
;******************************************************************************

                        $DEF    'CLOSE-FILE',$CLOSE_FILE
                        $CALL   FILE_CLOSE_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'CREATE-FILE',$CREATE_FILE
                        $CALL   FILE_CREATE_FUNC
                        PUSHDS  EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'FILE-POSITION',$FILE_POSITION
                        $CALL   FILE_POSITION_FUNC
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'OPEN-FILE',$OPEN_FILE
                        $CALL   FILE_OPEN_FUNC
                        PUSHDS  EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'REPOSITION-FILE',$REPOSITION_FILE
                        $CALL   FILE_REPOSITION_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'WRITE-FILE',$WRITE_FILE
                        $CALL   FILE_WRITE_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

;  11.6.1.2080 READ-FILE 
;  (S c-addr u1 fileid -- u2 ior )
                        $DEF    'READ-FILE',$READ_FILE
                        $CALL   FILE_READ_FUNC
                        PUSHDS  EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    '(READ-LINE)',$PREAD_LINE
                        $CALL   FILE_READ_LINE_FUNC
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

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
                        PUSHDS  EAX
                        $NEXT

;  6.1.0695 ACCEPT
                        $DEF    'ACCEPT',$ACCEPT
                        $CALL   ACCEPT_FUNC
                        PUSHDS  EAX
                        $NEXT

;  6.1.1320 EMIT
;  Emit a char to output
;  D: char --
                        $DEF    'EMIT',$EMIT
                        $CALL   EMIT_FUNC
                        $NEXT

;  6.1.2310 TYPE
;  Display the character string specified by addr and length n
;  D: addr n --
                        $DEF    'TYPE',$TYPE
                        $CALL   TYPE_FUNC
                        $NEXT

;******************************************************************************
;  String words
;******************************************************************************

                        $DEF    'COMPARE',$COMPARE
                        $CALL   COMPARE_FUNC
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  Threads
;******************************************************************************

;  THREAD
                        $DEF    'THREAD',$THREAD
                        PUSHDS  EDI
                        $CALL   START_THREAD_FUNC
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  Memory
;******************************************************************************

                        $DEF    'ALLOCATE',$ALLOCATE
                        $CALL   ALLOCATE_FUNC
                        PUSHDS  EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'FREE',$FREE
                        $CALL   FREE_FUNC
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

                        $DEF    'RESIZE',$RESIZE
                        $CALL   REALLOCATE_FUNC
                        PUSHDS  EAX
                        $CALL   GET_LAST_ERROR_FUNC
                        PUSHDS  EAX
                        $NEXT

