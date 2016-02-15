;******************************************************************************
;
;  int_comp.inc
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Interpretation/compilation time helper words
;******************************************************************************

;  (DO-INT/COMP)
                        $CREATE '(DO-INT/COMP)'
                        LABEL   CFA_$PDO_INT_COMP
                        ADD     EAX,CFA_SIZE
                        CMP     BYTE [VAR_STATE + IMAGE_BASE],F_FALSE
                        JZ      PDIC_INT
                        ADD     EAX,CELL_SIZE
PDIC_INT:
                        MOV     EAX,DWORD [EAX]
                        $JMP

;  IS-INT/COMP?
                        $COLON  'IS-INT/COMP?',$IS_INT_COMPQ

                        XT_$CFAFETCH
                        CWLIT   $PDO_INT_COMP
                        XT_$EQ
                        XT_$EXIT

;  INT/COMP>INT
                        $COLON  'INT/COMP>INT',$INT_COMP_TO_INT

                        XT_$TOBODY
                        XT_$FETCH
                        XT_$EXIT

;  INT/COMP>COMP
                        $COLON  'INT/COMP>COMP',$INT_COMP_TO_COMP

                        XT_$TOBODY
                        XT_$CELLADD
                        XT_$FETCH
                        XT_$EXIT

;  COMP'
                        $COLON  'COMP''',$COMP_TICK

                        XT_$BL
                        XT_$WORD
                        XT_$FIND
                        XT_$DUP
                        XT_$ZEROEQ
                        CQBR    CT_FOUND
                          CTHROW  -13
CT_FOUND:
                        XT_$OVER
                        XT_$IS_INT_COMPQ
                        XT_$TRUE
                        XT_$EQ
                        CQBR    CT_NO_I_C
                          XT_$SWAP
                          XT_$INT_COMP_TO_COMP
                          XT_$SWAP
CT_NO_I_C:
                        XT_$ZEROLE
                        CQBR    CT_IMM
                          CWLIT   $COMPILEC
                          CBR     CT_EXIT
CT_IMM:
                          CWLIT   $EXECUTE
CT_EXIT:
                        XT_$EXIT

;  POSTPONE,
                        $COLON  'POSTPONE,',$POSTPONEC

                        XT_$SWAP
                        XT_$LITERAL
                        XT_$COMPILEC
                        XT_$EXIT

;  POSTPONE
                        $COLON  'POSTPONE',,VEF_IMMEDIATE

                        XT_$COMP_TICK
                        XT_$POSTPONEC
                        XT_$EXIT

