;******************************************************************************
;
;  interpret.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
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
                        CW      $TO_HEAD
                        CW      $HFLAGS_FETCH
                        CCLIT   VEF_COMPILE_ONLY
                        CW      $AND
                        CW      $ZERONOEQ
                        CQBR    DID_INTERPRET
                          CTHROW  -14
DID_INTERPRET:
                        CW      $DROP
                        CW      $EXECUTE
                        CEXIT

;  DO-COMP-DEFINED
                        $COLON  'DO-COMP-DEFINED',$DO_COMP_DEFINED

                        CW      $ZEROGR
                        CQBR    DCD_NOT_IMMEDIATE
                          CW      $EXECUTE
                        CBR     DCD_EXIT
DCD_NOT_IMMEDIATE:
                          CW      $COMPILEC
DCD_EXIT:
                        CEXIT

;  DO-DEFINED
                        $COLON  'DO-DEFINED',$DO_DEFINED

                        CFETCH  $STATE
                        CQBR    DD_INTERPRETATION
                          CW      $DO_COMP_DEFINED
                        CBR     DD_EXIT
DD_INTERPRETATION:
                          CW      $DO_INT_DEFINED
DD_EXIT:
                        CEXIT

;  IL-CHECK-SIGN
;  ( C-ADDR U -- C-ADDR U )
                        $COLON  'IL-CHECK-SIGN',$ILCS

                        CW      $FALSE
                        CSTORE  $TONUMBER_SIGNED
                        CW      $OVER
                        CW      $CFETCH
                        CW      $DUP
                        CCLIT   45 ;'-'
                        CW      $NOEQ
                        CQBR    ILCS_SIGNED
                        CCLIT   43 ;'+'
                        CW      $NOEQ
                        CQBR    ILCS_UNSIGNED
                        CBR     ILCS_EXIT
ILCS_SIGNED:
                        CW      $DROP
                        CW      $TRUE
                        CSTORE  $TONUMBER_SIGNED
ILCS_UNSIGNED:
                        CW      $SWAP
                        CW      $CHARADD
                        CW      $SWAP
                        CW      $1SUB
ILCS_EXIT:
                        CEXIT

;  IL-CHECK-LIT
;  ( C-ADDR U - N TRUE | C-ADDR U FALSE )
                        $COLON  'IL-CHECK-LIT',$ILCL

                        CW      $ZERO
                        CW      $DUP
                        CW      $2SWAP
                        CW      $TONUMBER
                        CW      $DUP
                        CW      $ZEROEQ
                        CQBR    ILCL_NO
                          CW      $2DROP
                          CW      $DROP
                          CFETCH  $TONUMBER_SIGNED
                          CQBR    ILCL_UNSIGNED
                            CW      $NEGATE
ILCL_UNSIGNED:
                          CW      $TRUE
                        CBR     ILCL_EXIT
ILCL_NO:
                          CW      $FALSE
ILCL_EXIT:
                        CEXIT

;  DO-LIT
                        $COLON  'DO-LIT',$DO_LIT

                        CFETCH  $STATE
                        CQBR    DL_EXIT
                          CW      $LITERAL
DL_EXIT:
                        CEXIT

;  IL-CHECK-2LIT
;  ( D C-ADDR U - D TRUE | FALSE )
                        $COLON  'IL-CHECK-2LIT',$ILC2L

                        CW      $1SUB
                        CW      $ZEROEQ
                        CQBR    ILC2L_EXIT2
                        CW      $CFETCH
                        CCLIT   46 ;'.'
                        CW      $EQ
                        CQBR    ILC2L_EXIT1
                        CFETCH  $TONUMBER_SIGNED
                        CQBR    ILC2L_UNSIGNED
                        CW      $DNEGATE
ILC2L_UNSIGNED:
                        CW      $TRUE
                        CBR     ILC2L_EXIT
ILC2L_EXIT2:
                        CW      $DROP
ILC2L_EXIT1:
                        CW      $2DROP
                        CW      $FALSE
ILC2L_EXIT:
                        CEXIT

;  DO-2LIT
                        $COLON  'DO-2LIT',$DO_2LIT

                        CFETCH  $STATE
                        CQBR    D2L_EXIT
                          CW      $2LITERAL
D2L_EXIT:
                        CEXIT

;  INTERPRET-LITERAL
;  ( C-ADDR U -- flag )
                        $COLON  'INTERPRET-LITERAL',$INTERPRET_LITERAL

                        CW      $DUP
                        CW      $ZERO
                        CW      $NOEQ
                        CQBR    IL_UNKNOWN
                        CW      $ILCS           ; c-addr u
                        CW      $DUP            ; c-addr u u
                        CCLIT   1
                        CW      $EQ
                        CQBR    IL_OK1          ; branch if u <> 1
                        CW      $OVER           ; c-addr u c-addr
                        CW      $CFETCH
                        CCLIT   46 ;'.'
                        CW      $EQ
                        CQBR    IL_OK1          ; branch if c-addr @ <> '.'
                        CW      $2DROP
                        CBR     IL_UNKNOWN
IL_OK1:
                        CW      $ILCL
                        CQBR    IL_CHECK_2LIT
                          CW      $DO_LIT
                          CW      $TRUE
                          CBR     IL_EXIT
IL_CHECK_2LIT:
                        CW      $ILC2L
                        CQBR    IL_UNKNOWN
                          CW      $DO_2LIT
                          CW      $TRUE
                          CBR     IL_EXIT
IL_UNKNOWN:
                        CW      $FALSE
IL_EXIT:
                        CEXIT

;  INTERPRET-WORD
;  ( C-ADDR -- )
                        $COLON  'INTERPRET-WORD',$INTERPRET_WORD

                        CW      $FIND
                        CW      $QDUP
                        CQBR    IW_NOT_FOUND
                          CW      $DO_DEFINED
                        CBR     IW_EXIT
IW_NOT_FOUND:
                          CW      $DUP
                          CW      $TOR
                          CW      $COUNT
                          CW      $INTERPRET_LITERAL
                          CW      $INVERT
                          CQBR    IW_EXIT_1
                            CW      $RFROM
                            CW      $COUNT
                            CW      $INTERPRET_WORD_NOT_FOUND
                          CBR     IW_EXIT
IW_EXIT_1:
                        CW      $RFROM
                        CW      $DROP
IW_EXIT:
                        CEXIT

;  D: c-addr u -- 
                        $COLON  '(INTERPRET-WORD-NOT-FOUND)',$PINTERPRET_WORD_NOT_FOUND

                        CW      $2DROP
                        CTHROW  -13
                        CEXIT

;  INTERPRET-WORD-NOT-FOUND
;  D: c-addr u -- 
                        $DEFER  'INTERPRET-WORD-NOT-FOUND',$INTERPRET_WORD_NOT_FOUND

                        CW      $PINTERPRET_WORD_NOT_FOUND

;  INTERPRET
                        $COLON  'INTERPRET',$INTERPRET

INT_LOOP:
                        CW      $BL
                        CW      $WORD                   ; c-addr
                        CW      $DUP                    ; c-addr c-addr
                        CW      $COUNT                  ; c-addr c-addr1 count
                        CW      $NIP                    ; c-addr count
                        CQBR    INT_EXIT                ; exit loop if parse area is exhausted
                          CW      $INTERPRET_WORD
                        CBR     INT_LOOP
INT_EXIT:
                        CW      $DROP
                        CEXIT

