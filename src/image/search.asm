;******************************************************************************
;
;  search.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Words search
;******************************************************************************

;  16.6.1.1595 FORTH-WORDLIST
                        $CREATE 'FORTH-WORDLIST',$FORTH_WORDLIST
FORTH_WORDLIST_EQU:
                        DD      LATEST_WORD             ; last word in a list
                        CC      0                       ; wordlist name
                        CC      0                       ; wordlist link

                        LABEL   UPCASE
                        CMP     AL,'a'
                        JB      SHORT @@UC              ; jump if AH < 'a'
                        CMP     AL,'z'
                        JA      SHORT @@UC              ; jump if AH > 'z'
                        SUB     AL,'a' - 'A'            ; convert to uppercase
@@UC:
                        RET

;  16.6.1.2192 SEARCH-WORDLIST
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                        $CODE   'SEARCH-WORDLIST',$SEARCH_WORDLIST

                        PUSHRS  EDI
                        PUSHRS  ESI
                        POPDS   EAX                     ; wid
                        MOV     ESI,DWORD [EAX]         ; get LATEST word link
                        MOV     EBX,DWORD [EDI + VAR_CASE_SENSITIVE]
                        POPDS   ECX                     ; u
                        POPDS   EDI                     ; c-addr
SW_LOOP:
                        OR      ESI,ESI
                        JZ      SHORT SW_NOT_FOUND
                        MOV     AX,WORD [ESI]
                        CMP     AH,CL
                        JNZ     SHORT SW_NEXT
                        TEST    AL,VEF_HIDDEN
                        JNZ     SHORT SW_NEXT
                        PUSHDS  ESI
                        PUSHDS  EDI
                        PUSHDS  ECX
                        ADD     ESI,2
CMP_LOOP:
                        MOV     AL,BYTE [ESI]
                        MOV     AH,BYTE [EDI]
                        OR      EBX,EBX
                        JNZ     SHORT CMP_CONT
                        CALL    UPCASE
                        XCHG    AL,AH
                        CALL    UPCASE
CMP_CONT:
                        CMP     AL,AH
                        JNZ     SHORT CMP_EXIT
                        INC     ESI
                        INC     EDI
                        DEC     ECX
                        OR      ECX,ECX
                        JNZ     SHORT CMP_LOOP
                        CMP     AL,AH
                        POPDS   ECX
                        POPDS   EDI
                        POPDS   ESI
                        JZ      SHORT SW_FOUND
CMP_EXIT:
                        POPDS   ECX
                        POPDS   EDI
                        POPDS   ESI
SW_NEXT:
                        MOVZX   EAX,BYTE [ESI + 1]
                        ADD     ESI,EAX
                        ADD     ESI,3
                        MOV     ESI,DWORD [ESI]
                        JMP     SHORT SW_LOOP

SW_FOUND:
                        MOV     AL,BYTE [ESI]
                        TEST    AL,VEF_IMMEDIATE
                        MOV     EAX,1
                        JNZ     SHORT SW_FOUND_IMMEDIATE
                        NEG     EAX
SW_FOUND_IMMEDIATE:
                        MOVZX   EBX,BYTE [ESI + 1]
                        ADD     ESI,EBX
                        ADD     ESI,7
                        PUSHDS  ESI
                        PUSHDS  EAX
                        POPRS   ESI
                        POPRS   EDI
                        $NEXT

SW_NOT_FOUND:
                        PUSHDS  0
                        POPRS   ESI
                        POPRS   EDI
                        $NEXT

;  D: ( c-addr u -- 0 | xt 1 | xt -1 )
                        $COLON  'SEARCH-FORTH-WORDLIST',$SEARCH_FORTH_WORDLIST
                        XT_$FORTH_WORDLIST
                        XT_$SEARCH_WORDLIST
                        XT_$EXIT

;  SEARCH-NAME
;  D: ( c-addr u -- 0 | xt 1 | xt -1 )
                        $DEFER  'SEARCH-NAME',$SEARCH_NAME,$SEARCH_FORTH_WORDLIST

;  6.1.1550 FIND
;  D: ( c-addr -- c-addr 0 | xt 1 | xt -1 )
                        $COLON  'FIND',$FIND
                        XT_$DUP
                        XT_$TOR
                        XT_$COUNT
                        XT_$SEARCH_NAME
                        XT_$DUP
                        XT_$ZEROEQ
                        CQBR    FF_FOUND
                          XT_$RFROM
                          XT_$SWAP
                        CBR     FF_EXIT
FF_FOUND:
                          XT_$RFROM
                          XT_$DROP
FF_EXIT:
                        XT_$EXIT
