;******************************************************************************
;
;  source.inc
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
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

                        PUSHDS  <DWORD [EDI + VAR_SOURCE_ID]>
                        $NEXT

;  SOURCE-ID!
                        $CODE   'SOURCE-ID!',$SOURCE_ID_STORE,VEF_USUAL

                        POPDS   <DWORD [EDI + VAR_SOURCE_ID]>
                        $NEXT

;  6.1.2216 SOURCE
;  c-addr is the address of, and u is the number of characters in
;  the input buffer.
;  D: -- c-addr u
                        $NONAME $_SOURCE

                        CW      $FILE_LINE
                        CFETCH  $HASH_FILE_LINE
                        CEXIT

                        $DEFER  'SOURCE',$SOURCE

                        CW      $_SOURCE

                        $COLON  'REPORT-SOURCE',$REPORT_SOURCE
                        $WRITE  'LINE# H# '
                        CFETCH  $ERROR_LINE_NUM
                        CW      $HOUT8
                        $WRITE  '  '
                        CW      $REFILL_SOURCE
                        CW      $2FETCH
                        CW      $TYPE
                        CEXIT

                        $COLON  'REPORT-SOURCE!',$REPORT_SOURCE_STORE
                        CW      $SOURCE
                        CW      $REFILL_SOURCE
                        CW      $2STORE
                        CFETCH  $INCLUDE_LINE_NUM
                        CW      $1ADD
                        CW      $DUP
                        CSTORE  $INCLUDE_LINE_NUM
                        CSTORE  $ERROR_LINE_NUM
                        CEXIT

;  6.2.2125 REFILL
;  D: -- flag
                        $NONAME $_REFILL

                        CW      $FILE_LINE
                        CCLIT   MAX_FILE_LINE_LENGTH
                        CW      $SOURCE_ID
                        CW      $READ_LINE
                        CW      $DROP
                        CW      $SWAP
                        CSTORE  $HASH_FILE_LINE
                        CW      $ZERO
                        CSTORE  $TOIN

                        CW      $REPORT_SOURCE_STORE

                        MATCH   =TRUE, DEBUG {
                        $CR
                        $WRITE  'REFILL: '
                        CW      $REPORT_SOURCE
                        }

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

