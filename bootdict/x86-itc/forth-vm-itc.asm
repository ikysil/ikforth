;******************************************************************************
;
;  forth-vm-itc.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Words and definitions for ITC (Indirect Threaded Code) system
;******************************************************************************

;******************************************************************************
;  Inner interpreter for ITC (Indirect Threaded Code)
;******************************************************************************

;******************************************************************************
;  Jump to code address of xt
;  EAX contains the xt
;******************************************************************************
                MACRO       $JMP {
                MOV         EBX,DWORD [EAX]
                JMP         EBX                     ; execute
                }

;******************************************************************************
;  Because of usage of indirect threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Fetch xt from DWORD [ESI] to EAX then JMP to code address stored at DWORD [EAX]
;******************************************************************************
                MACRO       $NEXT {
                LODSD                           ; fetch address
                $JMP
                }

;******************************************************************************
;  Build ITC CFA field - put an address of CODE
;******************************************************************************
                MACRO       $CFA CODE,START_LBL {

                $DEFLABEL   CFA,START_LBL,DEBUG

                DD          CODE + IMAGE_BASE
                }

CFA_CODE_OFFSET         EQU     0
CFA_SIZE                EQU     CELL_SIZE

                MACRO       INCLUDE_HEADER_TC {
                INCLUDE     "header-itc.asm"
                }
