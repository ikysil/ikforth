;******************************************************************************
;
;  user.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
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
                        _VAR    STATE
                        _VAR    BASE
                        _VAR    TOIN
                        _VAR    SOURCE_ID
                        _VAR    CASE_SENSITIVE
                        _VAR    TONUMBER_SIGNED
                        _VAR    #EVAL
                        _VAR    EVAL

                        _VAR    CURR_FILE_POS
                        _ALLOC  CELL_SIZE

MAX_LINE_LENGTH         EQU     128
                        _VAR    #LINE
                        _VAR    LINE,<MAX_LINE_LENGTH + 1>

MAX_TIB_LENGTH          EQU     128
                        _VAR    #TIB
                        _VAR    TIB,<MAX_TIB_LENGTH + 1>

                        _VAR    CURRENT

                        _VAR    BLK

                        _VAR    BLOCK_NUM
                        _VAR    BLOCK_UPDATED
                        _VAR    BLOCK,<1024 + 1>

                        _VAR    EXCEPTION_HANDLER
                        _VAR    THROW_ADDRESS
                        _VAR    THROW_WORD

                        _VAR    SQUOTE_BUFFER,1024

                        _VAR    POCKET,256

                        _ALIGN

                        _ALLOC  RETURN_STACK_SIZE
                        _VAR    RSTACK
