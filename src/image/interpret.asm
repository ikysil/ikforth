;******************************************************************************
;
;  interpret.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  INTERPRET support
;******************************************************************************

;  >NUMBER-SIGNED
                        $USER   '>NUMBER-SIGNED',$TONUMBER_SIGNED,VAR_TONUMBER_SIGNED

;  DO-INT-DEFINED
                        $COLON  'DO-INT-DEFINED',$DO_INT_DEFINED

                        XT_$OVER
                        XT_$TO_HEAD
                        XT_$HFLAGS_FETCH
                        CCLIT   VEF_COMPILE_ONLY
                        XT_$AND
                        XT_$ZERONOEQ
                        CQBR    DID_INTERPRET
                          CTHROW  -14
DID_INTERPRET:
                        XT_$DROP
                        XT_$EXECUTE
                        XT_$EXIT

;  DO-COMP-DEFINED
                        $COLON  'DO-COMP-DEFINED',$DO_COMP_DEFINED

                        XT_$ZEROGR
                        CQBR    DCD_NOT_IMMEDIATE
                          XT_$EXECUTE
                        CBR     DCD_EXIT
DCD_NOT_IMMEDIATE:
                          XT_$COMPILEC
DCD_EXIT:
                        XT_$EXIT

;  DO-DEFINED
                        $COLON  'DO-DEFINED',$DO_DEFINED

                        CFETCH  $STATE
                        CQBR    DD_INTERPRETATION
                          XT_$DO_COMP_DEFINED
                        CBR     DD_EXIT
DD_INTERPRETATION:
                          XT_$DO_INT_DEFINED
DD_EXIT:
                        XT_$EXIT

;  IL-CHECK-SIGN
;  ( C-ADDR U -- C-ADDR U )
                        $COLON  'IL-CHECK-SIGN',$ILCS

                        XT_$FALSE
                        CSTORE  $TONUMBER_SIGNED
                        XT_$OVER
                        XT_$CFETCH
                        XT_$DUP
                        CCLIT   45 ;'-'
                        XT_$NOEQ
                        CQBR    ILCS_SIGNED
                        CCLIT   43 ;'+'
                        XT_$NOEQ
                        CQBR    ILCS_UNSIGNED
                        CBR     ILCS_EXIT
ILCS_SIGNED:
                        XT_$DROP
                        XT_$TRUE
                        CSTORE  $TONUMBER_SIGNED
ILCS_UNSIGNED:
                        XT_$SWAP
                        XT_$CHARADD
                        XT_$SWAP
                        XT_$1SUB
ILCS_EXIT:
                        XT_$EXIT

;  IL-CHECK-LIT
;  ( C-ADDR U - N TRUE | C-ADDR U FALSE )
                        $COLON  'IL-CHECK-LIT',$ILCL

                        XT_$ZERO
                        XT_$DUP
                        XT_$2SWAP
                        XT_$TONUMBER
                        XT_$DUP
                        XT_$ZEROEQ
                        CQBR    ILCL_NO
                          XT_$2DROP
                          XT_$DROP
                          CFETCH  $TONUMBER_SIGNED
                          CQBR    ILCL_UNSIGNED
                            XT_$NEGATE
ILCL_UNSIGNED:
                          XT_$TRUE
                        CBR     ILCL_EXIT
ILCL_NO:
                          XT_$FALSE
ILCL_EXIT:
                        XT_$EXIT

;  DO-LIT
                        $COLON  'DO-LIT',$DO_LIT

                        CFETCH  $STATE
                        CQBR    DL_EXIT
                          XT_$LITERAL
DL_EXIT:
                        XT_$EXIT

;  IL-CHECK-2LIT
;  ( D C-ADDR U - D TRUE | FALSE )
                        $COLON  'IL-CHECK-2LIT',$ILC2L

                        XT_$1SUB
                        XT_$ZEROEQ
                        CQBR    ILC2L_EXIT2
                        XT_$CFETCH
                        CCLIT   46 ;'.'
                        XT_$EQ
                        CQBR    ILC2L_EXIT1
                        CFETCH  $TONUMBER_SIGNED
                        CQBR    ILC2L_UNSIGNED
                        XT_$DNEGATE
ILC2L_UNSIGNED:
                        XT_$TRUE
                        CBR     ILC2L_EXIT
ILC2L_EXIT2:
                        XT_$DROP
ILC2L_EXIT1:
                        XT_$2DROP
                        XT_$FALSE
ILC2L_EXIT:
                        XT_$EXIT

;  DO-2LIT
                        $COLON  'DO-2LIT',$DO_2LIT

                        CFETCH  $STATE
                        CQBR    D2L_EXIT
                          XT_$2LITERAL
D2L_EXIT:
                        XT_$EXIT

;  INTERPRET-LITERAL
;  ( C-ADDR U -- flag )
                        $COLON  'INTERPRET-LITERAL',$INTERPRET_LITERAL

                        XT_$DUP
                        XT_$ZERO
                        XT_$NOEQ
                        CQBR    IL_UNKNOWN
                        XT_$ILCS           ; c-addr u
                        XT_$DUP            ; c-addr u u
                        CCLIT   1
                        XT_$EQ
                        CQBR    IL_OK1          ; branch if u <> 1
                        XT_$OVER           ; c-addr u c-addr
                        XT_$CFETCH
                        CCLIT   46 ;'.'
                        XT_$EQ
                        CQBR    IL_OK1          ; branch if c-addr @ <> '.'
                        XT_$2DROP
                        CBR     IL_UNKNOWN
IL_OK1:
                        XT_$ILCL
                        CQBR    IL_CHECK_2LIT
                          XT_$DO_LIT
                          XT_$TRUE
                          CBR     IL_EXIT
IL_CHECK_2LIT:
                        XT_$ILC2L
                        CQBR    IL_UNKNOWN
                          XT_$DO_2LIT
                          XT_$TRUE
                          CBR     IL_EXIT
IL_UNKNOWN:
                        XT_$FALSE
IL_EXIT:
                        XT_$EXIT

;  D: c-addr u --
                        $NONAME $PINTERPRET_WORD_NOT_FOUND

                        XT_$2DROP
                        CTHROW  -13
                        XT_$EXIT

;  INTERPRET-WORD-NOT-FOUND
;  D: c-addr u --
                        $DEFER  'INTERPRET-WORD-NOT-FOUND',$INTERPRET_WORD_NOT_FOUND,$PINTERPRET_WORD_NOT_FOUND

;  INTERPRET-WORD
;  ( C-ADDR -- )
                        $COLON  'INTERPRET-WORD',$INTERPRET_WORD

                        XT_$FIND
                        XT_$QDUP
                        CQBR    IW_NOT_FOUND
                          XT_$DO_DEFINED
                        CBR     IW_EXIT
IW_NOT_FOUND:
                          XT_$DUP
                          XT_$TOR
                          XT_$COUNT
                          XT_$INTERPRET_LITERAL
                          XT_$INVERT
                          CQBR    IW_EXIT_1
                            XT_$RFROM
                            XT_$COUNT
                            XT_$INTERPRET_WORD_NOT_FOUND
                          CBR     IW_EXIT
IW_EXIT_1:
                        XT_$RFROM
                        XT_$DROP
IW_EXIT:
                        XT_$EXIT

;  INTERPRET
                        $COLON  'INTERPRET',$INTERPRET

INT_LOOP:
                        XT_$BL
                        XT_$WORD                   ; c-addr
                        XT_$DUP                    ; c-addr c-addr
                        XT_$COUNT                  ; c-addr c-addr1 count
                        XT_$NIP                    ; c-addr count
                        CQBR    INT_EXIT                ; exit loop if parse area is exhausted
                          XT_$INTERPRET_WORD
                        CBR     INT_LOOP
INT_EXIT:
                        XT_$DROP
                        XT_$EXIT
