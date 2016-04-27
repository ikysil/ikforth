;  (NAME=)
;  S: c-addr1 u1 c-addr2 u2 cs-flag -- flag
;  Compare names, return true if same, false otherwise.
;  Use case sensitive compare if cs-flag is true.
                $CODE       '(NAME=)',$PNAMEEQ
                PUSHRS      EDI
                PUSHRS      ESI
                POPDS       EBX                 ; EBX - cs-flag
                POPDS       EDX                 ; EDX - u2
                POPDS       EDI                 ; EDI - c-addr2
                POPDS       ECX                 ; ECX - u1
                POPDS       ESI                 ; ESI - c-addr1
                MOV         EAX,F_FALSE         ; EAX - result
                CMP         ECX,EDX
                JNZ         SHORT PNAMEEQ_EXIT  ; jump and return FALSE if length is different
                CMOVG       ECX,EDX             ; ECX = min(u1, u2)
                OR          ECX,ECX
                JZ          SHORT PNAMEEQ_EXIT  ; jump and return FALSE if length = 0
PNAMEEQ_LOOP:
                MOV         AL,BYTE [ESI]
                MOV         AH,BYTE [EDI]
                OR          EBX,EBX
                JNZ         SHORT PNAMEEQ_CS    ; jump if compare is case sensitive
                CALL        UPCASE
                XCHG        AL,AH
                CALL        UPCASE
PNAMEEQ_CS:
                CMP         AL,AH
                MOV         EAX,F_FALSE
                JNZ         SHORT PNAMEEQ_EXIT  ; jump and return FALSE if characters does not match
                INC         ESI
                INC         EDI
                DEC         ECX
                OR          ECX,ECX
                JNZ         SHORT PNAMEEQ_LOOP  ; jump if more characters to compare
                MOV         EAX,F_TRUE          ; return TRUE - all characters matched
PNAMEEQ_EXIT:
                PUSHDS      EAX                 ; EAX - result
                POPRS       ESI
                POPRS       EDI
                $NEXT
