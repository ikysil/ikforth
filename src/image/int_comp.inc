;******************************************************************************
;
;  int_comp.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
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

                        CW      $CFAFETCH
                        CWLIT   $PDO_INT_COMP
                        CW      $EQ
                        CEXIT

;  INT/COMP>INT
                        $COLON  'INT/COMP>INT',$INT_COMP_TO_INT

                        CW      $TOBODY
                        CW      $FETCH
                        CEXIT

;  INT/COMP>COMP
                        $COLON  'INT/COMP>COMP',$INT_COMP_TO_COMP

                        CW      $TOBODY
                        CW      $CELLADD
                        CW      $FETCH
                        CEXIT

;  COMP'
                        $COLON  'COMP''',$COMP_TICK

                        CW      $BL
                        CW      $WORD
                        CW      $FIND
                        CW      $DUP
                        CW      $ZEROEQ
                        CQBR    CT_FOUND
                          CTHROW  -13
CT_FOUND:
                        CW      $OVER
                        CW      $IS_INT_COMPQ
                        CW      $TRUE
                        CW      $EQ
                        CQBR    CT_NO_I_C
                          CW      $SWAP
                          CW      $INT_COMP_TO_COMP
                          CW      $SWAP
CT_NO_I_C:
                        CW      $ZEROLE
                        CQBR    CT_IMM
                          CWLIT   $COMPILEC
                          CBR     CT_EXIT
CT_IMM:
                          CWLIT   $EXECUTE
CT_EXIT:
                        CEXIT

;  POSTPONE,
                        $COLON  'POSTPONE,',$POSTPONEC

                        CW      $SWAP
                        CW      $LITERAL
                        CW      $COMPILEC
                        CEXIT

;  POSTPONE
                        $COLON  'POSTPONE',,VEF_IMMEDIATE

                        CW      $COMP_TICK
                        CW      $POSTPONEC
                        CEXIT

