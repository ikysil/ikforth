;******************************************************************************
;
;  user.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
;
;******************************************************************************
;
;******************************************************************************

USER_HERE          =       0
                        MACRO   _ALLOC SIZE {
USER_HERE          =       USER_HERE + SIZE
                        }

                        MACRO   _VAR NAME,SIZE {
                        LABEL   VAR_#NAME DWORD AT USER_HERE
                        IF      ~ SIZE eq
                          _ALLOC  SIZE
                        ELSE
                          _ALLOC  CELL_SIZE
                        END IF
                        }

                        MACRO   _ALIGN {
USER_HERE          =       ( USER_HERE / CELL_SIZE + 1 ) * CELL_SIZE
                        }

                        _VAR    RETURN_ADDR
                        _VAR    EDI
                        _VAR    ESI
                        _VAR    EBP
                        _VAR    EBX
                        _VAR    ESP
                        _VAR    BASE
                        _VAR    TOIN
                        _VAR    SOURCE_ID
                        _VAR    CASE_SENSITIVE
                        _VAR    TONUMBER_SIGNED

                        _VAR    CURR_FILE_POS
                        _ALLOC  CELL_SIZE

MAX_FILE_LINE_LENGTH    EQU    1024
                        _VAR    HASH_FILE_LINE
                        _VAR    FILE_LINE,MAX_FILE_LINE_LENGTH

                        _VAR    CURRENT

                        _VAR    EXCEPTION_HANDLER

                        _VAR    WIN32_EXCEPTION_CONTEXT,256

SQUOTE_BUFFER_SIZE      EQU     1024
                        _VAR    SQUOTE_BUFFER,SQUOTE_BUFFER_SIZE

                        _VAR    POCKET,256

                        _ALIGN

                        _ALLOC  RETURN_STACK_SIZE
                        _VAR    RSTACK

; keep the following definition after all _VAR declarations
USER_AREA_SIZE          =       USER_HERE
