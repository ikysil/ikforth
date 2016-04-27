;  LATEST-HEAD!
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: addr --
                $CODE       'LATEST-HEAD!',$LATEST_HEAD_STORE
                MOV         EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                POPDS       <DWORD [EAX]>
                $NEXT
