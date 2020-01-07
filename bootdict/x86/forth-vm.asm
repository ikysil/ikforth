;******************************************************************************
;
;  forth-vm.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;
;  Register usage:
;  * EDI - UDP user data area pointer
;  * ESI - IP  instruction pointer
;  * ESP - DSP data stack pointer
;  * EBP - RSP return stack pointer
;
;    EAX - W pointer
;
;  * - register should remain unchanged in low-level primitives
;
;  All other registers have no special meaning.
;
;******************************************************************************

;******************************************************************************
;  Data and return stacks manipulations
;******************************************************************************

;******************************************************************************
;  Push a value to return stack
;******************************************************************************
                MACRO       PUSHRS SRC {
                SUB         EBP,CELL_SIZE
                MOV         DWORD [EBP],SRC
                }

;******************************************************************************
;  Pop a value from return stack
;******************************************************************************
                MACRO       POPRS DST {
                MOV         DST,DWORD [EBP]
                ADD         EBP,CELL_SIZE
                }

;******************************************************************************
;  Fetch a value from the return stack
;******************************************************************************
                MACRO       FETCHRS DST,NUM {
                IF          ~ NUM eq
                MOV         DST,DWORD [EBP + NUM * CELL_SIZE]
                ELSE
                MOV         DST,DWORD [EBP]
                END IF
                }

;******************************************************************************
;  Push a value to data stack
;******************************************************************************
                MACRO       PUSHDS SRC {
                PUSH        SRC
                }

;******************************************************************************
;  Pop a value from data stack
;******************************************************************************
                MACRO       POPDS DST {
                POP         DST
                }

;******************************************************************************
;  Fetch a value from the data stack
;******************************************************************************
                MACRO       FETCHDS DST,NUM {
                IF          ~ NUM eq
                MOV         DST,DWORD [ESP + NUM * CELL_SIZE]
                ELSE
                MOV         DST,DWORD [ESP]
                END IF
                }
