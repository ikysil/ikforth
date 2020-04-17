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
