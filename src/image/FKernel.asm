;******************************************************************************
;
;  FKernel.asm
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;
;  Minimal IKForth kernel, which supports compilation from files.
;
;******************************************************************************

                        format  binary

                        USE32

                        ORG     0

DESIRED_BASE_EQU        EQU     20000000h

IMAGE_BASE              =       DESIRED_BASE_EQU

DESIRED_SIZE_EQU        EQU     00040000h               ; 256KB

DATA_STACK_SIZE         EQU     00001000h               ; 4KB
RETURN_STACK_SIZE       EQU     00001000h               ; 4KB
EXCEPTION_STACK_SIZE    EQU     00001000h               ; 4KB

USER_AREA_SIZE0         EQU     00020000h               ; 128KB

F_TRUE                  EQU     0FFFFFFFFh
F_FALSE                 EQU     0

CELL_SIZE               EQU     4

;******************************************************************************
;  Header
;******************************************************************************
                        DB      'IKFI'                  ; MAX. 15 bytes !!!

                        ALIGN   16

                        DD      DESIRED_BASE_EQU
CFA_DESIRED_SIZE_VAR:
                        DD      DESIRED_SIZE_EQU
                        DD      START       + IMAGE_BASE
                        DD      THREAD_PROC + IMAGE_BASE
                        DD      FUNC_TABLE  + IMAGE_BASE
                        DD      USER_AREA_SIZE0 + USER_AREA_SIZE
                        DD      DATA_STACK_SIZE

;******************************************************************************
;  Include functions table
;******************************************************************************
;                        ALIGN   16

                        INCLUDE "ftable.inc"

;******************************************************************************
;  Include user area variables. These variables are unique for each thread.
;******************************************************************************
                        INCLUDE "user.inc"

;******************************************************************************
;  Include Forth definitions.
;******************************************************************************
;                        ALIGN   16

                        INCLUDE "wordlist-def.asm"
                        INCLUDE "tc-def.asm"
                        INCLUDE "tc-trace.asm"
                        INCLUDE "forth-vm.asm"

                        IF      ~ DEFINED CODE_THREADING
                CODE_THREADING  EQU DTC
                        END IF

                        MATCH   =DTC, CODE_THREADING {
                        INCLUDE "forth-vm-dtc.asm"
                        }

                        MATCH   =ITC, CODE_THREADING {
                        INCLUDE "forth-vm-itc.asm"
                        }

                        INCLUDE "words.inc"

START:
; typedef struct _MainProcContext {
;     int           argc;
;     char const ** argv;
;     char const ** envp;
;     char const *  startFileName;
;     int           startFileNameLength;
;     int  const *  exitCode;
; } MainProcContext;
;
; typedef void __stdcall (* MainProc)(MainProcContext *);
                        POP     EAX     ; move return address away
                        POP     ESI     ; get address of MainProcContext
                        PUSH    EAX
                        MOV     EBX,IMAGE_BASE
                        CLD
                        LEA     EDI,[EBX + ARGC_VAR]
                        MOVSD
                        LEA     EDI,[EBX + ARGV_VAR]
                        MOVSD
                        LEA     EDI,[EBX + ENVP_VAR]
                        MOVSD
                        LEA     EDI,[EBX + SF_VAR]
                        MOVSD
                        LEA     EDI,[EBX + HASH_SF_VAR]
                        MOVSD
                        LEA     EDI,[EBX + EXIT_CODE_VAR]
                        MOVSD
                        MOV     EAX,DWORD [MAIN_PROC_VAR + IMAGE_BASE]
                        PUSH    EAX
                        PUSH    F_FALSE
                        PUSH    0
                        MOV     EAX,DWORD [FUNC_TABLE + IMAGE_BASE + FUNC_START_THREAD * CELL_SIZE]
                        CALL    EAX
                        RET

                        $COLON  'DO-FORTH',$DO_FORTH,VEF_HIDDEN

                        CW      $INIT_USER
                        CFETCH  $SF
                        CFETCH  $HASH_SF
                        CWLIT   $INCLUDED
                        CW      $CATCH
                        CW      $DUP
                        CW      $EXIT_CODE
                        CW      $STORE
                        CQBR    DO_FORTH_NO_EXCEPTIONS
                        $CR
                        $WRITE  'Exception caught while INCLUDing ['
                        CFETCH  $SF
                        CFETCH  $HASH_SF
                        CW      $TYPE
                        $WRITE  ']'
                        CW      $2DROP
                        $CR
                        $WRITE  'Latest word searched: '
                        CW      $POCKET
                        CW      $COUNT
                        CW      $TYPE
                        $CR
                        $WRITE  'Latest vocabulary entry: '
                        CW      $LATEST_HEAD_FETCH
                        CW      $H_TO_HASH_NAME
                        CW      $DUP
                        CW      $ZERONOEQ
                        CQBR    NO_TYPE
                        CW      $TYPE
                        CBR     DO_CR
NO_TYPE:
                        CW      $2DROP
                        $WRITE  '(nonamed)'
DO_CR:
                        $CR
DO_FORTH_NO_EXCEPTIONS:
                        CW      $PBYE

LATEST_WORD             = VOC_LINK
CFA_HERE:
