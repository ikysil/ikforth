;  WID>VT
;  D: ( wid -- wid-vt-addr )
                $CODE       'WID>VT',$WID_TO_VT
                POPDS       EAX
                ADD         EAX,FORTH_WORDLIST_VT - FORTH_WORDLIST_EQU
                PUSHDS      EAX
                $NEXT
