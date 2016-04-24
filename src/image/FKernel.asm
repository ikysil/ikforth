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

                format      binary

                USE32

                ORG         0

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

MAX_FILE_LINE_LENGTH    EQU     1024

;  Number of buffers supported by S"
;  !!! SLSQINDEX MUST be power of 2 !!!
SLSQINDEX               EQU     8

                IF          SLSQINDEX AND (SLSQINDEX - 1) <> 0
                DISPLAY     "ERROR: SLSQINDEX MUST be power of 2"
                ERR
                END IF

;  Size of a buffer supported by S"
SLSQBUFFER      EQU         1024

;  Size of POCKET
SLPOCKET        EQU         256

;******************************************************************************
;  Header
;******************************************************************************
                DB          'IKFI'                  ; MAX. 16 bytes !!!

                ALIGN       16

                DD          DESIRED_BASE_EQU
DESIRED_SIZE_VAR:
                DD          DESIRED_SIZE_EQU
                DD          START + IMAGE_BASE
                DD          WIN32_THREAD_PROC + IMAGE_BASE
                DD          LINUX_THREAD_PROC + IMAGE_BASE
                DD          USER_AREA_SIZE0 + USER_AREA_SIZE
                DD          DATA_STACK_SIZE

;******************************************************************************
;  Include functions table
;******************************************************************************

                INCLUDE     "ftable.asm"

;******************************************************************************
;  Include user area variables. These variables are unique for each thread.
;******************************************************************************
                INCLUDE     "user.asm"

;******************************************************************************
;  Include Forth definitions.
;******************************************************************************
;                ALIGN       16

                INCLUDE     "wordlist-def.asm"
                INCLUDE     "tc-def.asm"
                INCLUDE     "tc-trace.asm"
                INCLUDE     "forth-vm.asm"
                INCLUDE     "forth-vm-notc.asm"

                MATCH       =DTC, CODE_THREADING {
                INCLUDE     "forth-vm-dtc.asm"
                }

                MATCH       =ITC, CODE_THREADING {
                INCLUDE     "forth-vm-itc.asm"
                }

                INCLUDE     "words.asm"

START:
; typedef struct _MainProcContext {
;     int           argc;
;     char const ** argv;
;     char const ** envp;
;     char const *  startFileName;
;     int           startFileNameLength;
;     int  const *  exitCode;
;     void const ** sysfunctions;
; } MainProcContext;
;
; typedef void __stdcall (* MainProc)(MainProcContext *);
                POP         EAX     ; move return address away
                POP         ESI     ; get address of MainProcContext
                PUSH        EAX
                MOV         EBX,IMAGE_BASE
                CLD
                LEA         EDI,[EBX + ARGC_VAR]
                MOVSD
                LEA         EDI,[EBX + ARGV_VAR]
                MOVSD
                LEA         EDI,[EBX + ENVP_VAR]
                MOVSD
                LEA         EDI,[EBX + SF_VAR]
                MOVSD
                LEA         EDI,[EBX + HASH_SF_VAR]
                MOVSD
                LEA         EDI,[EBX + EXIT_CODE_VAR]
                MOVSD
                LEA         EDI,[EBX + FUNC_TABLE_VAR]
                MOVSD
                MOV         EAX,DWORD [EBX + MAIN_PROC_VAR]
                PUSH        EAX
                PUSH        F_FALSE
                PUSH        0
                $CSYSCALL   START_THREAD
                RET

                $COLON      'DO-FORTH',$DO_FORTH,VEF_HIDDEN
                CW          $INIT_USER
                CFETCH      $SF
                CFETCH      $HASH_SF
                CWLIT       $INCLUDED
                CW          $CATCH, $DUP, $EXIT_CODE, $STORE, $QDUP
                CQBR        DO_FORTH_NO_EXCEPTIONS
                $CR
                $CR
                $WRITE      'Exception caught while INCLUDing ['
                CFETCH      $SF
                CFETCH      $HASH_SF
                CW          $TYPE
                $WRITE      ']'
                $CR
                $WRITE      'Exception: H# '
                CW          $HOUT8
                $CR
                CW          $2DROP
                $WRITE      'HERE:      H# '
                CW          $HERE, $HOUT8
                $CR
                $WRITE      'Latest word searched: '
                CW          $POCKET, $COUNT, $TYPE
                $CR
                $WRITE      'Latest vocabulary entry: '
                CW          $LATEST_HEAD_FETCH, $H_TO_HASH_NAME, $DUP, $ZERONOEQ
                _IF         BOOTSTRAP_ERROR_HAS_NAME
                CW          $TYPE
                _ELSE       BOOTSTRAP_ERROR_HAS_NAME
                CW          $2DROP
                $WRITE      '(nonamed)'
                _THEN       BOOTSTRAP_ERROR_HAS_NAME
                $CR
                $WRITE      'Error in: '
                CW          $REPORT_SOURCE
                $CR
                $CR
DO_FORTH_NO_EXCEPTIONS:
                CW      $PBYE

LATEST_WORD     = VOC_LINK
HERE:
