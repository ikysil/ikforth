;******************************************************************************
;
;  dll.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
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

