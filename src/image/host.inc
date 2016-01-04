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

        CGET_LAST_ERROR MACRO   
                        MOV     EAX,DWORD PTR FS:[18H]
                        PUSHDS  [EAX + 34H]
                        ENDM    CGET_LAST_ERROR

;******************************************************************************
;  FACILITY words
;******************************************************************************

;  (BYE)
                        $CODE   '(BYE)',$PBYE

                        $CALL   BYE_FUNC
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

                        $CALL   LOAD_LIBRARY_FUNC
                        PUSHDS  EAX
                        $NEXT

;  FreeLibrary
                        $CODE   'FreeLibrary'

                        $CALL   FREE_LIBRARY_FUNC
                        $NEXT

;  (GetProcAddress)
                        $CODE   '(GetProcAddress)'

                        $CALL   GET_PROC_ADDRESS_FUNC
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  FILE access words
;******************************************************************************

                        $CODE   'CLOSE-FILE',$CLOSE_FILE

                        $CALL   FILE_CLOSE_FUNC
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'CREATE-FILE',$CREATE_FILE

                        $CALL   FILE_CREATE_FUNC
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'FILE-POSITION',$FILE_POSITION

                        $CALL   FILE_POSITION_FUNC
                        PUSHDS  EAX
                        PUSHDS  EDX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'OPEN-FILE',$OPEN_FILE

                        $CALL   FILE_OPEN_FUNC
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'REPOSITION-FILE',$REPOSITION_FILE

                        $CALL   FILE_REPOSITION_FUNC
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   0,$_READ_LINE

                        $CALL   FILE_READ_LINE_FUNC
                        PUSHDS  EAX
                        PUSHDS  EDX
                        CGET_LAST_ERROR
                        $NEXT

;  6.1.1320 EMIT
;  Emit a char to output
;  D: char --
                        $CODE   'EMIT',$EMIT

                        $CALL   EMIT_FUNC
                        $NEXT

;  6.1.2310 TYPE
;  Display the character string specified by addr and length n
;  D: addr n --
                        $CODE   'TYPE',$TYPE

                        $CALL   TYPE_FUNC
                        $NEXT

;******************************************************************************
;  Threads
;******************************************************************************

;  THREAD
                        $CODE   'THREAD',$THREAD

                        PUSHDS  EDI
                        $CALL   START_THREAD_FUNC
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  Memory
;******************************************************************************

                        $CODE   'ALLOCATE'

                        $CALL   ALLOCATE_FUNC
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'FREE'

                        $CALL   FREE_FUNC
                        CGET_LAST_ERROR
                        $NEXT

                        $CODE   'RESIZE'

                        $CALL   REALLOCATE_FUNC
                        PUSHDS  EAX
                        CGET_LAST_ERROR
                        $NEXT

