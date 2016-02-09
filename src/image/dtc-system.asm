;******************************************************************************
;
;  dtc-system.asm
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
                        MACRO   $JMP {
                        MOV     EBX,EAX
                        JMP     EBX                     ; execute
                        }

;******************************************************************************
;  Because of usage of direct threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Fetch xt from DWORD [ESI] to EAX then JMP to fetched address
;******************************************************************************
                        MACRO   $NEXT {
                        LODSD                           ; fetch address
                        $JMP
                        }

;******************************************************************************
;  Build DTC CFA field - put JMP to an address of CODE
;******************************************************************************
                        MACRO   $CFA CODE,START_LBL,CODE_ADDR_END_LBL,END_LBL {
                        IF      ~ START_LBL eq
                        LABEL   CFA_#START_LBL DWORD
                        END IF

                        ;PUSH    DWORD CODE + IMAGE_BASE
                        MOV     EBX,DWORD CODE + IMAGE_BASE

                        IF      ~ CODE_ADDR_END_LBL eq
                        LABEL   CFA_#CODE_ADDR_END_LBL DWORD
                        END IF

                        JMP     EBX
                        ;RET

                        IF      ~ END_LBL eq
                        LABEL   CFA_#END_LBL DWORD
                        END IF
                        }

;******************************************************************************
;  HEADER & support words - implementation for DTC (Direct Threaded Code)
;******************************************************************************

                        $CFA    -IMAGE_BASE,TMPLT_START,TMPLT_CODE_ADDR_END,TMPLT_END

CFA_EXECUTOR_OFFSET     EQU     CFA_TMPLT_CODE_ADDR_END - CFA_TMPLT_START - 4
CFA_SIZE                EQU     CFA_TMPLT_END - CFA_TMPLT_START

;  CFA@
;  D: xt -- code-addr
;  code-addr is the code address of the word xt
                        $COLON  'CFA@',$CFAFETCH
                        CCLIT   CFA_EXECUTOR_OFFSET
                        CW      $ADD
                        CW      $FETCH
                        CEXIT

;  CFA!
;  D: code-addr xt --
;  Change a code address of the word xt to code-addr
                        $COLON  'CFA!',$CFASTORE
                        CCLIT   CFA_EXECUTOR_OFFSET
                        CW      $ADD
                        CW      $STORE
                        CEXIT

;  CODE-ADDRESS!
;  D: code-addr xt --
;  Create a code field with code address code-addr at xt
                        $COLON  'CODE-ADDRESS!',$CODE_ADDRESS_STORE
                        CW      $DUP
                        ; D: code-addr xt xt
                        CWLIT   TMPLT_START
                        ; D: code-addr xt xt CFA_START
                        CW      $SWAP
                        ; D: code-addr xt CFA_START xt
                        CW      $CFA_SIZE
                        ; D: code-addr xt CFA_START xt CFA_SIZE
                        CW      $CMOVE
                        ; D: code-addr xt
                        CW      $CFASTORE
                        CEXIT

;  6.1.0550 >BODY
;  Convert CFA to PFA
;  D: CFA -- PFA
                        $COLON  '>BODY',$TOBODY
                        CCLIT   CFA_SIZE
                        CW      $ADD
                        CEXIT

                        $CONST  'HOST-ITC?'
                        CC      F_FALSE

                        $CONST  'HOST-DTC?'
                        CC      F_TRUE
