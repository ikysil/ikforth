;******************************************************************************
;
;  source.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  
;******************************************************************************

;  6.2.2218 SOURCE-ID
;  Identifies the input source as follows: 
;
;  SOURCE-ID       Input source
;  -1              String (via EVALUATE)
;   0              User input device
                        $DEF    'SOURCE-ID',$SOURCE_ID
                        PUSH    [DWORD PTR EDI + SOURCE_ID_VAR]
                        $NEXT

;  SOURCE-ID!
                        $DEF    'SOURCE-ID!',$SOURCE_ID_STORE
                        POPDS   <[DWORD PTR EDI + SOURCE_ID_VAR]>
                        $NEXT

;  6.1.2216 SOURCE
;  c-addr is the address of, and u is the number of characters in
;  the input buffer. 
;  D: -- c-addr u
                        $DEF    'SOURCE',$SOURCE,$ENTER
                        CW      $BLK
                        CW      $FETCH
                        CW      $QDUP
                        CW      $QBRANCH
                        CW      SOURCE_NOT_BLOCK
                          CW      $BLOCK
                          CW      $LIT
                          CC      1024
                        CW      $BRANCH
                        CW      SOURCE_EXIT
SOURCE_NOT_BLOCK:
                          CW      $SOURCE_ID
                          CW      $ZEROLE
                          CW      $QBRANCH
                          CW      SOURCE_NOT_EVALUATE
                            CW      $EVAL
                            CW      $FETCH
                            CW      $#EVAL
                            CW      $FETCH
                          CW      $BRANCH
                          CW      SOURCE_NOT_EVALUATE_EXIT
SOURCE_NOT_EVALUATE:
                          CW      $SOURCE_ID
                          CW      $ZEROEQ
                          CW      $QBRANCH
                          CW      SOURCE_NOT_USER
                            CW      $TIB
                            CW      $#TIB
                            CW      $FETCH
                          CW      $BRANCH
                          CW      SOURCE_NOT_USER_EXIT
SOURCE_NOT_USER:
                            CW      $LINE
                            CW      $#LINE
                            CW      $FETCH
SOURCE_NOT_USER_EXIT:
SOURCE_NOT_EVALUATE_EXIT:
SOURCE_EXIT:
                        CW      $EXIT
                        
;  6.2.2125 REFILL
                        $DEF    'REFILL',$REFILL,$ENTER
                        CW      $BLK
                        CW      $FETCH
                        CW      $QDUP
                        CW      $QBRANCH
                        CW      REFILL_NOT_BLOCK
                          CW      $1ADD
                          CW      $BLK
                          CW      $STORE
                          CW      $ZERO
                          CW      $TOIN
                          CW      $STORE
                          CW      $TRUE
                        CW      $BRANCH
                        CW      REFILL_EXIT
REFILL_NOT_BLOCK:
                          CW      $SOURCE_ID
                          CW      $QDUP
                          CW      $QBRANCH
                          CW      REFILL_FROM_USER
                            CW      $ZEROLE
                            CW      $QBRANCH
                            CW      REFILL_FROM_FILE
                              CW      $FALSE
                            CW      $BRANCH
                            CW      REFILL_EVAL_EXIT
REFILL_FROM_FILE:
                              CW      $LINE
                              CW      $LIT
                              CC      MAX_LINE_LENGTH
                              CW      $SOURCE_ID
                              CW      $READ_LINE
                              CW      $DROP
                              CW      $SWAP
                              CW      $#LINE
                              CW      $STORE
                              CW      $ZERO
                              CW      $TOIN
                              CW      $STORE
REFILL_EVAL_EXIT:
                          CW      $BRANCH
                          CW      REFILL_EXIT
REFILL_FROM_USER:
                            CW      $TIB
                            CW      $LIT
                            CC      MAX_TIB_LENGTH
                            CW      $ACCEPT
                            CW      $#TIB
                            CW      $STORE
                            CW      $ZERO
                            CW      $TOIN
                            CW      $STORE
                            CW      $TRUE
REFILL_EXIT:
                        CW      $EXIT

;  INPUT>R
                        $COLON  'INPUT>R',$INPUTTOR,VEF_COMPILE_ONLY
                        CW      $RFROM
                        CW      $SOURCE_ID
                        CW      $TOR
                        CW      $BLK
                        CW      $FETCH
                        CW      $TOR
                        CW      $TOIN
                        CW      $FETCH
                        CW      $TOR
                        CW      $CURRENT_FILE_POSITION
                        CW      $2FETCH
                        CW      $2TOR
                        CW      $TOR
                        CW      $EXIT

;  INPUT<R
                        $COLON  'INPUT<R',$INPUTFROMR,VEF_COMPILE_ONLY
                        CW      $RFROM
                        CW      $2RFROM
                        CW      $RFROM
                        CW      $DUP
                        CW      $TOIN
                        CW      $STORE
                        CW      $STOD
                        CW      $DADD
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE
                        CW      $RFROM
                        CW      $BLK
                        CW      $STORE
                        CW      $RFROM
                        CW      $DUP
                        CW      $SOURCE_ID_STORE
                        CW      $ZEROGR
                        CW      $QBRANCH
                        CW      INPUTFROMR_EXIT
                          CW      $CURRENT_FILE_POSITION
                          CW      $2FETCH
                          CW      $SOURCE_ID
                          CW      $REPOSITION_FILE
                          CW      $REFILL
                          CW      $2DROP
INPUTFROMR_EXIT:
                        CW      $TOR
                        CW      $EXIT

