;  6.1.0710 ALLOT
;  Allocates n memory cells on the top of vocabulary
;  D: n --
                $CODE       'ALLOT',$ALLOT
                POPDS       EAX
                ADD         DWORD [VAR_DP + IMAGE_BASE],EAX
                $NEXT
