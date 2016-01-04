;******************************************************************************
;
;  ftable.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Functions provided by loader.
;  Define these functions as stdcall.
;  First argument is on the top of the data stack.
;  Result ( if any ) is returned via EAX ( int ), EDX:EAX ( long int ).
;******************************************************************************
FUNC_NUM                =       0
             FUNC_ALLOC MACRO   SIZE
                        DD      0
FUNC_NUM                =       FUNC_NUM + SIZE
                        ENDM    FUNC_ALLOC

                  $FUNC MACRO   NAME
&NAME&_FUNC             =       FUNC_NUM
                        FUNC_ALLOC  1
                        ENDM    $FUNC

             FUNC_ALIGN MACRO
FUNC_NUM                =       ( FUNC_NUM / CELL_SIZE + 1 ) * CELL_SIZE
                        ENDM    FUNC_ALIGN

                  $CALL MACRO   NAME
                        PUSHRS  EDI
                        MOV     EAX,DWORD PTR [FUNC_TABLE - SIGN + DESIRED_BASE_EQU + &NAME * CELL_SIZE]
                        CALL    EAX
                        POPRS   EDI
                        ENDM    $CALL

FUNC_TABLE:
                        $FUNC   LOAD_LIBRARY
                        $FUNC   FREE_LIBRARY
                        $FUNC   GET_PROC_ADDRESS
                        $FUNC   BYE
                        $FUNC   EMIT
                        $FUNC   TYPE
                        $FUNC   FILE_CLOSE
                        $FUNC   FILE_CREATE
                        $FUNC   FILE_POSITION
                        $FUNC   FILE_OPEN
                        $FUNC   FILE_REPOSITION
                        $FUNC   FILE_READ_LINE
                        $FUNC   START_THREAD
                        $FUNC   PAGE
                        $FUNC   ALLOCATE
                        $FUNC   FREE
                        $FUNC   REALLOCATE

