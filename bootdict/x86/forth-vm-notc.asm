;******************************************************************************
;
;  forth-vm-notc.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Stop assembling if threading code model is not defined
;******************************************************************************
                MACRO       $CFA [ARGS] {
                DISPLAY     "ERROR: CODE_THREADING not defined"
                ERR
                }

                MACRO       $JMP [ARGS] {
                DISPLAY     "ERROR: CODE_THREADING not defined"
                ERR
                }

                MACRO       $NEXT [ARGS] {
                DISPLAY     "ERROR: CODE_THREADING not defined"
                ERR
                }
