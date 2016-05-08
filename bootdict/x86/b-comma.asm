;  B,
;  Reserve one byte of data space and store x in the byte
;  D: x --
;  Used to compile machine code
                $CODE       'B,',$BCOMMA
                POPDS       EAX
                MOV         EBX,DWORD [VAR_DP + IMAGE_BASE]
                MOV         BYTE [EBX],AL
                INC         DWORD [VAR_DP + IMAGE_BASE]
                $NEXT
