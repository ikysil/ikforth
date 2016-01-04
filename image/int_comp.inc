;******************************************************************************
;
;  int_comp.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Interpretation/compilation time helper words
;******************************************************************************

;  IS-INT/COMP?
                        $COLON  'IS-INT/COMP?',$IS_INT_COMPQ
                        CW      $FETCH
                        CW      $LIT
                        CW      $PDO_INT_COMP
                        CW      $EQ
                        CW      $EXIT

;  INT/COMP>INT
                        $COLON  'INT/COMP>INT',$INT_COMP_TO_INT
                        CW      $TOBODY
                        CW      $FETCH
                        CW      $EXIT

;  INT/COMP>COMP
                        $COLON  'INT/COMP>COMP',$INT_COMP_TO_COMP
                        CW      $TOBODY
                        CW      $CELLADD
                        CW      $FETCH
                        CW      $EXIT

;  COMP'
                        $COLON  'COMP''',$COMP_TICK
                        CW      $BL
                        CW      $WORD
                        CW      $FIND
                        CW      $DUP
                        CW      $ZEROEQ
                        CW      $QBRANCH
                        CW      CT_FOUND
                          CW      $LIT
                          CC      -13
                          CW      $THROW
CT_FOUND:
                        CW      $OVER
                        CW      $IS_INT_COMPQ
                        CW      $TRUE
                        CW      $EQ
                        CW      $QBRANCH
                        CW      CT_NO_I_C
                          CW      $SWAP
                          CW      $INT_COMP_TO_COMP
                          CW      $SWAP
CT_NO_I_C:
                        CW      $ZEROLE
                        CW      $QBRANCH
                        CW      CT_IMM
                          CW      $LIT
                          CW      $COMPILEC
                          CW      $BRANCH
                          CW      CT_EXIT
CT_IMM:
                          CW      $LIT
                          CW      $EXECUTE
CT_EXIT:
                        CW      $EXIT

;  POSTPONE,
                        $COLON  'POSTPONE,',$POSTPONEC
                        CW      $SWAP
                        CW      $LITERAL
                        CW      $COMPILEC
                        CW      $EXIT

;  POSTPONE
                        $COLON  'POSTPONE',$POSTPONE,VEF_IMMEDIATE
                        CW      $COMP_TICK
                        CW      $POSTPONEC
                        CW      $EXIT

;  [COMPILE]
                        $COLON  '[COMPILE]',,VEF_IMMEDIATE
                        CW      $COMP_TICK
                        CW      $DROP
                        CW      $COMPILEC
                        CW      $EXIT

