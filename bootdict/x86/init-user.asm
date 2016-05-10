;  INIT-USER
                $CODE       'INIT-USER',$INIT_USER
                CLD
                MOV         DWORD [EDI + VAR_BASE],10
                MOV         DWORD [EDI + VAR_CURRENT],PFA_$FORTH_WORDLIST + IMAGE_BASE
                $NEXT
