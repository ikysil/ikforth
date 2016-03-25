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
                        $VAR    'REPORT-NEW-NAME',$REPORT_NEW_NAME,F_FALSE

;  REPORT-NEW-NAME-DUPLICATE
                        $VAR    'REPORT-NEW-NAME-DUPLICATE',$REPORT_NEW_NAME_DUPLICATE,F_FALSE

;  MAX-NAME-LENGTH
                        $VAR    'MAX-NAME-LENGTH',$MAX_NAME_LENGTH,64

;  USE-LOCATE
                        $VAR    'USE-LOCATE',$USE_LOCATE,F_TRUE

;  &USUAL
;  D: -- VEF-USUAL
                        $CONST  '&USUAL',,VEF_USUAL

;  &IMMEDIATE
;  D: -- VEF-IMMEDIATE
                        $CONST  '&IMMEDIATE',,VEF_IMMEDIATE

;  &HIDDEN
;  D: -- VEF-HIDDEN
                        $CONST  '&HIDDEN',,VEF_HIDDEN

;  &COMPILE-ONLY
;  D: -- VEF-COMPILE-ONLY
                        $CONST  '&COMPILE-ONLY',,VEF_COMPILE_ONLY

;  &LOCATE
;  D: -- VEF-LOCATE
                        $CONST  '&LOCATE',$AMPLOCATE,VEF_LOCATE

;  &IMMEDIATE/COMPILE-ONLY
;  D: -- VEF-IMMEDIATE or VEF-COMPILE-ONLY
                        $CONST  '&IMMEDIATE/COMPILE-ONLY',,VEF_IMMEDIATE_COMPILE_ONLY

;  CFA-SIZE
;  Size of CFA field
;  D: -- n
                        $CONST  'CFA-SIZE',$CFA_SIZE,CFA_SIZE

;  $NEXT-CODE-SIZE
                        $CREATE '$NEXT-CODE',$NEXT_CODE
NEXT_CODE_START:
                        $NEXT
NEXT_CODE_END:

NEXT_CODE_SIZE          EQU     NEXT_CODE_END - NEXT_CODE_START

;  $NEXT-CODE-SIZE
;  Size of CFA field
;  D: -- n
                        $CONST  '$NEXT-CODE-SIZE',$NEXT_CODE_SIZE,NEXT_CODE_SIZE

;  $NEXT!
;  Compile the machine code for $NEXT primitive of inner interpreter at addr address.
;  D: addr --
                        $COLON  '$NEXT!',$NEXTSTORE
                        XT_$NEXT_CODE
                        XT_$SWAP
                        XT_$NEXT_CODE_SIZE
                        XT_$CMOVE
                        XT_$EXIT

;  LATEST-HEAD@
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: -- addr
                        $CODE   'LATEST-HEAD@',$LATEST_HEAD_FETCH

                        MOV     EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                        PUSHDS  <DWORD [EAX]>
                        $NEXT

;  LATEST-HEAD!
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: addr --
                        $CODE   'LATEST-HEAD!',$LATEST_HEAD_STORE

                        MOV     EAX,DWORD [EDI + VAR_CURRENT]       ; get CURRENT wid
                        POPDS   <DWORD [EAX]>
                        $NEXT

;  CHECK-NAME
;  D: c-addr count -- c-addr count
                        $COLON  'CHECK-NAME',$CHECK_NAME

                        XT_$DUP
                        XT_$ZEROEQ
                        CQBR    NAME_ZEROGR
                          CTHROW  -16
NAME_ZEROGR:
                        XT_$DUP
                        CFETCH  $MAX_NAME_LENGTH
                        XT_$GR
                        CQBR    NAME_OK
                          CTHROW  -19
NAME_OK:
                        XT_$EXIT

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                        $COLON  '(REPORT-NAME)',$PREPORT_NAME

                        CFETCH  $REPORT_NEW_NAME
                        CQBR    NO_REPORT
                          XT_$2DUP
                          XT_$TYPE
                          $WRITE  ' '
NO_REPORT:
                        CFETCH  $REPORT_NEW_NAME_DUPLICATE
                        CQBR    CDN_OK
                        XT_$2DUP
                        CFETCH  $CURRENT
                        XT_$SEARCH_WORDLIST        ; c-addr u 0 | c-addr u xt +/-1
                        XT_$ZERONOEQ
                        CQBR    CDN_OK
                          XT_$DROP
                          $WRITE  'Redefinition of '
                          XT_$2DUP
                          XT_$TYPE
                          $WRITE  ' '
CDN_OK:
                        XT_$EXIT

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                        $DEFER  'REPORT-NAME',$REPORT_NAME,$PREPORT_NAME

;  (LOCATE,)
;  S: flags1 -- flags2
;  Compile information for LOCATE and set &LOCATE in flags if enabled.
                        $COLON  '(LOCATE,)',$PLOCATEC
                        CFETCH  $USE_LOCATE
                        CQBR    NO_LOCATE
                        CFETCH  $INCLUDE_MARK
                        XT_$COMMA
                        CFETCH  $TOIN
                        XT_$COMMA
                        CFETCH  $INCLUDE_LINE_NUM
                        XT_$COMMA
                        XT_$AMPLOCATE
                        XT_$OR
NO_LOCATE:
                        XT_$EXIT

;  (HEADER,)
;  Compile header without CFA
;  D: [ 0 0 | c-addr count ] flags --
                        $COLON  '(HEADER,)',$PHEADERC
                        XT_$PLOCATEC
                        XT_$HERE
                        XT_$TOR
                        XT_$CCOMMA                 ; compile flags
                        XT_$SWAP                   ; count c-addr
                        XT_$OVER                   ; count c-addr count
                        XT_$DUP
                        XT_$CCOMMA                 ; compile length
                        XT_$QDUP
                        CQBR    NO_NAME
                          XT_$HERE                   ; count c-addr count here
                          XT_$SWAP                   ; count c-addr here count
                          XT_$DUP
                          XT_$ALLOT
                          XT_$CMOVE                  ; put name
                        CBR     NAME_EXIT
NO_NAME:
                          XT_$DROP
NAME_EXIT:
                        CCLIT   2
                        XT_$ADD
                        XT_$CCOMMA                 ; compile (length + 2)
                        XT_$LATEST_HEAD_FETCH
                        XT_$COMMA
                        XT_$RFROM
                        XT_$LATEST_HEAD_STORE
                        XT_$EXIT

;  (CFA,)
;  Compile CFA after (HEADER,)
;  D: [ code-addr | 0 ] -- xt
                        $COLON  '(CFA,)',$PCFA_C

                        XT_$DUP
                        ;  D: [ code-addr | 0 ] [ code-addr | 0 ]
                        XT_$ZEROEQ
                        ;  D: [ code-addr | 0 ] eq-zero-flag
                        CQBR    HAS_CODE_ADDR
                          XT_$DROP
                          XT_$HERE
                          ;   D: xt
                          CCLIT   CFA_SIZE
                          XT_$ADD
                          ;   D: code-addr
HAS_CODE_ADDR:
                        XT_$HERE
                          ;   D: code-addr xt
                        CCLIT   CFA_SIZE
                        XT_$ALLOT
                          ;   D: code-addr xt
                        XT_$SWAP
                        XT_$OVER
                          ;   D: xt code-addr xt
                        XT_$CODE_ADDRESS_STORE
                          ;   D: xt
                        XT_$EXIT

;  HEADER,
;  D: [ code-addr | 0 ] [ 0 0 | c-addr count ] flags -- xt
                        $COLON  'HEADER,',$HEADERC

                        XT_$PHEADERC
                        XT_$PCFA_C
                        XT_$EXIT

;  CHECK-HEADER,
;  D: [ executor-xt | 0 ] [ 0 0 | c-addr count ] flags -- xt
                        $COLON  'CHECK-HEADER,',$CHECK_HEADERC

                        XT_$TOR
                        XT_$CHECK_NAME
                        XT_$REPORT_NAME
                        XT_$RFROM
                        XT_$HEADERC
                        XT_$EXIT

;  PARSE-CHECK-HEADER,
;  D: [ executor-xt | 0 ] flags "name" -- xt
                        $COLON  'PARSE-CHECK-HEADER,',$PARSE_CHECK_HEADERC

                        XT_$TOR
                        XT_$BL
                        XT_$WORD
                        XT_$COUNT
                        XT_$RFROM
                        XT_$CHECK_HEADERC
                        XT_$EXIT

;  HFLAGS!
;  D: x h-id --
;  Store flags specified by x to the flags field of the header
                        $COLON  'HFLAGS!',$HFLAGS_STORE

                        XT_$CSTORE
                        XT_$EXIT

;  HFLAGS@
;  D: h-id -- x
;  Get flags from the flags field of the header
                        $COLON  'HFLAGS@',$HFLAGS_FETCH

                        XT_$CFETCH
                        XT_$EXIT

;  SET-HFLAGS!
;  D: flags --
                        $COLON  'SET-HFLAGS!'

                        XT_$LATEST_HEAD_FETCH
                        XT_$DUP
                        XT_$HFLAGS_FETCH
                        XT_$ROT
                        XT_$OR
                        XT_$SWAP
                        XT_$HFLAGS_STORE
                        XT_$EXIT

;  RESET-HFLAGS!
;  D: flags --
                        $COLON  'RESET-HFLAGS!'

                        XT_$LATEST_HEAD_FETCH
                        XT_$DUP
                        XT_$HFLAGS_FETCH
                        XT_$ROT
                        XT_$INVERT
                        XT_$AND
                        XT_$SWAP
                        XT_$HFLAGS_STORE
                        XT_$EXIT

;  INVERT-HFLAGS!
;  D: flags --
                        $COLON  'INVERT-HFLAGS!'

                        XT_$LATEST_HEAD_FETCH
                        XT_$DUP
                        XT_$HFLAGS_FETCH
                        XT_$ROT
                        XT_$XOR
                        XT_$SWAP
                        XT_$HFLAGS_STORE
                        XT_$EXIT

;  >HEAD
;  D: xt -- h-id
;  h-id is the address of vocabulary entry flags
                        $CODE   '>HEAD',$TO_HEAD

                        POPDS   EAX
                        SUB     EAX,5
                        XOR     EBX,EBX
                        MOV     BL,BYTE [EAX]
                        SUB     EAX,EBX
                        PUSHDS  EAX
                        $NEXT

;  HEAD>
;  D: h-id -- xt
;  h-id is the address of vocabulary entry flags
                        $CODE   'HEAD>',$HEAD_FROM

                        POPDS   EAX
                        INC     EAX
                        XOR     EBX,EBX
                        MOV     BL,BYTE [EAX]
                        ADD     EAX,EBX
                        ADD     EAX,6
                        PUSHDS  EAX
                        $NEXT

;  HEAD>NAME
                        $COLON  'HEAD>NAME',$HEAD_TO_NAME

                        XT_$1ADD
                        XT_$EXIT

;  NAME>HEAD
                        $COLON  'NAME>HEAD',$NAME_TO_HEAD

                        XT_$1SUB
                        XT_$EXIT

;  >NAME
;  D: xt -- name-addr
                        $COLON  '>NAME',$TO_NAME

                        XT_$TO_HEAD
                        XT_$HEAD_TO_NAME
                        XT_$EXIT

;  NAME>
;  D: name-addr -- xt
                        $COLON  'NAME>',$NAME_FROM

                        XT_$NAME_TO_HEAD
                        XT_$HEAD_FROM
                        XT_$EXIT

;  >LINK
;  D: CFA -- LFA
                        $COLON  '>LINK',$TO_LINK

                        CCLIT   CELL_SIZE
                        XT_$SUB
                        XT_$EXIT

;  LINK>
;  D: LFA -- CFA
                        $COLON  'LINK>',$LINK_FROM

                        CCLIT   CELL_SIZE
                        XT_$ADD
                        XT_$EXIT

;  H>NEXT>H
;  D: h-id -- prev_h-id | 0
                        $COLON  'H>NEXT>H',$H_TO_NEXT_TO_H

                        XT_$HEAD_FROM
                        XT_$TO_LINK
                        XT_$FETCH
                        XT_$EXIT

;  H>#NAME
;  D: h-id -- addr len
                        $COLON  'H>#NAME',$H_TO_HASH_NAME

                        XT_$HEAD_TO_NAME
                        XT_$DUP
                        XT_$1ADD
                        XT_$SWAP
                        XT_$CFETCH
                        XT_$EXIT

