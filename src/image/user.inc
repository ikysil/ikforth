;******************************************************************************
;
;  user.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;
;******************************************************************************

USER_AREA_SIZE          =       0
                        MACRO   _ALLOC SIZE
USER_AREA_SIZE          =       USER_AREA_SIZE + SIZE
                        ENDM    _ALLOC

                        MACRO   _VAR  NAME,SIZE
&NAME&_VAR              =       USER_AREA_SIZE
                        IFNB    <SIZE>
                          _ALLOC  SIZE
                        ELSE
                          _ALLOC  CELL_SIZE
                        ENDIF
                        ENDM    _VAR 

                        MACRO   _ALIGN
USER_AREA_SIZE          =       ( USER_AREA_SIZE / CELL_SIZE + 1 ) * CELL_SIZE
                        ENDM    _ALIGN

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

MAX_FILE_LINE_LENGTH     EQU    1024
                        _VAR    #FILE_LINE
                        _VAR    FILE_LINE,<MAX_FILE_LINE_LENGTH + 1>

                        _VAR    CURRENT

                        _VAR    EXCEPTION_HANDLER

                        _VAR    WIN32_EXCEPTION_CONTEXT,256
                        _VAR    SQUOTE_BUFFER,1024

                        _VAR    POCKET,256

                        _ALIGN

                        _ALLOC  RETURN_STACK_SIZE
                        _VAR    RSTACK

