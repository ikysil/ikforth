;******************************************************************************
;
;  header.inc
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  HEADER & support words
;******************************************************************************

;  REPORT-NEW-NAME
                        $VAR    'REPORT-NEW-NAME',$REPORT_NEW_NAME

                        CC      F_FALSE

;  REPORT-NEW-NAME-DUPLICATE
                        $VAR    'REPORT-NEW-NAME-DUPLICATE',$REPORT_NEW_NAME_DUPLICATE

                        CC      F_FALSE

;  MAX-NAME-LENGTH
                        $VAR    'MAX-NAME-LENGTH',$MAX_NAME_LENGTH

                        CC      64

;  &USUAL
;  D: -- VEF-USUAL
                        $CONST  '&USUAL'

                        CC      VEF_USUAL

;  &IMMEDIATE
;  D: -- VEF-IMMEDIATE
                        $CONST  '&IMMEDIATE'

                        CC      VEF_IMMEDIATE

;  &HIDDEN
;  D: -- VEF-HIDDEN
                        $CONST  '&HIDDEN'

                        CC      VEF_HIDDEN

;  &COMPILE-ONLY
;  D: -- VEF-COMPILE-ONLY
                        $CONST  '&COMPILE-ONLY'

                        CC      VEF_COMPILE_ONLY

;  &IMMEDIATE/COMPILE-ONLY
;  D: -- VEF-IMMEDIATE or VEF-COMPILE-ONLY
                        $CONST  '&IMMEDIATE/COMPILE-ONLY'

                        CC      VEF_IMMEDIATE_COMPILE_ONLY

;  CFA-SIZE
;  Size of CFA field
;  D: -- n
                        $CONST  'CFA-SIZE',$CFA_SIZE

                        CC      CFA_SIZE

;  $NEXT-CODE-SIZE
                        $VAR   '$NEXT-CODE',$NEXT_CODE
NEXT_CODE_START:
                        $NEXT
NEXT_CODE_END:

NEXT_CODE_SIZE          EQU     NEXT_CODE_END - NEXT_CODE_START

;  $NEXT-CODE-SIZE
;  Size of CFA field
;  D: -- n
                        $CONST  '$NEXT-CODE-SIZE',$NEXT_CODE_SIZE
                        CC      NEXT_CODE_SIZE

;  $NEXT!
;  Compile the machine code for $NEXT primitive of inner interpreter at addr address.
;  D: addr --
                        $COLON  '$NEXT!',$NEXTSTORE
                        CW      $NEXT_CODE
                        CW      $SWAP
                        CW      $NEXT_CODE_SIZE
                        CW      $CMOVE
                        CEXIT

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

                        CW      $DUP
                        CW      $ZEROEQ
                        CQBR    NAME_ZEROGR
                          CTHROW  -16
NAME_ZEROGR:
                        CW      $DUP
                        CFETCH  $MAX_NAME_LENGTH
                        CW      $GR
                        CQBR    NAME_OK
                          CTHROW  -19
NAME_OK:
                        CEXIT

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                        $COLON  '(REPORT-NAME)',$PREPORT_NAME

                        CFETCH  $REPORT_NEW_NAME
                        CQBR    NO_REPORT
                          CW      $2DUP
                          CW      $TYPE
                          $WRITE  ' '
NO_REPORT:
                        CFETCH  $REPORT_NEW_NAME_DUPLICATE
                        CQBR    CDN_OK
                        CW      $2DUP
                        CFETCH  $CURRENT
                        CW      $SEARCH_WORDLIST        ; c-addr u 0 | c-addr u xt +/-1
                        CW      $ZERONOEQ
                        CQBR    CDN_OK
                          CW      $DROP
                          $WRITE  'Redefinition of '
                          CW      $2DUP
                          CW      $TYPE                 
                          $WRITE  ' '
CDN_OK:
                        CEXIT

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                        $DEFER  'REPORT-NAME',$REPORT_NAME

                        CW      $PREPORT_NAME

;  (HEADER,)
;  Compile header without CFA
;  D: [ 0 0 | c-addr count ] flags --
                        $COLON  '(HEADER,)',$PHEADERC

                        CW      $HERE
                        CW      $TOR
                        CW      $CCOMMA                 ; compile flags
                        CW      $SWAP                   ; count c-addr
                        CW      $OVER                   ; count c-addr count
                        CW      $DUP
                        CW      $CCOMMA                 ; compile length
                        CW      $QDUP
                        CQBR    NO_NAME
                          CW      $HERE                   ; count c-addr count here
                          CW      $SWAP                   ; count c-addr here count
                          CW      $DUP
                          CW      $ALLOT
                          CW      $CMOVE                  ; put name
                        CBR     NAME_EXIT
NO_NAME:
                          CW      $DROP
NAME_EXIT:
                        CCLIT   2
                        CW      $ADD
                        CW      $CCOMMA                 ; compile (length + 2)
                        CW      $LATEST_HEAD_FETCH
                        CW      $COMMA
                        CW      $RFROM
                        CW      $LATEST_HEAD_STORE
                        CEXIT

;  (CFA,)
;  Compile CFA after (HEADER,)
;  D: [ code-addr | 0 ] -- xt
                        $COLON  '(CFA,)',$PCFA_C

                        CW      $DUP
                        ;  D: [ code-addr | 0 ] [ code-addr | 0 ]
                        CW      $ZEROEQ
                        ;  D: [ code-addr | 0 ] eq-zero-flag
                        CQBR    HAS_CODE_ADDR
                          CW      $DROP
                          CW      $HERE
                          ;   D: xt
                          CCLIT   CFA_SIZE
                          CW      $ADD
                          ;   D: code-addr
HAS_CODE_ADDR:
                        CW      $HERE
                          ;   D: code-addr xt
                        CCLIT   CFA_SIZE
                        CW      $ALLOT
                          ;   D: code-addr xt
                        CW      $SWAP
                        CW      $OVER
                          ;   D: xt code-addr xt
                        CW      $CODE_ADDRESS_STORE
                          ;   D: xt
                        CEXIT

;  HEADER,
;  D: [ code-addr | 0 ] [ 0 0 | c-addr count ] flags -- xt
                        $COLON  'HEADER,',$HEADERC

                        CW      $PHEADERC
                        CW      $PCFA_C
                        CEXIT

;  CHECK-HEADER,
;  D: [ executor-xt | 0 ] [ 0 0 | c-addr count ] flags -- xt
                        $COLON  'CHECK-HEADER,',$CHECK_HEADERC

                        CW      $TOR
                        CW      $CHECK_NAME
                        CW      $REPORT_NAME
                        CW      $RFROM
                        CW      $HEADERC
                        CEXIT

;  PARSE-CHECK-HEADER,
;  D: [ executor-xt | 0 ] flags "name" -- xt
                        $COLON  'PARSE-CHECK-HEADER,',$PARSE_CHECK_HEADERC

                        CW      $TOR
                        CW      $BL
                        CW      $WORD
                        CW      $COUNT
                        CW      $RFROM
                        CW      $CHECK_HEADERC
                        CEXIT

;  HFLAGS!
;  D: x h-id --
;  Store flags specified by x to the flags field of the header
                        $COLON  'HFLAGS!',$HFLAGS_STORE

                        CW      $CSTORE
                        CEXIT

;  HFLAGS@
;  D: h-id -- x
;  Get flags from the flags field of the header
                        $COLON  'HFLAGS@',$HFLAGS_FETCH

                        CW      $CFETCH
                        CEXIT

;  SET-HFLAGS!
;  D: flags --
                        $COLON  'SET-HFLAGS!'

                        CW      $LATEST_HEAD_FETCH
                        CW      $DUP
                        CW      $HFLAGS_FETCH
                        CW      $ROT
                        CW      $OR
                        CW      $SWAP
                        CW      $HFLAGS_STORE
                        CEXIT

;  RESET-HFLAGS!
;  D: flags --
                        $COLON  'RESET-HFLAGS!'

                        CW      $LATEST_HEAD_FETCH
                        CW      $DUP
                        CW      $HFLAGS_FETCH
                        CW      $ROT
                        CW      $INVERT
                        CW      $AND
                        CW      $SWAP
                        CW      $HFLAGS_STORE
                        CEXIT

;  INVERT-HFLAGS!
;  D: flags --
                        $COLON  'INVERT-HFLAGS!'

                        CW      $LATEST_HEAD_FETCH
                        CW      $DUP
                        CW      $HFLAGS_FETCH
                        CW      $ROT
                        CW      $XOR
                        CW      $SWAP
                        CW      $HFLAGS_STORE
                        CEXIT

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

                        CW      $1ADD
                        CEXIT

;  NAME>HEAD
                        $COLON  'NAME>HEAD',$NAME_TO_HEAD

                        CW      $1SUB
                        CEXIT

;  >NAME
;  D: xt -- name-addr
                        $COLON  '>NAME',$TO_NAME

                        CW      $TO_HEAD
                        CW      $HEAD_TO_NAME
                        CEXIT

;  NAME>
;  D: name-addr -- xt
                        $COLON  'NAME>',$NAME_FROM

                        CW      $NAME_TO_HEAD
                        CW      $HEAD_FROM
                        CEXIT

;  >LINK
;  D: CFA -- LFA
                        $COLON  '>LINK',$TO_LINK

                        CCLIT   CELL_SIZE
                        CW      $SUB
                        CEXIT

;  LINK>
;  D: LFA -- CFA
                        $COLON  'LINK>',$LINK_FROM

                        CCLIT   CELL_SIZE
                        CW      $ADD
                        CEXIT

;  H>NEXT>H
;  D: h-id -- prev_h-id | 0
                        $COLON  'H>NEXT>H',$H_TO_NEXT_TO_H

                        CW      $HEAD_FROM
                        CW      $TO_LINK
                        CW      $FETCH
                        CEXIT

;  H>#NAME
;  D: h-id -- addr len
                        $COLON  'H>#NAME',$H_TO_HASH_NAME

                        CW      $HEAD_TO_NAME
                        CW      $DUP
                        CW      $1ADD
                        CW      $SWAP
                        CW      $CFETCH
                        CEXIT

