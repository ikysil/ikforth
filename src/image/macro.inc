;******************************************************************************
;
;  macro.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
;
;******************************************************************************

;******************************************************************************
;
;******************************************************************************
                        MACRO   $JMP {
                        MOV     EBX,DWORD [EAX]
                        JMP     EBX                     ; execute
                        }

;******************************************************************************
;  Because of usage of indirect threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Simply fetch a code pointer DWORD [ESI] and jump there.
;******************************************************************************
                        MACRO   $NEXT {
                        LODSD                           ; fetch address
                        $JMP
                        }

VOC_LINK                =       0                       ; link to previous word
;******************************************************************************
;  Vocabulary entry flags
;******************************************************************************
VEF_USUAL               EQU     00h
VEF_IMMEDIATE           EQU     01h                     ; IMMEDIATE entry
VEF_HIDDEN              EQU     02h                     ; hidden word
VEF_COMPILE_ONLY        EQU     04h                     ; compile only mode
VEF_IMMEDIATE_COMPILE_ONLY  EQU VEF_IMMEDIATE OR VEF_COMPILE_ONLY

;******************************************************************************
;  Macro $DEF defines a vocabulary entry.
;  Parameters:
;    NAME       the name of the entry to be created
;    CODE       label of the CFA
;    EXECUTOR   the executor of a word ( = [DWORD CODE] if ommited)
;    FLAGS      entry flags
;  Vocabulary entry layout
;  Offset Length // bytes
;  +0     1      FLAGS (VEF_XXX)
;  +1     1      name length (or 0)                       // NFA
;  +2     n      name (in OEM codepage)
;  +2+n   1      n + 2
;  +2+n+1 4      link to previous word or 0 if first word // LFA
;  +2+n+5 4      address of internal interpreter          // CFA
;  +2+n+9 x                                               // PFA
;******************************************************************************
                        MACRO   $DEF NAME,CODE,EXECUTOR,FLAGS {

                        LOCAL   __DEF,__PREVFLD,__LBLNAME,__CODE
__DEF:
LASTWORD                =       __DEF 
                        IF      ~ FLAGS eq
                          DB    FLAGS
                        ELSE
                          DB    VEF_USUAL
                        END IF
;; NFA
                        DB      __PREVFLD - $ - 1
                        IF      ~ NAME eq
                          DB      NAME
                        ELSE
                          DB      0
                        END IF
__PREVFLD:
                        DB      __PREVFLD - __DEF 
;; LFA
                        DD      VOC_LINK
VOC_LINK                =       __DEF + IMAGE_BASE

;; CFA
                        IF      ~ CODE eq
                        LABEL   CW_#CODE DWORD
                        END IF

                        IF      ~ EXECUTOR eq
                          DD      CW_#EXECUTOR# + IMAGE_BASE
                        ELSE
                          DD      __CODE   + IMAGE_BASE
                        END IF
__CODE:
;; PFA
                        }

;******************************************************************************
;  Use this macro to compile FORTH threaded definitions
;******************************************************************************
                        MACRO   CW NAME {
                        DD      CW_#NAME + IMAGE_BASE
                        }

                        MACRO   CWLIT VALUE {
                        CW      $LIT
                        CW      VALUE
                        }

;******************************************************************************
;  Use this macro to compile constants
;******************************************************************************
                        MACRO   CC VALUE {
                        DD      VALUE
                        }

                        MACRO   CCLIT VALUE {
                        CW      $LIT
                        DD      VALUE
                        }

;******************************************************************************
;  Compile @
;******************************************************************************
                        MACRO   CFETCH ADDR {
                        CW      ADDR
                        CW      $FETCH
                        }

;******************************************************************************
;  Compile !
;******************************************************************************
                        MACRO   CSTORE ADDR {
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
;  Compile EXIT
;******************************************************************************
                        MACRO   CEXIT {
                        CW      $EXIT
                        }

;******************************************************************************
;  Push a value to return stack
;******************************************************************************
                        MACRO   PUSHRS SRC {
                        SUB     EBP,CELL_SIZE
                        MOV     DWORD [EBP],SRC
                        }

;******************************************************************************
;  Pop a value from return stack
;******************************************************************************
                        MACRO   POPRS DST {
                        MOV     DST,DWORD [EBP]
                        ADD     EBP,CELL_SIZE
                        }

;******************************************************************************
;  Fetch a value from the return stack
;******************************************************************************
                        MACRO   FETCHRS DST,NUM {
                        IF      ~ NUM eq
                          MOV     DST,DWORD [EBP + NUM * CELL_SIZE]
                        ELSE
                          MOV     DST,DWORD [EBP]
                        END IF
                        }

;******************************************************************************
;  Push a value to data stack
;******************************************************************************
                        MACRO   PUSHDS SRC {
                        PUSH    SRC
                        }

;******************************************************************************
;  Pop a value from data stack
;******************************************************************************
                        MACRO   POPDS DST {
                        POP     DST
                        }

;******************************************************************************
;  Fetch a value from the data stack
;******************************************************************************
                        MACRO   FETCHDS DST,NUM {
                        IF      ~ NUM eq
                          MOV     DST,DWORD [ESP + NUM * CELL_SIZE]
                        ELSE
                          MOV     DST,DWORD [ESP]
                        END IF
                        }

;******************************************************************************
;
;******************************************************************************
                        MACRO   $CONST NAME,CODE {
                        $DEF    NAME,CODE,$DOCONST
                        }

                        MACRO   $VAR NAME,CODE {
                        $DEF    NAME,CODE,$DOVAR
                        }

                        MACRO   $USER NAME,CODE {
                        $DEF    NAME,CODE,$DOUSER
                        }

                        MACRO   $COLON NAME,CODE,FLAGS {
                        $DEF    NAME,CODE,$ENTER,FLAGS
                        }

                        MACRO   $NONAME CODE,FLAGS {
                        $DEF    <>,CODE,$ENTER,FLAGS
                        }

                        MACRO   $DEFER NAME,CODE,FLAGS {
                        $DEF    NAME,CODE,$DODEFER,FLAGS
                        }

                        MACRO   $CODE NAME,CODE,FLAGS {
                        $DEF    NAME,CODE,<>,FLAGS
                        }

;******************************************************************************
;
;******************************************************************************
                        MACRO   $WRITE TEXT {
                        
                        LOCAL   __S_END
                        CW      $PTYPE
                        DB      __S_END - $ - 1
                        DB      TEXT
__S_END:
                        }

;******************************************************************************
;
;******************************************************************************
                        MACRO   $CR {
                        CCLIT   13
                        CW      $EMIT
                        CCLIT   10
                        CW      $EMIT
                        }

