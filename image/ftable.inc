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
FUNC_AREA_SIZE          =       0
                        MACRO   FUNC_ALLOC SIZE
FUNC_AREA_SIZE          =       FUNC_AREA_SIZE + SIZE
                        ENDM    FUNC_ALLOC

                        MACRO   $FUNC NAME
&NAME&_FUNC             =       FUNC_AREA_SIZE
                        FUNC_ALLOC  1
                        ENDM    $FUNC

                        MACRO   FUNC_ALIGN
FUNC_AREA_SIZE          =       ( FUNC_AREA_SIZE / CELL_SIZE + 1 ) * CELL_SIZE
                        ENDM    FUNC_ALIGN

                        MACRO   $CALL NAME
                        PUSHRS  EDI
                        MOV     EBX,[DWORD PTR FUNC_TABLE_PTR + DESIRED_BASE_EQU]
                        MOV     EBX,[DWORD PTR EBX + &NAME * CELL_SIZE]
                        CALL    EBX
                        POPRS   EDI
                        ENDM    $CALL

                        $FUNC   GET_LAST_ERROR
                        $FUNC   LOAD_LIBRARY
                        $FUNC   FREE_LIBRARY
                        $FUNC   GET_PROC_ADDRESS
                        $FUNC   BYE
                        $FUNC   EMIT
                        $FUNC   TYPE
                        $FUNC   ACCEPT
                        $FUNC   READ_BLOCK
                        $FUNC   WRITE_BLOCK
                        $FUNC   FILE_CLOSE
                        $FUNC   FILE_CREATE
                        $FUNC   FILE_POSITION
                        $FUNC   FILE_OPEN
                        $FUNC   FILE_READ
                        $FUNC   FILE_REPOSITION
                        $FUNC   FILE_WRITE
                        $FUNC   FILE_READ_LINE
                        $FUNC   FILE_RESIZE
                        $FUNC   AT_XY
                        $FUNC   START_THREAD
                        $FUNC   COMPARE
                        $FUNC   PAGE
                        $FUNC   ALLOCATE
                        $FUNC   FREE
                        $FUNC   REALLOCATE
