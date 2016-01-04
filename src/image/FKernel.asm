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

                        .386P
                        .MODEL  FLAT

                   MAIN SEGMENT USE32

                        ASSUME  CS:MAIN,DS:MAIN,ES:MAIN

                        ORG     0h

;******************************************************************************
;  Header
;******************************************************************************
SIGN                    =       1000h 
                        DB      'IKFI'                  ; MAX. 15 bytes !!!

                        ALIGN   16

DESIRED_BASE_EQU        EQU     20000000h

IMAGE_BASE              =       DESIRED_BASE_EQU - SIGN

DESIRED_SIZE_EQU        EQU     00040000h               ; 256KB

DATA_STACK_SIZE         EQU     00004000h               ; 16KB
RETURN_STACK_SIZE       EQU     00004000h               ; 16KB

USER_AREA_SIZE0         EQU     00020000h               ; 128KB

                        DD      DESIRED_BASE_EQU
DESIRED_SIZE_VAR:
                        DD      DESIRED_SIZE_EQU
                        DD      START       + IMAGE_BASE
                        DD      THREAD_PROC + IMAGE_BASE
                        DD      FUNC_TABLE  + IMAGE_BASE
                        DD      USER_AREA_SIZE0 + USER_AREA_SIZE
                        DD      DATA_STACK_SIZE

                        INCLUDE "macro.inc"

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
                        POPDS   [SF_VAR + IMAGE_BASE]
                        POPDS   [HASH_SF_VAR + IMAGE_BASE]
                        PUSHDS  EAX
                        MOV     EAX,[MAIN_PROC_VAR + IMAGE_BASE]
                        PUSHDS  EAX
                        PUSHDS  F_FALSE
                        PUSHDS  0
                        MOV     EAX,[FUNC_TABLE + IMAGE_BASE + START_THREAD_FUNC * CELL_SIZE]
                        CALL    EAX
                        RET

                        $COLON  'DO-FORTH',$DO_FORTH,VEF_HIDDEN

                        CW      $INIT_USER
                        CFETCH  $SF
                        CFETCH  $HASH_SF
                        CWLIT   $INCLUDED
                        CW      $CATCH
                        CQBR    DO_FORTH_NO_EXCEPTIONS
                        $CR
                        $WRITE  <Exception caught while INCLUDing [>
                        CFETCH  $SF
                        CFETCH  $HASH_SF
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

LATEST_WORD             = VOC_LINK
HERE:

                   MAIN ENDS
                        END     START

