;******************************************************************************
;
;  source.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
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
;  >0              File handle
                        $DEF    'SOURCE-ID',$SOURCE_ID
                        PUSHDS  <[DWORD PTR EDI + SOURCE_ID_VAR]>
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
                        CFETCH  $BLK
                        CW      $QDUP
                        CQBR    SOURCE_NOT_BLOCK
                          CW      $BLOCK
                          CCLIT   1024
                        CBR     SOURCE_EXIT
SOURCE_NOT_BLOCK:
                          CW      $SOURCE_ID
                          CW      $ZEROLE
                          CQBR    SOURCE_NOT_EVALUATE
                            CFETCH  $EVAL
                            CFETCH  $#EVAL
                          CBR     SOURCE_NOT_EVALUATE_EXIT
SOURCE_NOT_EVALUATE:
                          CW      $SOURCE_ID
                          CW      $ZEROEQ
                          CQBR    SOURCE_NOT_USER
                            CW      $TIB
                            CFETCH  $#TIB
                          CBR     SOURCE_NOT_USER_EXIT
SOURCE_NOT_USER:
                            CW      $LINE
                            CFETCH  $#LINE
SOURCE_NOT_USER_EXIT:
SOURCE_NOT_EVALUATE_EXIT:
SOURCE_EXIT:
                        CEXIT
                        
;  6.2.2125 REFILL
                        $DEF    'REFILL',$REFILL,$ENTER
                        CFETCH  $BLK
                        CW      $QDUP
                        CQBR    REFILL_NOT_BLOCK
                          CW      $1ADD
                          CSTORE  $BLK
                          CW      $ZERO
                          CSTORE  $TOIN
                          CW      $TRUE
                        CBR     REFILL_EXIT
REFILL_NOT_BLOCK:
                          CW      $SOURCE_ID
                          CW      $QDUP
                          CQBR    REFILL_FROM_USER
                            CW      $ZEROLE
                            CQBR    REFILL_FROM_FILE
                              CW      $FALSE
                            CBR     REFILL_EVAL_EXIT
REFILL_FROM_FILE:
                              CW      $LINE
                              CCLIT   MAX_LINE_LENGTH
                              CW      $SOURCE_ID
                              CW      $READ_LINE
                              CW      $DROP
                              CW      $SWAP
                              CSTORE  $#LINE
                              CW      $ZERO
                              CSTORE  $TOIN
REFILL_EVAL_EXIT:
                          CBR     REFILL_EXIT
REFILL_FROM_USER:
                            CW      $TIB
                            CCLIT   MAX_TIB_LENGTH
                            CW      $ACCEPT
                            CSTORE  $#TIB
                            CW      $ZERO
                            CSTORE  $TOIN
                            CW      $TRUE
REFILL_EXIT:
                        CEXIT

;  INPUT>R
                        $COLON  'INPUT>R',$INPUTTOR,VEF_COMPILE_ONLY
                        CW      $RFROM
                        CW      $SOURCE_ID
                        CW      $TOR
                        CFETCH  $BLK
                        CW      $TOR
                        CFETCH  $TOIN
                        CW      $TOR
                        CW      $CURRENT_FILE_POSITION
                        CW      $2FETCH
                        CW      $2TOR
                        CW      $TOR
                        CEXIT

;  INPUT<R
                        $COLON  'INPUT<R',$INPUTFROMR,VEF_COMPILE_ONLY
                        CW      $RFROM
                        CW      $2RFROM
                        CW      $RFROM
                        CW      $DUP
                        CSTORE  $TOIN
                        CW      $STOD
                        CW      $DADD
                        CW      $CURRENT_FILE_POSITION
                        CW      $2STORE
                        CW      $RFROM
                        CSTORE  $BLK
                        CW      $RFROM
                        CW      $DUP
                        CW      $SOURCE_ID_STORE
                        CW      $ZEROGR
                        CQBR    INPUTFROMR_EXIT
                          CW      $CURRENT_FILE_POSITION
                          CW      $2FETCH
                          CW      $SOURCE_ID
                          CW      $REPOSITION_FILE
                          CW      $REFILL
                          CW      $2DROP
INPUTFROMR_EXIT:
                        CW      $TOR
                        CEXIT

