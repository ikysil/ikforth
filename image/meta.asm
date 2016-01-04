;******************************************************************************
;
;  meta.asm
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;
;  This is minimal IKForth kernel, which supports meta-compilation from files.
;
;******************************************************************************
;
;  Register usage:
;  * EDI - UDP user data area pointer
;  * ESI - IP  instruction pointer
;  * ESP - DSP data stack pointer
;  * EBP - RSP return stack pointer
;
;    EBX - W pointer
;
;  * - register should remain unchanged in low-level primitives if
;      such operation is not pritive's function
;
;  All other registers have no special meaning.
;
;******************************************************************************

                        IDEAL
                        P386

                        SEGMENT MAIN USE32

                        ASSUME  CS:MAIN,DS:MAIN,ES:MAIN,SS:MAIN

                        INCLUDE "macro.inc"

;******************************************************************************
;  Header
;******************************************************************************
SIGN:
                        DB      'IKFI'                  ; MAX. 15 bytes !!!

                        DB      16 - ( $ - SIGN ) DUP ( 0 ) 

DESIRED_BASE_EQU        EQU     20000000h
DESIRED_SIZE_EQU        EQU     00040000h               ; 256KB

DATA_STACK_SIZE         EQU     00001000h               ; 4KB
RETURN_STACK_SIZE       EQU     00001000h               ; 4KB

USER_AREA_SIZE0         EQU     00010000h               ; 64KB

                        DD      DESIRED_BASE_EQU        
DESIRED_SIZE_VAR:
                        DD      DESIRED_SIZE_EQU
                        DD      OFFSET START + DESIRED_BASE_EQU
                        DD      OFFSET THREAD_PROC + DESIRED_BASE_EQU
FUNC_TABLE_PTR:
                        DD      0
                        DD      USER_AREA_SIZE0 + USER_AREA_SIZE
                        DD      DATA_STACK_SIZE

;******************************************************************************
;  Include functions table
;******************************************************************************
FUNC_TABLE:
                        INCLUDE "ftable.inc"

;******************************************************************************
;  Include user area variables. These variables are unique to any thread.
;******************************************************************************
                        INCLUDE "user.inc"

;******************************************************************************
;  Include core Forth definitions.
;******************************************************************************
                        ALIGN   16

                        INCLUDE "words.inc"

START:
                        POPDS   EAX
                        POPDS   <[DWORD PTR SF_VAR + DESIRED_BASE_EQU]>
                        POPDS   <[DWORD PTR #SF_VAR + DESIRED_BASE_EQU]>
                        PUSHDS  EAX
                        PUSHDS  EBX
                        PUSHDS  <[DWORD PTR MAIN_PROC + DESIRED_BASE_EQU]>
                        PUSHDS  FALSE
                        PUSHDS  0
                        MOV     EBX,[DWORD PTR FUNC_TABLE_PTR + DESIRED_BASE_EQU]
                        ADD     EBX,START_THREAD_FUNC * CELL_SIZE
                        CALL    [DWORD PTR EBX]
                        POPDS   EBX
                        RET

                        $COLON  'DO-FORTH',$DO_FORTH,VEF_HIDDEN
                        CW      $INIT_USER
                        CW      $SF
                        CW      $FETCH
                        CW      $#SF
                        CW      $FETCH
                        CW      $LIT
                        CW      $INCLUDED
                        CW      $CATCH
                        CW      $QBRANCH
                        CW      DO_FORTH_NO_EXCEPTIONS
                        $CR
                        $WRITE  <Exception caught while INCLUDing [>
                        CW      $SF
                        CW      $FETCH
                        CW      $#SF
                        CW      $FETCH
                        CW      $TYPE
                        $WRITE  <]>
                        CW      $2DROP
                        $CR
                        $WRITE  <Latest vocabulary entry: >
                        CW      $LATEST_FETCH
                        CW      $1ADD
                        CW      $COUNT
                        CW      $TYPE
                        $CR
DO_FORTH_NO_EXCEPTIONS:
                        CW      $PBYE
                        CW      $EXIT

LATEST_WORD             = VOC_LINK
HERE:

                        ENDS    MAIN
                        END     START
