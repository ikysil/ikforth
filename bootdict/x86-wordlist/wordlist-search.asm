;   PURPOSE: Search words in the wordlist
;   LICENSE: Unlicense since 1999 by Illya Kysil

;  NAME=
;  S: c-addr1 u1 c-addr2 u2 -- flag
;  Compare names, return true if same, false otherwise.
;  Case sensitivity is determined by CASE-SENSITIVE variable.
                $COLON      'NAME=',$NAMEEQ
                CW          $CASE_SENSITIVE, $FETCH, $PNAMEEQ
                $END_COLON

;  STDWL-SEARCH-NAME
;  ( c-addr u 0 nt -- c-addr u false true | xt 1 true false | xt -1 true false )
;  If flag is true, STDWL-TRAVERSE will continue with the next name, otherwise it will return.
;  nt is the address of vocabulary entry flags.
;  If the definition is found, return its execution token xt and one (1) if the definition is immediate, minus-one (-1) otherwise.
                $COLON      'STDWL-SEARCH-NAME',$STDWL_SEARCH_NAME
                CW          $DUP, $HFLAGS_FETCH, $AMPHIDDEN, $AND
                _IF         STDWL_SEARCH_NAME_HIDDEN
                CW          $TWO_DROP, $FALSE, $TRUE, $EXIT
                _THEN       STDWL_SEARCH_NAME_HIDDEN
                CW          $2OVER
                CCLIT       2
                CW          $PICK
                ; S: c-addr u 0 nt c-addr u nt
                CW          $NAME_TO_STRING
                ; S: c-addr u 0 nt c-addr u nt-addr nt-u
                CW          $NAMEEQ
                _IF         STDWL_SEARCH_NAME_FOUND
                ; S: c-addr u 0 nt
                CW          $2SWAP, $TWO_DROP, $NIP
                ; S: nt
                CW          $DUP, $NAME_TO_CODE, $SWAP
                CW          $HFLAGS_FETCH, $AMPIMMEDIATE, $AND
                _IF         STDWL_SEARCH_NAME_IMM
                CCLIT       1
                _ELSE       STDWL_SEARCH_NAME_IMM
                CCLIT       -1
                _THEN       STDWL_SEARCH_NAME_IMM
                CW          $TRUE, $FALSE
                _ELSE       STDWL_SEARCH_NAME_FOUND
                ; S: c-addr u 0 nt
                CW          $TWO_DROP, $FALSE, $TRUE
                _THEN       STDWL_SEARCH_NAME_FOUND
                $END_COLON

;  STDWL-SEARCH
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'STDWL-SEARCH',$STDWL_SEARCH
                CCLIT       0
                CWLIT       $STDWL_SEARCH_NAME
                CW          $ROT, $STDWL_TRAVERSE, $INVERT
                _IF         STDWL_SEARCH_NOT_FOUND
                CW          $TWO_DROP
                CCLIT       0
                _THEN       STDWL_SEARCH_NOT_FOUND
                $END_COLON

;  STDWL-SEARCH-ASM
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'STDWL-SEARCH-ASM',$STDWL_SEARCH_ASM
                CW          $WLTOLATEST, $FETCH
                CW          $SEARCH_HEADERS
                $END_COLON

;  SEARCH-HEADERS
;  D: ( c-addr u nt -- 0 | xt 1 | xt -1 )
                $CODE       'SEARCH-HEADERS',$SEARCH_HEADERS
                PUSHRS      EDI
                PUSHRS      ESI
                POPDS       ESI                     ; LATEST word link
                MOV         EBX,DWORD [EDI + VAR_CASE_SENSITIVE]
                POPDS       ECX                     ; u
                POPDS       EDI                     ; c-addr
                ADD         EDI,ECX                 ; EDI points to the next byte after the last byte of the name
SW_LOOP:
                OR          ESI,ESI
                JZ          SHORT SW_NOT_FOUND
                PUSHDS      ESI                     ; save nt
                SUB         ESI,2                   ; NAME>FLAGS
                MOV         AX,WORD [ESI]           ; AL = length, AH = flags
                CMP         AL,CL
                JNZ         SHORT SW_NEXT
                TEST        AH,VEF_HIDDEN
                JNZ         SHORT SW_NEXT
                PUSHDS      EDI
                PUSHDS      ECX
                PUSHDS      EAX                     ; save flags in AH
; EDI points to the next byte after the last byte of the name
; ESI points to the next byte after the last byte of the name
CMP_LOOP:

                DEC         ESI                     ; comparison is performed from the last byte to the first
                DEC         EDI
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
                DEC         ECX
                OR          ECX,ECX
                JNZ         SHORT CMP_LOOP
                CMP         AL,AH
                POPDS       EAX
                POPDS       ECX
                POPDS       EDI
                POPDS       ESI
                JZ          SHORT SW_FOUND
CMP_EXIT:
                POPDS       EAX
                POPDS       ECX
                POPDS       EDI
SW_NEXT:
                POPDS       ESI
                MOV         EAX,DWORD [ESI]         ; NAME>NEXT
                OR          EAX,EAX
                JZ          SHORT SW_NOT_FOUND
                SUB         ESI,EAX
                JMP         SHORT SW_LOOP

SW_FOUND:
                TEST        AH,VEF_IMMEDIATE
                MOV         EAX,1
                JNZ         SHORT SW_FOUND_IMMEDIATE
                NEG         EAX
SW_FOUND_IMMEDIATE:
                ADD         ESI,CELL_SIZE           ; NAME>CODE
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
