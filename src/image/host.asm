;******************************************************************************
;
;  host.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Contains words, provided by hosting application.
;******************************************************************************

                MACRO       CGET_LAST_ERROR {
                $FSYSCALL   GET_LAST_ERROR
                PUSHDS      EAX
                }

;******************************************************************************
;  FACILITY words
;******************************************************************************

;  (BYE)
                $CODE       '(BYE)',$PBYE
                $FSYSCALL   BYE
                $NEXT

;******************************************************************************
;  DLL support
;******************************************************************************

;  GetLastError
                $CODE       'GetLastError'
                CGET_LAST_ERROR
                $NEXT

;  (LoadLibrary)
                $CODE       '(LoadLibrary)'
                $FSYSCALL   LOAD_LIBRARY
                PUSHDS      EAX
                $NEXT

;  FreeLibrary
                $CODE       'FreeLibrary'
                $FSYSCALL   FREE_LIBRARY
                $NEXT

;  (GetProcAddress)
                $CODE       '(GetProcAddress)'
                $FSYSCALL   GET_PROC_ADDRESS
                PUSHDS      EAX
                $NEXT

;******************************************************************************
;  FILE access words
;******************************************************************************

                $CODE       'CLOSE-FILE',$CLOSE_FILE
                $FSYSCALL   FILE_CLOSE
                CGET_LAST_ERROR
                $NEXT

                $CODE       'CREATE-FILE',$CREATE_FILE
                $FSYSCALL   FILE_CREATE
                PUSHDS      EAX
                CGET_LAST_ERROR
                $NEXT

                $CODE       'FILE-POSITION',$FILE_POSITION
                $FSYSCALL   FILE_POSITION
                PUSHDS      EAX
                PUSHDS      EDX
                CGET_LAST_ERROR
                $NEXT

                $CODE       'OPEN-FILE',$OPEN_FILE
                $FSYSCALL   FILE_OPEN
                PUSHDS      EAX
                CGET_LAST_ERROR
                $NEXT

                $CODE       'REPOSITION-FILE',$REPOSITION_FILE
                $FSYSCALL   FILE_REPOSITION
                CGET_LAST_ERROR
                $NEXT

                $CODE       <>,$_READ_LINE
                $FSYSCALL   FILE_READ_LINE
                PUSHDS      EAX
                PUSHDS      EDX
                CGET_LAST_ERROR
                $NEXT

;  6.1.1320 EMIT
;  Emit a char to output
;  D: char --
                $CODE       'EMIT',$EMIT
                $FSYSCALL   EMIT
                $NEXT

;  6.1.2310 TYPE
;  Display the character string specified by addr and length n
;  D: addr n --
                $CODE       'TYPE',$TYPE
                $FSYSCALL   TYPE
                $NEXT

;******************************************************************************
;  Threads
;******************************************************************************

;  THREAD
                $CODE       'THREAD',$THREAD
                PUSHDS      EDI
                $FSYSCALL   START_THREAD
                PUSHDS      EAX
                $NEXT

;******************************************************************************
;  Memory
;******************************************************************************

                $CODE       'ALLOCATE'
                $FSYSCALL   ALLOCATE
                PUSHDS      EAX
                CGET_LAST_ERROR
                $NEXT

                $CODE       'FREE'
                $FSYSCALL   FREE
                CGET_LAST_ERROR
                $NEXT

                $CODE       'RESIZE'
                $FSYSCALL   REALLOCATE
                PUSHDS      EAX
                CGET_LAST_ERROR
                $NEXT
