;******************************************************************************
;
;  interpret.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  INTERPRET support
;******************************************************************************

;  >NUMBER-SIGNED
                        $USER   '>NUMBER-SIGNED',$TONUMBER_SIGNED
                        CC      TONUMBER_SIGNED_VAR

;  DO-INT-DEFINED
                        $COLON  'DO-INT-DEFINED',$DO_INT_DEFINED
                        CW      $OVER
                        CW      $TONAME
                        CW      $1SUB
                        CW      $CFETCH
                        CW      $LIT
                        CC      VEF_COMPILE_ONLY
                        CW      $AND
                        CW      $ZERONOEQ
                        CW      $QBRANCH
                        CW      DID_INTERPRET
                          CW      $LIT
                          CC      -14
                          CW      $THROW
DID_INTERPRET:
                        CW      $DROP
                        CW      $EXECUTE
                        CW      $EXIT

;  DO-COMP-DEFINED
                        $COLON  'DO-COMP-DEFINED',$DO_COMP_DEFINED
                        CW      $ZEROGR
                        CW      $QBRANCH
                        CW      DCD_NOT_IMMEDIATE
                          CW      $EXECUTE
                        CW      $BRANCH
                        CW      DCD_EXIT
DCD_NOT_IMMEDIATE:
                          CW      $COMPILEC
DCD_EXIT:
                        CW      $EXIT

;  DO-DEFINED
                        $COLON  'DO-DEFINED',$DO_DEFINED
                        CW      $STATE
                        CW      $FETCH
                        CW      $QBRANCH
                        CW      DD_INTERPRETATION
                          CW      $DO_COMP_DEFINED
                        CW      $BRANCH
                        CW      DD_EXIT
DD_INTERPRETATION:
                          CW      $DO_INT_DEFINED
DD_EXIT:
                        CW      $EXIT

;  IL-CHECK-SIGN
;  ( C-ADDR -- C-ADDR U )
                        $COLON  'IL-CHECK-SIGN',$ILCS
                        CW      $FALSE
                        CW      $TONUMBER_SIGNED
                        CW      $STORE
                        CW      $COUNT
                        CW      $OVER
                        CW      $CFETCH
                        CW      $DUP
                        CW      $LIT
                        CC      '-'
                        CW      $NOEQ
                        CW      $QBRANCH
                        CW      ILCS_SIGNED
                        CW      $LIT
                        CC      '+'
                        CW      $NOEQ
                        CW      $QBRANCH
                        CW      ILCS_UNSIGNED
                        CW      $BRANCH
                        CW      ILCS_EXIT
ILCS_SIGNED:
                        CW      $DROP
                        CW      $TRUE
                        CW      $TONUMBER_SIGNED
                        CW      $STORE
ILCS_UNSIGNED:
                        CW      $SWAP
                        CW      $CHARADD
                        CW      $SWAP
                        CW      $1SUB
ILCS_EXIT:
                        CW      $EXIT

;  IL-CHECK-LIT
;  ( C-ADDR U - N TRUE | C-ADDR U FALSE )
                        $COLON  'IL-CHECK-LIT',$ILCL
                        CW      $ZERO
                        CW      $DUP
                        CW      $2SWAP
                        CW      $TONUMBER
                        CW      $DUP
                        CW      $ZEROEQ
                        CW      $QBRANCH
                        CW      ILCL_NO
                          CW      $2DROP
                          CW      $DROP
                          CW      $TONUMBER_SIGNED
                          CW      $FETCH
                          CW      $QBRANCH
                          CW      ILCL_UNSIGNED
                            CW      $NEGATE
ILCL_UNSIGNED:
                          CW      $TRUE
                        CW      $BRANCH
                        CW      ILCL_EXIT
ILCL_NO:
                          CW      $FALSE
ILCL_EXIT:
                        CW      $EXIT

;  DO-LIT
                        $COLON  'DO-LIT',$DO_LIT
                        CW      $STATE
                        CW      $FETCH
                        CW      $QBRANCH
                        CW      DL_EXIT
                          CW      $LITERAL
DL_EXIT:
                        CW      $EXIT

;  IL-CHECK-2LIT
;  ( D C-ADDR U - D TRUE | FALSE )
                        $COLON  'IL-CHECK-2LIT',$ILC2L
                        CW      $1SUB
                        CW      $ZEROEQ
                        CW      $QBRANCH
                        CW      ILC2L_EXIT2
                        CW      $CFETCH
                        CW      $LIT
                        CC      '.'
                        CW      $EQ
                        CW      $QBRANCH
                        CW      ILC2L_EXIT1
                        CW      $TONUMBER_SIGNED
                        CW      $FETCH
                        CW      $QBRANCH
                        CW      ILC2L_UNSIGNED
                        CW      $DNEGATE
ILC2L_UNSIGNED:
                        CW      $TRUE
                        CW      $BRANCH
                        CW      ILC2L_EXIT
ILC2L_EXIT2:
                        CW      $DROP
ILC2L_EXIT1:
                        CW      $2DROP
                        CW      $FALSE
ILC2L_EXIT:
                        CW      $EXIT

;  DO-2LIT
                        $COLON  'DO-2LIT',$DO_2LIT
                        CW      $STATE
                        CW      $FETCH
                        CW      $QBRANCH
                        CW      D2L_EXIT
                          CW      $2LITERAL
D2L_EXIT:
                        CW      $EXIT

;  INTERPRET-LITERAL
;  ( C-ADDR -- )
                        $COLON  'INTERPRET-LITERAL',$INTERPRET_LITERAL
                        CW      $ILCS
                        CW      $ILCL
                        CW      $QBRANCH
                        CW      IL_CHECK_2LIT
                          CW      $DO_LIT
                          CW      $TRUE
                          CW      $EXIT
IL_CHECK_2LIT:
                        CW      $ILC2L
                        CW      $QBRANCH
                        CW      IL_UNKNOWN
                          CW      $DO_2LIT
                          CW      $TRUE
                          CW      $EXIT
IL_UNKNOWN:
                        CW      $FALSE
                        CW      $EXIT

;  INTERPRET-WORD
;  ( C-ADDR -- )
                        $COLON  'INTERPRET-WORD',$INTERPRET_WORD
                        CW      $FIND
                        CW      $QDUP
                        CW      $QBRANCH
                        CW      IW_NOT_FOUND
                          CW      $DO_DEFINED
                        CW      $BRANCH
                        CW      IW_EXIT
IW_NOT_FOUND:
                          CW      $INTERPRET_LITERAL
                          CW      $INVERT
                          CW      $QBRANCH
                          CW      IW_EXIT
                            CW      $LIT
                            CC      -13
                            CW      $THROW
IW_EXIT:
                        CW      $EXIT

;  INTERPRET
                        $COLON  'INTERPRET',$INTERPRET
INT_LOOP:
                        CW      $BL
                        CW      $WORD                   ; c-addr
                        CW      $DUP                    ; c-addr c-addr
                        CW      $COUNT                  ; c-addr c-addr1 count
                        CW      $NIP                    ; c-addr count
                        CW      $QBRANCH
                        CW      INT_EXIT                ; exit loop if parse area is exhausted
                          CW      $INTERPRET_WORD
                        CW      $BRANCH
                        CW      INT_LOOP
INT_EXIT:
                        CW      $DROP
                        CW      $EXIT

