;******************************************************************************
;
;  header-itc.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  HEADER & support words - implementation for ITC (Indirect Threaded Code)
;******************************************************************************

;  CFA@
;  D: xt -- code-addr
;  code-addr is the code address of the word xt
                        $COLON  'CFA@',$CFAFETCH
                        XT_$FETCH
                        XT_$EXIT

;  CFA!
;  D: code-addr xt --
;  Change a code address of the word xt to code-addr
                        $COLON  'CFA!',$CFASTORE
                        XT_$STORE
                        XT_$EXIT

;  CODE-ADDRESS!
;  D: code-addr xt --
;  Create a code field with code address code-addr at xt
;  Alias to CFA! on ITC systems
                        $COLON  'CODE-ADDRESS!',$CODE_ADDRESS_STORE
                        XT_$CFASTORE
                        XT_$EXIT

;  6.1.0550 >BODY
;  Convert CFA to PFA
;  D: CFA -- PFA
                        $COLON  '>BODY',$TOBODY
                        CCLIT   CFA_SIZE
                        XT_$ADD
                        XT_$EXIT

                        $CONST  'HOST-ITC?',,F_TRUE

                        $CONST  'HOST-DTC?',,F_FALSE
