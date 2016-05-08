;  INIT-USER
                $CODE       'INIT-USER',$INIT_USER
                CLD
                MOV         DWORD [EDI + VAR_BASE],10
                MOV         DWORD [EDI + VAR_CURRENT],FORTH_WORDLIST_EQU + IMAGE_BASE
                $NEXT
