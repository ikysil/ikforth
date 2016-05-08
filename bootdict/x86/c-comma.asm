;  6.1.0860 C,
;  Reserve one character of data space and store x in the character
;  D: x --
                $CODE       'C,',$CCOMMA
                POPDS       EAX
                MOV         EBX,DWORD [VAR_DP + IMAGE_BASE]
                MOV         BYTE [EBX],AL
                INC         DWORD [VAR_DP + IMAGE_BASE]
                $NEXT
