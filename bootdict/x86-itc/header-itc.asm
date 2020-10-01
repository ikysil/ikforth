;******************************************************************************
;
;  header-itc.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  HEADER & support words - implementation for ITC (Indirect Threaded Code)
;******************************************************************************

;  CFA@
;  D: xt -- code-addr
;  code-addr is the code address of the word xt
                $COLON      'CFA@',$CFAFETCH
                CW          $FETCH
                $END_COLON

;  CFA!
;  D: code-addr xt --
;  Change a code address of the word xt to code-addr
                $COLON      'CFA!',$CFASTORE
                CW          $STORE
                $END_COLON

;  CODE-ADDRESS!
;  D: code-addr xt --
;  Create a code field with code address code-addr at xt
;  Alias to CFA! on ITC systems
                $COLON      'CODE-ADDRESS!',$CODE_ADDRESS_STORE
                CW          $CFASTORE
                $END_COLON

                $CONST      'HOST-ITC?',,F_TRUE

                $CONST      'HOST-DTC?',,F_FALSE
