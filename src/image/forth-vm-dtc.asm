;******************************************************************************
;
;  forth-vm-dtc.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Words and definitions for DTC (Direct Threaded Code) system
;******************************************************************************

;******************************************************************************
;  Inner interpreter for DTC (Direct Threaded Code)
;******************************************************************************

;******************************************************************************
;  Jump to code address of xt
;  EAX contains an xt
;******************************************************************************
                MACRO       $JMP {
                MOV         EBX,EAX
                JMP         EBX                     ; execute
                }

;******************************************************************************
;  Because of usage of direct threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Fetch xt from DWORD [ESI] to EAX then JMP to fetched address
;******************************************************************************
                MACRO       $NEXT {
                LODSD                           ; fetch address
                $JMP
                }

;******************************************************************************
;  Build DTC CFA field - put JMP to an address of CODE
;  x86 is lacking the JMP abs-addr instruction
;  workaround 1:
;  PUSH abs-addr
;  RET
;
;  workaround 2:
;  MOV  EBX,abs-addr
;  JMP  EBX
;
;  THIS CODE SNIPPET MUST PRESERVE EAX
;
;******************************************************************************
                MACRO       $CFA CODE,START_LBL,CODE_ADDR_END_LBL,END_LBL {
                $DEFLABEL   CFA,START_LBL,DEBUG

                MOV         EBX,DWORD CODE + IMAGE_BASE

                IF          ~ CODE_ADDR_END_LBL eq
                LABEL       CFA_#CODE_ADDR_END_LBL DWORD
                END IF

                JMP         EBX

                IF          ~ END_LBL eq
                LABEL       CFA_#END_LBL DWORD
                END IF
                }

                MACRO       INCLUDE_HEADER_TC {
                INCLUDE     "header-dtc.asm"
                }

                VIRTUAL AT 0
                $CFA    0,VTMPLT_START,VTMPLT_CODE_ADDR_END,VTMPLT_END
CFA_EXECUTOR_OFFSET     EQU     CFA_VTMPLT_CODE_ADDR_END - CFA_VTMPLT_START - 4
CFA_SIZE                EQU     CFA_VTMPLT_END - CFA_VTMPLT_START
                END VIRTUAL
