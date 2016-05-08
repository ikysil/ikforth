;  Convert a byte to hex characters so that B>H EMIT EMIT sequence
;  will print the representation of the value.
;  S: a -- ca cb
                $CODE       'B>H',$BTOH
                LEA         EDX,[DIGITS_TABLE + IMAGE_BASE]
                POPDS       EAX
                XOR         ECX,ECX
                MOV         EBX,EAX
                AND         EBX,0x0F
                MOV         CL,BYTE [EDX + EBX]
                PUSHDS      ECX
                SHR         EAX,4
                MOV         EBX,EAX
                AND         EBX,0x0F
                MOV         CL,BYTE [EDX + EBX]
                PUSHDS      ECX
                $NEXT
