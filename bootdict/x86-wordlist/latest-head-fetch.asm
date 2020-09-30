;  LATEST-HEAD@
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: -- addr
                $CODE       'LATEST-HEAD@',$LATEST_HEAD_FETCH
                MOV         EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                PUSHDS      <DWORD [EAX]>
                $NEXT
