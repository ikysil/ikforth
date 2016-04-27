;  (PARSE)
;  ( char c-addr1 u1 -- c-addr2 u2 )
;  Parse c-addr1 u1 delimited by the delimiter char.
                $CODE       '(PARSE)',$PPARSE
                PUSHRS      ESI
                POPDS       ECX                     ; ECX - u1
                POPDS       ESI                     ; ESI - c-addr1 - source address
                POPDS       EDX                     ; EDX - char
                PUSHDS      ESI                     ; c-addr2
                XOR         EBX,EBX
PPARSE_LOOP:
                DEC         ECX
                JS          SHORT PPARSE_EXIT
                LODSB
                OR          AL,AL
                JZ          SHORT PPARSE_EXIT
                CMP         AL,DL
                JZ          SHORT PPARSE_EXIT
                INC         EBX
                JMP         SHORT PPARSE_LOOP
PPARSE_EXIT:
                PUSHDS      EBX
                POPRS       ESI
                $NEXT
