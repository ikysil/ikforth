;******************************************************************************
;
;  tc-def.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************


;******************************************************************************
;  $XTDEF defines macro with name XT_CFA_NAME
;  Can be used instead of CW CFA_NAME sequence
;******************************************************************************
                        MACRO   $XTDEF NAME,CFA_NAME {
                        IF      ~ CFA_NAME EQ
                          MACRO   XT_#CFA_NAME# \{
                          CW      CFA_NAME
                          \}
                        END IF
                        }

;******************************************************************************
;  Use this macro to compile FORTH threaded code definitions
;******************************************************************************
                        MACRO   CW [CFA_NAME] {
                        DD      CFA_#CFA_NAME + IMAGE_BASE
                        }

                        MACRO   PW [CFA_NAME] {
                        DD      PFA_#CFA_NAME + IMAGE_BASE
                        }

                        MACRO   CWLIT [VALUE] {
                        CW      $LIT
                        CW      VALUE
                        }

;******************************************************************************
;  Use this macro to compile constants
;******************************************************************************
                        MACRO   CC [VALUE] {
                        DD      VALUE
                        }

                        MACRO   CCLIT [VALUE] {
                        CW      $LIT
                        DD      VALUE
                        }

;******************************************************************************
;  Compile @
;******************************************************************************
                        MACRO   CFETCH [ADDR] {
                        CW      ADDR
                        CW      $FETCH
                        }

;******************************************************************************
;  Compile !
;******************************************************************************
                        MACRO   CSTORE [ADDR] {
                        CW      ADDR
                        CW      $STORE
                        }

;******************************************************************************
;  Compile a conditional branch ?BRANCH
;******************************************************************************
                        MACRO   CQBR VALUE {
                        CW      $QBRANCH
                        CC      VALUE + IMAGE_BASE
                        }

;******************************************************************************
;  Compile an unconditional branch BRANCH
;******************************************************************************
                        MACRO   CBR VALUE {
                        CW      $BRANCH
                        CC      VALUE + IMAGE_BASE
                        }

;******************************************************************************
;  Compile THROW
;******************************************************************************
                        MACRO   CTHROW VALUE {
                        CCLIT   VALUE
                        CW      $THROW
                        }

;******************************************************************************
;  Flow control - IF ELSE THEN
;******************************************************************************
                MACRO       _?LBL LBL {
                IF          LBL eq
                DISPLAY     "ERROR: LBL is required"
                ERR
                END IF
                }

                MACRO       _IF LBL {
                _?LBL       LBL
                IF          DEFINED LBL#_ELSE
                CQBR        LBL#_ELSE
                ELSE
                CQBR        LBL#_THEN
                END IF
                }

                MACRO       _ELSE LBL {
                _?LBL       LBL
                CBR         LBL#_THEN
                LABEL       LBL#_ELSE
                }

                MACRO       _THEN LBL {
                _?LBL       LBL
                LABEL       LBL#_THEN
                }
