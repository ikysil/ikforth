;******************************************************************************
;
;  header-dtc.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  HEADER & support words - implementation for DTC (Direct Threaded Code)
;******************************************************************************

                $CFA        -IMAGE_BASE,TMPLT_START,TMPLT_CODE_ADDR_END,TMPLT_END

;  CFA@
;  D: xt -- code-addr
;  code-addr is the code address of the word xt
                $COLON      'CFA@',$CFAFETCH
                CCLIT       CFA_EXECUTOR_OFFSET
                CW          $ADD, $FETCH
                $END_COLON

;  CFA!
;  D: code-addr xt --
;  Change a code address of the word xt to code-addr
                $COLON      'CFA!',$CFASTORE
                CCLIT       CFA_EXECUTOR_OFFSET
                CW          $ADD, $STORE
                $END_COLON

;  CODE-ADDRESS!
;  D: code-addr xt --
;  Create a code field with code address code-addr at xt
                $COLON      'CODE-ADDRESS!',$CODE_ADDRESS_STORE
                CW          $DUP
                ; D: code-addr xt xt
                CWLIT       TMPLT_START
                ; D: code-addr xt xt CFA_START
                CW          $SWAP
                ; D: code-addr xt CFA_START xt
                CCLIT       CFA_SIZE
                ; D: code-addr xt CFA_START xt CFA_SIZE
                CW          $CMOVE
                ; D: code-addr xt
                CW          $CFASTORE
                $END_COLON

                $CONST      'HOST-ITC?',,F_FALSE

                $CONST      'HOST-DTC?',,F_TRUE
