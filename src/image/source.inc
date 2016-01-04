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
                        $CODE   'SOURCE-ID',$SOURCE_ID,VEF_USUAL
                        PUSHDS  [EDI + SOURCE_ID_VAR]
                        $NEXT

;  SOURCE-ID!
                        $CODE   'SOURCE-ID!',$SOURCE_ID_STORE,VEF_USUAL
                        POPDS   [EDI + SOURCE_ID_VAR]
                        $NEXT

;  6.1.2216 SOURCE
;  c-addr is the address of, and u is the number of characters in
;  the input buffer. 
;  D: -- c-addr u
                        $COLON  0,$_SOURCE

                        CW      $FILE_LINE
                        CFETCH  $HASH_FILE_LINE
                        CEXIT

                        $DEFER  'SOURCE',$SOURCE

                        CW      $_SOURCE
                        
;  6.2.2125 REFILL
;  D: -- flag
                        $COLON  0,$_REFILL

                        CW      $FILE_LINE
                        CCLIT   MAX_FILE_LINE_LENGTH
                        CW      $SOURCE_ID
                        CW      $READ_LINE
                        CW      $DROP
                        CW      $SWAP
                        CSTORE  $HASH_FILE_LINE
                        CW      $ZERO
                        CSTORE  $TOIN
                        CEXIT

                        $DEFER  'REFILL',$REFILL

                        CW      $_REFILL 

                        $DEFER  '(SAVE-INPUT)',$PSAVE_INPUT

                        CW      $SAVE_INPUT_FILE

                        $COLON  'SAVE-INPUT',$SAVE_INPUT

                        CW      $PSAVE_INPUT
                        CEXIT

                        $COLON  'RESTORE-INPUT',$RESTORE_INPUT

                        CW      $1SUB
                        CW      $SWAP
                        CW      $EXECUTE
                        CW      $FALSE
                        CEXIT

                        $DEFER  '(RESET-INPUT)',$PRESET_INPUT

                        CW      $RESET_INPUT_FILE

                        $COLON  'RESET-INPUT',$RESET_INPUT

                        CW      $PRESET_INPUT
                        CEXIT

;  INPUT>R
                        $COLON  'INPUT>R',$INPUT_TO_R,VEF_COMPILE_ONLY

                        CW      $RFROM
                        CW      $SAVE_INPUT
                        CW      $N_TO_R
                        CW      $TOR
                        CEXIT

;  R>INPUT
                        $COLON  'R>INPUT',$R_TO_INPUT,VEF_COMPILE_ONLY

                        CW      $RFROM
                        CW      $N_R_FROM
                        CW      $RESTORE_INPUT
                        CW      $DROP
                        CW      $TOR
                        CEXIT

