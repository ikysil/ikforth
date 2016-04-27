;******************************************************************************
;
;  ftable.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Functions provided by loader.
;  Define these functions as stdcall.
;  First argument is on the top of the data stack.
;  Result ( if any ) is returned via EAX ( int ), EDX:EAX ( long int ).
;******************************************************************************
FUNC_NUM        =           0
                MACRO       FUNC_ALLOC SIZE {
                FUNC_NUM = FUNC_NUM + SIZE
                }

                MACRO       $FUNC NAME {
                LABEL       FUNC_#NAME DWORD AT FUNC_NUM
                FUNC_ALLOC  1
                }

                MACRO       FUNC_ALIGN {
                FUNC_NUM = ( FUNC_NUM / CELL_SIZE + 1 ) * CELL_SIZE
                }

FUNC_TABLE_VAR:
                DD          0
                $FUNC       GET_LAST_ERROR
                $FUNC       LOAD_LIBRARY
                $FUNC       FREE_LIBRARY
                $FUNC       GET_PROC_ADDRESS
                $FUNC       BYE
                $FUNC       EMIT
                $FUNC       TYPE
                $FUNC       FILE_CLOSE
                $FUNC       FILE_CREATE
                $FUNC       FILE_POSITION
                $FUNC       FILE_OPEN
                $FUNC       FILE_REPOSITION
                $FUNC       FILE_READ_LINE
                $FUNC       START_THREAD
                $FUNC       ALLOCATE
                $FUNC       FREE
                $FUNC       REALLOCATE
