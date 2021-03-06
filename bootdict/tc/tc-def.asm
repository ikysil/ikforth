;******************************************************************************
;
;  tc-def.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************


;******************************************************************************
;  Use this macro to compile FORTH threaded code definitions
;******************************************************************************
                MACRO       CW [CFA_NAME] {
                DD          CFA_#CFA_NAME + IMAGE_BASE
                }

                MACRO       PW [CFA_NAME] {
                DD          PFA_#CFA_NAME + IMAGE_BASE
                }

                MACRO       CWLIT [VALUE] {
                CW          $LIT
                CW          VALUE
                }

;******************************************************************************
;  Use this macro to compile constants
;******************************************************************************
                MACRO       CC [VALUE] {
                DD          VALUE
                }

                MACRO       CCLIT [VALUE] {
                CW          $LIT
                DD          VALUE
                }

;******************************************************************************
;  Compile @
;******************************************************************************
                MACRO       CFETCH [ADDR] {
                CW          ADDR
                CW          $FETCH
                }

;******************************************************************************
;  Compile !
;******************************************************************************
                MACRO       CSTORE [ADDR] {
                CW          ADDR
                CW          $STORE
                }

;******************************************************************************
;  Compile a conditional branch ?BRANCH
;******************************************************************************
                MACRO       CQBR VALUE {
                CW          $QBRANCH
                CC          VALUE + IMAGE_BASE
                }

;******************************************************************************
;  Compile an unconditional branch BRANCH
;******************************************************************************
                MACRO       CBR VALUE {
                CW          $BRANCH
                CC          VALUE + IMAGE_BASE
                }

;******************************************************************************
;  Compile THROW
;******************************************************************************
                MACRO       CTHROW VALUE {
                CCLIT       VALUE
                CW          $THROW
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

                MACRO       _BEGIN LBL {
                _?LBL       LBL
                LABEL       LBL#_BEGIN
                }

                MACRO       _UNTIL LBL {
                _?LBL       LBL
                CQBR        LBL#_BEGIN
                }

                MACRO       _AGAIN LBL {
                _?LBL       LBL
                CBR         LBL#_BEGIN
                }

                MACRO       _WHILE LBL {
                _?LBL       LBL
                CQBR        LBL#_REPEAT
                }

                MACRO       _REPEAT LBL {
                _?LBL       LBL
                CBR         LBL#_BEGIN
                LABEL       LBL#_REPEAT
                }
