;******************************************************************************
;
;  host.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
;
;******************************************************************************
;  Contains words, provided by hosting application.
;******************************************************************************

                        MACRO   CGET_LAST_ERROR {
                        MOV     EAX,DWORD [FS:18H]
                        PUSHDS  <DWORD [EAX + 34H]>
                        }

;******************************************************************************
;  FACILITY words
;******************************************************************************

;  (BYE)
                        $CODE   '(BYE)',$PBYE

                        $CALL   BYE
                        $NEXT

;******************************************************************************
;  DLL support
;******************************************************************************

;  GetLastError
                        $CODE   'GetLastError'

                        CGET_LAST_ERROR
                        $NEXT

;  (LoadLibrary)
                        $CODE   '(LoadLibrary)'

                        $CALL   LOAD_LIBRARY
                        PUSHDS  EAX
                        $NEXT

;  FreeLibrary
                        $CODE   'FreeLibrary'

                        $CALL   FREE_LIBRARY
                        $NEXT

;  (GetProcAddress)
                        $CODE   '(GetProcAddress)'

                        $CALL   GET_PROC_ADDRESS
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  FILE access words
;******************************************************************************

                        $CODE   'CLOSE-FILE',$CLOSE_FILE

                        $CALL   FILE_CLOSE
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'CREATE-FILE',$CREATE_FILE

                        $CALL   FILE_CREATE
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'FILE-POSITION',$FILE_POSITION

                        $CALL   FILE_POSITION
                        PUSHDS  EAX
                        PUSHDS  EDX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'OPEN-FILE',$OPEN_FILE

                        $CALL   FILE_OPEN
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'REPOSITION-FILE',$REPOSITION_FILE

                        $CALL   FILE_REPOSITION
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   <>,$_READ_LINE

                        $CALL   FILE_READ_LINE
                        PUSHDS  EAX
                        PUSHDS  EDX
                        CGET_LAST_ERROR
                        $NEXT

;  6.1.1320 EMIT
;  Emit a char to output
;  D: char --
                        $CODE   'EMIT',$EMIT

                        $CALL   EMIT
                        $NEXT

;  6.1.2310 TYPE
;  Display the character string specified by addr and length n
;  D: addr n --
                        $CODE   'TYPE',$TYPE

                        $CALL   TYPE
                        $NEXT

;******************************************************************************
;  Threads
;******************************************************************************

;  THREAD
                        $CODE   'THREAD',$THREAD

                        PUSHDS  EDI
                        $CALL   START_THREAD
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  Memory
;******************************************************************************

                        $CODE   'ALLOCATE'

                        $CALL   ALLOCATE
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'FREE'

                        $CALL   FREE
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'RESIZE'

                        $CALL   REALLOCATE
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

