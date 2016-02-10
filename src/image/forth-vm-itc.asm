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
                        MACRO   $JMP {
                        MOV     EBX,DWORD [EAX]
                        JMP     EBX                     ; execute
                        }

;******************************************************************************
;  Because of usage of indirect threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Fetch xt from DWORD [ESI] to EAX then JMP to code address stored at DWORD [EAX]
;******************************************************************************
                        MACRO   $NEXT {
                        LODSD                           ; fetch address
                        $JMP
                        }

;******************************************************************************
;  Build ITC CFA field - put an address of CODE
;******************************************************************************
                        MACRO   $CFA CODE,START_LBL {

                        IF      ~ START_LBL eq
                        LABEL   CFA_#START_LBL DWORD
                        END IF

                        DD      CODE + IMAGE_BASE
                        }

CFA_CODE_OFFSET         EQU     0
CFA_SIZE                EQU     CELL_SIZE

;******************************************************************************
;  HEADER & support words - implementation for ITC (Indirect Threaded Code)
;******************************************************************************

;  CFA@
;  D: xt -- code-addr
;  code-addr is the code address of the word xt
                        $COLON  'CFA@',$CFAFETCH
                        CW      $FETCH
                        CEXIT

;  CFA!
;  D: code-addr xt --
;  Change a code address of the word xt to code-addr
                        $COLON  'CFA!',$CFASTORE
                        CW      $STORE
                        CEXIT

;  CODE-ADDRESS!
;  D: code-addr xt --
;  Create a code field with code address code-addr at xt
;  Alias to CFA! on ITC systems
                        $COLON  'CODE-ADDRESS!',$CODE_ADDRESS_STORE
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
                        CC      F_TRUE

                        $CONST  'HOST-DTC?'
                        CC      F_FALSE
