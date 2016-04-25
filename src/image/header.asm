;******************************************************************************
;
;  header.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  HEADER & support words
;******************************************************************************

;  REPORT-NEW-NAME
                $VAR        'REPORT-NEW-NAME',$REPORT_NEW_NAME,F_FALSE

;  REPORT-NEW-NAME-DUPLICATE
                $VAR        'REPORT-NEW-NAME-DUPLICATE',$REPORT_NEW_NAME_DUPLICATE,F_FALSE

;  MAX-NAME-LENGTH
                $VAR        'MAX-NAME-LENGTH',$MAX_NAME_LENGTH,64

;  USE-LOCATE
                $VAR        'USE-LOCATE',$USE_LOCATE,F_TRUE

;  &USUAL
;  D: -- VEF-USUAL
                $CONST      '&USUAL',,VEF_USUAL

;  &IMMEDIATE
;  D: -- VEF-IMMEDIATE
                $CONST      '&IMMEDIATE',HF_IMMEDIATE,VEF_IMMEDIATE

;  &HIDDEN
;  D: -- VEF-HIDDEN
                $CONST      '&HIDDEN',,VEF_HIDDEN

;  &COMPILE-ONLY
;  D: -- VEF-COMPILE-ONLY
                $CONST      '&COMPILE-ONLY',HF_COMPILE_ONLY,VEF_COMPILE_ONLY

;  &LOCATE
;  D: -- VEF-LOCATE
                $CONST      '&LOCATE',$AMPLOCATE,VEF_LOCATE

;  &IMMEDIATE/COMPILE-ONLY
;  D: -- VEF-IMMEDIATE or VEF-COMPILE-ONLY
                $CONST      '&IMMEDIATE/COMPILE-ONLY',,VEF_IMMEDIATE_COMPILE_ONLY

;  CFA-SIZE
;  Size of CFA field
;  D: -- n
                $CONST      'CFA-SIZE',$CFA_SIZE,CFA_SIZE

;  $NEXT-CODE-SIZE
                $CREATE     '$NEXT-CODE',$NEXT_CODE
NEXT_CODE_START:
                $NEXT
NEXT_CODE_END:

NEXT_CODE_SIZE  EQU         NEXT_CODE_END - NEXT_CODE_START

;  $NEXT-CODE-SIZE
;  Size of CFA field
;  D: -- n
                $CONST      '$NEXT-CODE-SIZE',$NEXT_CODE_SIZE,NEXT_CODE_SIZE

;  $NEXT!
;  Compile the machine code for $NEXT primitive of inner interpreter at addr address.
;  D: addr --
                $COLON      '$NEXT!',$NEXTSTORE
                CW          $NEXT_CODE, $SWAP, $NEXT_CODE_SIZE, $CMOVE
                $END_COLON

;  LATEST-HEAD@
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: -- addr
                $CODE       'LATEST-HEAD@',$LATEST_HEAD_FETCH
                MOV         EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                PUSHDS      <DWORD [EAX]>
                $NEXT

;  LATEST-HEAD!
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: addr --
                $CODE       'LATEST-HEAD!',$LATEST_HEAD_STORE
                MOV         EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                POPDS       <DWORD [EAX]>
                $NEXT

;  CHECK-NAME
;  D: c-addr count -- c-addr count
                $COLON      'CHECK-NAME',$CHECK_NAME
                CW          $DUP, $ZEROEQ
                _IF         CHECK_NAME_TOO_SHORT
                CTHROW  -16
                _THEN       CHECK_NAME_TOO_SHORT
                CW          $DUP
                CFETCH      $MAX_NAME_LENGTH
                CW          $GR
                _IF         CHECK_NAME_TOO_LONG
                CTHROW  -19
                _THEN       CHECK_NAME_TOO_LONG
                $END_COLON

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                $COLON      '(REPORT-NAME)',$PREPORT_NAME
                CFETCH      $REPORT_NEW_NAME
                _IF         PREPORT_NAME_NEW
                CW          $2DUP, $TYPE
                $WRITE      ' '
                _THEN       PREPORT_NAME_NEW
                CFETCH      $REPORT_NEW_NAME_DUPLICATE
                _IF         PREPORT_NAME_DUPLICATE
                CW          $2DUP
                CFETCH      $CURRENT
                CW          $SEARCH_WORDLIST        ; c-addr u 0 | c-addr u xt +/-1
                CW          $ZERONOEQ
                _IF         PREPORT_NAME_HAS_DUPLICATE
                CW          $DROP
                $WRITE  'Redefinition of '
                CW          $2DUP, $TYPE
                $WRITE  ' '
                _THEN       PREPORT_NAME_HAS_DUPLICATE
                _THEN       PREPORT_NAME_DUPLICATE
                $END_COLON

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                $DEFER      'REPORT-NAME',$REPORT_NAME,$PREPORT_NAME

;  (LOCATE,)
;  S: flags1 -- flags2
;  Compile information for LOCATE and set &LOCATE in flags if enabled.
                $COLON      '(LOCATE,)',$PLOCATEC
                CFETCH      $USE_LOCATE
                _IF         USE_LOCATE
                CFETCH      $INCLUDE_MARK
                CW          $COMMA
                CFETCH      $TOIN
                CW          $COMMA
                CFETCH      $INCLUDE_LINE_NUM
                CW          $COMMA, $AMPLOCATE, $OR
                _THEN       USE_LOCATE
                $END_COLON

;  (HEADER,)
;  Compile header without CFA
;  D: [ 0 0 | c-addr count ] flags --
                $COLON      '(HEADER,)',$PHEADERC
                CW          $PLOCATEC
                CW          $HERE
                CW          $TOR
                CW          $CCOMMA                 ; compile flags
                CW          $SWAP                   ; count c-addr
                CW          $OVER                   ; count c-addr count
                CW          $DUP
                CW          $CCOMMA                 ; compile length
                CW          $QDUP
                _IF         PHEADERC_HAS_NAME
                CW          $HERE                   ; count c-addr count here
                CW          $SWAP                   ; count c-addr here count
                CW          $DUP
                CW          $ALLOT
                CW          $CMOVE                  ; put name
                _ELSE       PHEADERC_HAS_NAME
                CW          $DROP
                _THEN       PHEADERC_HAS_NAME
                CCLIT       2
                CW          $ADD
                CW          $CCOMMA                 ; compile (length + 2)
                CW          $LATEST_HEAD_FETCH, $COMMA, $RFROM, $LATEST_HEAD_STORE
                $END_COLON

;  (CFA,)
;  Compile CFA after (HEADER,)
;  D: [ code-addr | 0 ] -- xt
                $COLON      '(CFA,)',$PCFA_C
                MATCH       =TRUE, DEBUG {
                $WRITE      '  XT='
                CW          $HERE, $HOUT8
                $WRITE      '  '
                }
                CW          $DUP
                ;  D: [ code-addr | 0 ] [ code-addr | 0 ]
                CW          $ZEROEQ
                ;  D: [ code-addr | 0 ] eq-zero-flag
                _IF         PCFA_C_HAS_CODE_ADDR
                CW          $DROP, $HERE
                ;   D: xt
                CCLIT       CFA_SIZE
                CW          $ADD
                ;   D: code-addr
                _THEN       PCFA_C_HAS_CODE_ADDR
                CW          $HERE
                ;   D: code-addr xt
                CCLIT       CFA_SIZE
                CW          $ALLOT
                ;   D: code-addr xt
                CW          $SWAP, $OVER
                ;   D: xt code-addr xt
                CW          $CODE_ADDRESS_STORE
                ;   D: xt
                $END_COLON

;  HEADER,
;  D: [ code-addr | 0 ] [ 0 0 | c-addr count ] flags -- xt
                $COLON      'HEADER,',$HEADERC
                CW          $PHEADERC, $PCFA_C
                $END_COLON

;  CHECK-HEADER,
;  D: [ executor-xt | 0 ] [ 0 0 | c-addr count ] flags -- xt
                $COLON      'CHECK-HEADER,',$CHECK_HEADERC
                CW          $TOR, $CHECK_NAME, $REPORT_NAME, $RFROM, $HEADERC
                $END_COLON

;  PARSE-CHECK-HEADER,
;  D: [ executor-xt | 0 ] flags "name" -- xt
                $COLON      'PARSE-CHECK-HEADER,',$PARSE_CHECK_HEADERC
                CW          $TOR, $PARSE_NAME, $RFROM, $CHECK_HEADERC
                $END_COLON

;  HFLAGS!
;  D: x h-id --
;  Store flags specified by x to the flags field of the header
                $COLON      'HFLAGS!',$HFLAGS_STORE
                CW          $CSTORE
                $END_COLON

;  HFLAGS@
;  D: h-id -- x
;  Get flags from the flags field of the header
                $COLON      'HFLAGS@',$HFLAGS_FETCH
                CW          $CFETCH
                $END_COLON

;  SET-HFLAGS!
;  D: flags --
                $COLON      'SET-HFLAGS!'
                CW          $LATEST_HEAD_FETCH, $DUP, $HFLAGS_FETCH, $ROT, $OR, $SWAP, $HFLAGS_STORE
                $END_COLON

;  RESET-HFLAGS!
;  D: flags --
                $COLON      'RESET-HFLAGS!'
                CW          $LATEST_HEAD_FETCH, $DUP, $HFLAGS_FETCH, $ROT, $INVERT, $AND, $SWAP, $HFLAGS_STORE
                $END_COLON

;  INVERT-HFLAGS!
;  D: flags --
                $COLON      'INVERT-HFLAGS!'
                CW          $LATEST_HEAD_FETCH, $DUP, $HFLAGS_FETCH, $ROT, $XOR, $SWAP, $HFLAGS_STORE
                $END_COLON

;  >HEAD
;  D: xt -- h-id
;  h-id is the address of vocabulary entry flags
                $CODE       '>HEAD',$TO_HEAD
                POPDS       EAX
                SUB         EAX,5
                XOR         EBX,EBX
                MOV         BL,BYTE [EAX]
                SUB         EAX,EBX
                PUSHDS      EAX
                $NEXT

;  HEAD>
;  D: h-id -- xt
;  h-id is the address of vocabulary entry flags
                $CODE       'HEAD>',$HEAD_FROM
                POPDS       EAX
                INC         EAX
                XOR         EBX,EBX
                MOV         BL,BYTE [EAX]
                ADD         EAX,EBX
                ADD         EAX,6
                PUSHDS      EAX
                $NEXT

;  HEAD>NAME
                $COLON      'HEAD>NAME',$HEAD_TO_NAME
                CW          $1ADD
                $END_COLON

;  NAME>HEAD
                $COLON      'NAME>HEAD',$NAME_TO_HEAD
                CW          $1SUB
                $END_COLON

;  >NAME
;  D: xt -- name-addr
                $COLON      '>NAME',$TO_NAME
                CW          $TO_HEAD, $HEAD_TO_NAME
                $END_COLON

;  NAME>
;  D: name-addr -- xt
                $COLON      'NAME>',$NAME_FROM
                CW          $NAME_TO_HEAD, $HEAD_FROM
                $END_COLON

;  >LINK
;  D: CFA -- LFA
                $COLON      '>LINK',$TO_LINK
                CCLIT       CELL_SIZE
                CW          $SUB
                $END_COLON

;  LINK>
;  D: LFA -- CFA
                $COLON      'LINK>',$LINK_FROM
                CCLIT       CELL_SIZE
                CW          $ADD
                $END_COLON

;  H>NEXT>H
;  D: h-id -- prev_h-id | 0
                $COLON      'H>NEXT>H',$H_TO_NEXT_TO_H
                CW          $HEAD_FROM, $TO_LINK, $FETCH
                $END_COLON

;  H>#NAME
;  D: h-id -- addr len
                $COLON      'H>#NAME',$H_TO_HASH_NAME
                CW          $HEAD_TO_NAME, $DUP, $1ADD, $SWAP, $CFETCH
                $END_COLON

                LABEL       UPCASE
                CMP         AL,'a'
                JB          SHORT @@UC              ; jump if AH < 'a'
                CMP         AL,'z'
                JA          SHORT @@UC              ; jump if AH > 'z'
                SUB         AL,'a' - 'A'            ; convert to uppercase
@@UC:
                RET

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
