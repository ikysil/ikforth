;  SEARCH-HEADERS
;  D: ( c-addr u lfa-addr -- 0 | xt 1 | xt -1 )
                $CODE       'SEARCH-HEADERS',$SEARCH_HEADERS
                PUSHRS      EDI
                PUSHRS      ESI
                POPDS       ESI                     ; LATEST word link
                MOV         EBX,DWORD [EDI + VAR_CASE_SENSITIVE]
                POPDS       ECX                     ; u
                POPDS       EDI                     ; c-addr
SW_LOOP:
                OR          ESI,ESI
                JZ          SHORT SW_NOT_FOUND
                MOV         AX,WORD [ESI]
                CMP         AH,CL
                JNZ         SHORT SW_NEXT
                TEST        AL,VEF_HIDDEN
                JNZ         SHORT SW_NEXT
                PUSHDS      ESI
                PUSHDS      EDI
                PUSHDS      ECX
                ADD         ESI,2
CMP_LOOP:
                MOV         AL,BYTE [ESI]
                MOV         AH,BYTE [EDI]
                OR          EBX,EBX
                JNZ         SHORT CMP_CONT
                CALL        UPCASE
                XCHG        AL,AH
                CALL        UPCASE
CMP_CONT:
                CMP         AL,AH
                JNZ         SHORT CMP_EXIT
                INC         ESI
                INC         EDI
                DEC         ECX
                OR          ECX,ECX
                JNZ         SHORT CMP_LOOP
                CMP         AL,AH
                POPDS       ECX
                POPDS       EDI
                POPDS       ESI
                JZ          SHORT SW_FOUND
CMP_EXIT:
                POPDS       ECX
                POPDS       EDI
                POPDS       ESI
SW_NEXT:
                MOVZX       EAX,BYTE [ESI + 1]
                ADD         ESI,EAX
                ADD         ESI,3
                MOV         ESI,DWORD [ESI]
                JMP         SHORT SW_LOOP

SW_FOUND:
                MOV         AL,BYTE [ESI]
                TEST        AL,VEF_IMMEDIATE
                MOV         EAX,1
                JNZ         SHORT SW_FOUND_IMMEDIATE
                NEG         EAX
SW_FOUND_IMMEDIATE:
                MOVZX       EBX,BYTE [ESI + 1]
                ADD         ESI,EBX
                ADD         ESI,7
                PUSHDS      ESI
                PUSHDS      EAX
                POPRS       ESI
                POPRS       EDI
                $NEXT

SW_NOT_FOUND:
                PUSHDS      0
                POPRS       ESI
                POPRS       EDI
                $NEXT
