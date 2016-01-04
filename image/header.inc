;******************************************************************************
;
;  ik.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  HEADER & support words
;******************************************************************************

;  CREATE-REPORT
                        $VAR    'CREATE-REPORT',$CREATE_REPORT
                        CC      FALSE

;  CREATE-WARN-ON-DUPLICATE
                        $VAR    'CREATE-WARN-ON-DUPLICATE',$CREATE_WOD
                        CC      FALSE

;  MAX-NAME-LENGTH
                        $VAR    'MAX-NAME-LENGTH',$MAX_NAME_LENGTH
                        CC      MAX_NAME_LENGTH

;  LATEST@
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: -- addr
                        $DEF    'LATEST@',$LATEST_FETCH
                        MOV     EAX,[DWORD PTR EDI + CURRENT_VAR]       ; get CURRENT wid
                        PUSHDS  <[DWORD PTR EAX]>
                        $NEXT

;  LATEST!
;  addr is the link address of the last compiled word in compilation wordlist.
;  D: addr --
                        $DEF    'LATEST!',$LATEST_STORE
                        MOV     EAX,[DWORD PTR EDI + CURRENT_VAR]       ; get CURRENT wid
                        POPDS   <[DWORD PTR EAX]>
                        $NEXT

;  CHECK-NAME
;  D: c-addr count -- c-addr count
                        $COLON  'CHECK-NAME',$CHECK_NAME
                        CW      $DUP
                        CW      $ZEROEQ
                        CW      $QBRANCH
                        CW      NAME_ZEROGR
                          CW      $LIT
                          CC      -16
                          CW      $THROW
NAME_ZEROGR:
                        CW      $DUP
                        CW      $MAX_NAME_LENGTH
                        CW      $FETCH
                        CW      $GR
                        CW      $QBRANCH
                        CW      NAME_OK
                          CW      $LIT
                          CC      -19
                          CW      $THROW
NAME_OK:
                        CW      $EXIT

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                        $COLON  'REPORT-NAME',$REPORT_NAME
                        CW      $CREATE_REPORT
                        CW      $FETCH
                        CW      $QBRANCH
                        CW      NO_REPORT
                          CW      $2DUP
                          CW      $TYPE
                          $WRITE  < >
NO_REPORT:
                        CW      $EXIT

;  CHECK-DUPLICATE-NAME
;  D: c-addr count -- c-addr count
                        $COLON  'CHECK-DUPLICATE-NAME',$CHECK_DUPLICATE_NAME
                        CW      $CREATE_WOD
                        CW      $FETCH
                        CW      $QBRANCH
                        CW      CDN_OK
                        CW      $2DUP
                        CW      $CURRENT
                        CW      $FETCH
                        CW      $SEARCH_WORDLIST        ; c-addr u 0 | c-addr u xt +/-1
                        CW      $ZERONOEQ
                        CW      $QBRANCH
                        CW      CDN_OK
                          CW      $DROP
                          $WRITE  <Redefinition of >
                          CW      $2DUP
                          CW      $TYPE                 
                          $WRITE  < >
CDN_OK:
                        CW      $EXIT

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
                        CW      $QBRANCH
                        CW      NO_NAME
                          CW      $HERE                   ; count c-addr count here
                          CW      $SWAP                   ; count c-addr here count
                          CW      $DUP
                          CW      $ALLOT
                          CW      $CMOVE                  ; put name
                        CW      $BRANCH
                        CW      NAME_EXIT
NO_NAME:
                          CW      $DROP
NAME_EXIT:
                        CW      $LIT
                        CC      2
                        CW      $ADD
                        CW      $CCOMMA                 ; compile (length + 2)
                        CW      $LATEST_FETCH
                        CW      $COMMA
                        CW      $RFROM
                        CW      $LATEST_STORE
                        CW      $EXIT

;  (CFA,)
;  Compile CFA after (HEADER,)
;  D: executor-xt | 0 -- xt
                        $COLON  '(CFA,)',$PCFA_C
                        CW      $DUP
                        CW      $ZEROEQ
                        CW      $QBRANCH
                        CW      EXECUTOR_XT
                          CW      $DROP
                          CW      $HERE
                          CW      $LIT
                          CC      CELL_SIZE
                          CW      $ADD
EXECUTOR_XT:
                        CW      $HERE
                        CW      $SWAP
                        CW      $COMMA
                        CW      $EXIT

;  HEADER,
;  D: [ executor-xt | 0 ] [ 0 0 | c-addr count ] flags -- xt
                        $COLON  'HEADER,',$HEADERC
                        CW      $PHEADERC
                        CW      $PCFA_C
                        CW      $EXIT

;  CHECK-HEADER,
;  D: [ executor-xt | 0 ] [ 0 0 | c-addr count ] flags -- xt
                        $COLON  'CHECK-HEADER,',$CHECK_HEADERC
                        CW      $TOR
                        CW      $CHECK_NAME
                        CW      $REPORT_NAME
                        CW      $CHECK_DUPLICATE_NAME
                        CW      $RFROM
                        CW      $HEADERC
                        CW      $EXIT

;  PARSE-CHECK-HEADER,
;  D: [ executor-xt | 0 ] flags "name" -- xt
                        $COLON  'PARSE-CHECK-HEADER,',$PARSE_CHECK_HEADERC
                        CW      $TOR
                        CW      $BL
                        CW      $WORD
                        CW      $COUNT
                        CW      $RFROM
                        CW      $CHECK_HEADERC
                        CW      $EXIT
