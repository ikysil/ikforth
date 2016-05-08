;  Split TOS into 4 bytes with most significant byte at TOS.
;  S: a -- e d c b
                $CODE       'SPLIT-8',$SPLIT8
                POPDS       EAX
                XOR         ECX,ECX
                MOV         CL,AL
                PUSH        ECX
                MOV         CL,AH
                PUSH        ECX
                SHR         EAX,16
                MOV         CL,AL
                PUSH        ECX
                MOV         CL,AH
                PUSH        ECX
                $NEXT
