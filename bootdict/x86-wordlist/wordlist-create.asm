;  LATEST-NAME@
;  nt is the NAME TOKEN of the last compiled word in compilation wordlist.
;  D: -- nt
                $CODE       'LATEST-NAME@',$LATEST_NAME_FETCH
                MOV         EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                PUSHDS      <DWORD [EAX]>
                $NEXT

;  LATEST-NAME!
;  nt is the NAME TOKEN of the last compiled word in compilation wordlist.
;  D: nt --
                $CODE       'LATEST-NAME!',$LATEST_NAME_STORE
                MOV         EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                POPDS       <DWORD [EAX]>
                $NEXT
