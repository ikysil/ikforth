;******************************************************************************
;
;  user.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;
;******************************************************************************

USER_HERE = 0
                MACRO       _ALLOC SIZE {
                USER_HERE = USER_HERE + SIZE
                }

                MACRO       _VAR NAME,SIZE {
                LABEL       VAR_#NAME DWORD AT USER_HERE
                IF          ~ SIZE eq
                _ALLOC      SIZE
                ELSE
                _ALLOC      CELL_SIZE
                END IF
                }

                MACRO       _ALIGN {
                USER_HERE = ( USER_HERE / CELL_SIZE + 1 ) * CELL_SIZE
                }

                POSTPONE {
                USER_AREA_SIZE = USER_HERE
                }

                _VAR        RETURN_ADDR
                _VAR        EDI
                _VAR        ESI
                _VAR        EBP
                _VAR        EBX
                _VAR        ESP
                _VAR        BASE
                _VAR        TOIN
                _VAR        SOURCE_ID
                _VAR        REFILL_SOURCE,CELL_SIZE * 2
                _VAR        INCLUDE_LINE_NUM
                _VAR        ERROR_LINE_NUM
                _VAR        INCLUDE_MARK
                _VAR        CASE_SENSITIVE
                _VAR        TONUMBER_SIGNED

                _VAR        CURR_FILE_POS,CELL_SIZE * 2

                _VAR        HASH_FILE_LINE
                ; buffer for REFILL-FILE
                _VAR        FILE_LINE,MAX_FILE_LINE_LENGTH
                ; The line buffer provided by c-addr should be at least u1+2 characters long.
                _VAR        FILE_LINE_OVERRUN,CELL_SIZE

                _VAR        HASH_INTERPRET_TEXT
                _VAR        INTERPRET_TEXT,MAX_FILE_LINE_LENGTH

                _VAR        CURRENT

                _VAR        RECURSE_XT

                _VAR        DEFER_XT

                _VAR        EXCEPTION_HANDLER
                _VAR        EXCP

                _ALIGN
                _ALLOC      EXCEPTION_STACK_SIZE
                _VAR        EXC_STACK

                _ALIGN
                _VAR        WIN32_EXCEPTION_CONTEXT,256

;  Buffers for S"
                _ALIGN
                _VAR        SQBUFFER,SLSQBUFFER * SLSQINDEX

                _ALIGN
                _VAR        POCKET,SLPOCKET

                _ALIGN
                _ALLOC      RETURN_STACK_SIZE
                _VAR        RSTACK
