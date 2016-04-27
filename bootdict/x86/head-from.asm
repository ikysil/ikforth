;  HEAD>
;  D: h-id -- xt
;  h-id is the address of vocabulary entry flags
                $CODE       'HEAD>',$HEAD_FROM
                POPDS       EAX
                INC         EAX
                XOR         EBX,EBX
                MOV         BL,BYTE [EAX]
                ADD         EAX,EBX
                ADD         EAX,6
                PUSHDS      EAX
                $NEXT
