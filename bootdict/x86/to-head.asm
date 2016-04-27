;  >HEAD
;  D: xt -- h-id
;  h-id is the address of vocabulary entry flags
                $CODE       '>HEAD',$TO_HEAD
                POPDS       EAX
                SUB         EAX,5
                XOR         EBX,EBX
                MOV         BL,BYTE [EAX]
                SUB         EAX,EBX
                PUSHDS      EAX
                $NEXT
