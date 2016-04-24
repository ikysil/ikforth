;******************************************************************************
;
;  parse.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Parsing
;******************************************************************************

;  6.1.0560 >IN
                $USER       '>IN',$TOIN,VAR_TOIN

;  (WORD)
                $CODE       '(WORD)',$PWORD
                PUSHRS      ESI
                PUSHRS      EDI
                MOV         EAX,EDI
                ADD         EAX,VAR_TOIN
                POPDS       EDI                   ; dest address
                PUSHRS      EDI
                INC         EDI
                POPDS       ECX                   ; count
                POPDS       ESI                   ; source address
                POPDS       EDX                   ; DL - char
                PUSHDS      EBP
                MOV         EBP,EAX
                XOR         EBX,EBX
                XOR         AH,AH                 ; in word flag
PWORD_LOOP:
                DEC         ECX
                JS          SHORT PWORD_EXIT
                LODSB
                INC         DWORD [EBP]           ; inc >IN
                OR          AL,AL
                JZ          SHORT PWORD_EXIT
                OR          AH,AH
                JZ          SHORT PWORD_NOT_IN_WORD
                CMP         AL,DL
                JZ          SHORT PWORD_EXIT
                CMP         AL,32
                JG          SHORT PWORD_ADDCHAR
                CMP         DL,32
                JZ          SHORT PWORD_EXIT
PWORD_ADDCHAR:
                STOSB
                INC         BL
                JMP         SHORT PWORD_LOOP
PWORD_NOT_IN_WORD:
                CMP         AL,32
                JL          SHORT PWORD_LOOP      ; skip control characters
                CMP         AL,DL
                JZ          SHORT PWORD_LOOP      ; skip leading delimiters
                MOV         AH,1
                JMP         SHORT PWORD_ADDCHAR
PWORD_EXIT:
                POPDS       EBP
                MOV         BYTE [EDI],32         ; store space
                POPRS       EDI
                PUSHDS      EDI
                MOV         BYTE [EDI],BL         ; store length
                POPRS       EDI
                POPRS       ESI
                $NEXT

;  6.1.2450 WORD
                $COLON      'WORD',$WORD
                CW          $SOURCE                 ; c c-addr u
                CW          $DUP
                CQBR        WORD_EMPTY_SOURCE
                CFETCH      $TOIN
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'WORD-A:',4
                }
                CW          $SUB
                CW          $SWAP                   ; c u c-addr
                CFETCH      $TOIN                   ; c u c-addr offset
                CW          $ADD                    ; c u c-addr
                CW          $SWAP                   ; c c-addr u
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'WORD-B:',3
                $CR
                $WRITE  'WORD-C: '
                CW          $2DUP, $TYPE
                }
WORD_EMPTY_SOURCE:
                CW          $POCKET                 ; c c-addr u dest-addr
                CW          $PWORD
                $END_COLON

;  (PARSE)
                $CODE       '(PARSE)',$PPARSE
                PUSHRS      ESI
                POPDS       ECX                     ; count
                POPDS       ESI                     ; source address
                POPDS       EDX                     ; DL - char
                PUSHDS      ESI                     ; result
                XOR         EBX,EBX
PPARSE_LOOP:
                DEC         ECX
                JS          SHORT PPARSE_EXIT
                LODSB
                INC         DWORD [EDI + VAR_TOIN]
                OR          AL,AL
                JZ          SHORT PPARSE_EXIT
                CMP         AL,DL
                JZ          SHORT PPARSE_EXIT
                INC         EBX
                JMP         SHORT PPARSE_LOOP
PPARSE_EXIT:
                PUSHDS      EBX
                POPRS       ESI
                $NEXT

;  6.2.2008 PARSE
                $COLON      'PARSE',$PARSE
                CW          $SOURCE             ; c c-addr u
                CFETCH      $TOIN
                CW          $SUB, $SWAP         ; c u c-addr
                CFETCH      $TOIN               ; c u c-addr offset
                CW          $ADD                ; c u c-addr
                CW          $SWAP               ; c c-addr u
                CW          $PPARSE             ; c-addr u
                $END_COLON

;  (S")
;  -- c-addr count
                $COLON      '(S")',$PSQUOTE
                CW          $RFROM, $DUP, $FETCH, $SWAP, $CELLADD, $2DUP, $ADD, $TOR, $SWAP
                $END_COLON

;  S"-COMP
                $COLON      'S"-COMP',$SQ_COMP
                CCLIT       '"'
                CW          $PARSE
                CWLIT       $PSQUOTE
                CW          $COMPILEC, $DUP, $COMMA, $HERE, $OVER, $ALLOT, $SWAP, $CMOVE
                $END_COLON

;  +S"BUFFER
;  S: -- c-addr
;  Return address of next buffer to use by S" and family.
;  Size of the buffer is provided by /S"BUFFER
                $COLON      '+S"BUFFER',$PLSQBUFFER
                CFETCH      $SQINDEX
                CW          $1ADD, $SQINDEX_MASK, $AND, $DUP
                CSTORE      $SQINDEX
                CW          $SLSQBUFFER, $MUL, $SQBUFFER, $ADD
                $END_COLON

;  >S"BUFFER
;  S: c-addr1 u1 -- c-addr2 u2
;  Copy string from c-addr1 to a temporary buffer and return it's address c-addr2.
;  u2 is the actual number of characters copied.
                $COLON      '>S"BUFFER',$TOSQBUFFER
                CW          $PLSQBUFFER, $SWAP, $2DUP, $2TOR, $CMOVE, $2RFROM
                $END_COLON

;  S"-INT
                $COLON      'S"-INT',$SQ_INT
                CCLIT       '"'
                CW          $PARSE, $TOSQBUFFER
                $END_COLON

;     6.1.2165 S"
;  11.6.1.2165 S"
                $DEF        'S"',$SQUOTE,$PDO_INT_COMP,VEF_IMMEDIATE
                CW          $SQ_INT
                CW          $SQ_COMP

;  \ (filler text)
                $COLON      '(\)',$PBSLASH,VEF_IMMEDIATE
                CW          $ZERO, $PARSE, $2DROP
                $END_COLON

                $DEFER      '\',,$PBSLASH,VEF_IMMEDIATE

                $COLON      'NOOP',$NOOP,VEF_IMMEDIATE
                $END_COLON

                MATCH       =TRUE, DEBUG {
                $DEFER      '\DEBUG',$SLDEBUG,$NOOP,VEF_IMMEDIATE
                }

                IF          ~ DEFINED CFA_$SLDEBUG
                $DEFER      '\DEBUG',,$PBSLASH,VEF_IMMEDIATE
                END IF
