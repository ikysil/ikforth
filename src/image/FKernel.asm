;******************************************************************************
;
;  FKernel.asm
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;
;  Minimal IKForth kernel, which supports compilation from files.
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
;  * - register should remain unchanged in low-level primitives
;
;  All other registers have no special meaning.
;
;******************************************************************************

                        IDEAL
                        P386

                        SEGMENT MAIN USE32

                        ASSUME  CS:MAIN,DS:MAIN,ES:MAIN

                        INCLUDE "macro.inc"

;******************************************************************************
;  Header
;******************************************************************************
SIGN:
                        DB      'IKFI'                  ; MAX. 15 bytes !!!

                        DB      16 - ( $ - SIGN ) DUP ( 0 ) 

DESIRED_BASE_EQU        EQU     20000000h
DESIRED_SIZE_EQU        EQU     00040000h               ; 256KB

DATA_STACK_SIZE         EQU     00004000h               ; 16KB
RETURN_STACK_SIZE       EQU     00004000h               ; 16KB

USER_AREA_SIZE0         EQU     00020000h               ; 128KB

                        DD      DESIRED_BASE_EQU
DESIRED_SIZE_VAR:
                        DD      DESIRED_SIZE_EQU
                        DD      OFFSET START + DESIRED_BASE_EQU
                        DD      OFFSET THREAD_PROC + DESIRED_BASE_EQU
                        DD      OFFSET FUNC_TABLE + DESIRED_BASE_EQU
                        DD      USER_AREA_SIZE0 + USER_AREA_SIZE
                        DD      DATA_STACK_SIZE

;******************************************************************************
;  Include functions table
;******************************************************************************
;                        ALIGN   16

                        INCLUDE "ftable.inc"

;******************************************************************************
;  Include user area variables. These variables are unique to any thread.
;******************************************************************************
                        INCLUDE "user.inc"

;******************************************************************************
;  Include Forth definitions.
;******************************************************************************
;                        ALIGN   16

                        INCLUDE "words.inc"

START:
                        POPDS   EAX
                        POPDS   <[DWORD PTR SF_VAR + DESIRED_BASE_EQU]>
                        POPDS   <[DWORD PTR #SF_VAR + DESIRED_BASE_EQU]>
                        PUSHDS  EAX
                        PUSHDS  <[DWORD PTR MAIN_PROC + DESIRED_BASE_EQU]>
                        PUSHDS  F_FALSE
                        PUSHDS  0
                        CALL    [DWORD PTR FUNC_TABLE + DESIRED_BASE_EQU + START_THREAD_FUNC * CELL_SIZE]
                        RET

                        $COLON  'DO-FORTH',$DO_FORTH,VEF_HIDDEN
                        CW      $INIT_USER
                        CW      $SF
                        CW      $FETCH
                        CW      $#SF
                        CW      $FETCH
                        CWLIT   $INCLUDED
                        CW      $CATCH
                        CQBR    DO_FORTH_NO_EXCEPTIONS
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
                        $WRITE  <Latest word searched: >
                        CW      $POCKET
                        CW      $COUNT
                        CW      $TYPE
                        $CR
                        $WRITE  <Latest vocabulary entry: >
                        CW      $LATEST_HEAD_FETCH
                        CW      $H_TO_HASH_NAME
                        CW      $DUP
                        CW      $ZERONOEQ
                        CQBR    NO_TYPE
                        CW      $TYPE
                        CBR     DO_CR
NO_TYPE:
                        CW      $2DROP
                        $WRITE  <(nonamed)>
DO_CR:
                        $CR
DO_FORTH_NO_EXCEPTIONS:
                        CW      $PBYE
                        CW      $EXIT

LATEST_WORD             = VOC_LINK
HERE:

                        ENDS    MAIN
                        END     START

