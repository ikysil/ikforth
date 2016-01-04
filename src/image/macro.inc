;******************************************************************************
;
;  macro.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************

F_TRUE                  EQU     0FFFFFFFFh
F_FALSE                 EQU     0

CELL_SIZE               EQU     4

;******************************************************************************
;
;******************************************************************************
                   $JMP MACRO   
                        MOV     EBX,DWORD PTR [EAX]
                        JMP     EBX                     ; execute
                        ENDM

;******************************************************************************
;  Because of usage of indirect threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Simply fetch a code pointer DWORD PTR [ESI] and jump there.
;******************************************************************************
                  $NEXT MACRO
                        LODSD                           ; fetch address
                        $JMP
                        ENDM

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
;    EXECUTOR   the executor of a word ( = [DWORD PTR CODE] if ommited)
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
                   $DEF MACRO   NAME,CODE,EXECUTOR,FLAGS
                        LOCAL   __DEF,__PREVFLD,__LBLNAME,__CODE
__DEF:
LASTWORD                =       __DEF 
                        IFNB    <FLAGS>
                          DB    FLAGS
                        ELSE
                          DB    VEF_USUAL
                        ENDIF
;; NFA
                        DB      __PREVFLD - $ - 1
                        DB      NAME
__PREVFLD:
                        DB      __PREVFLD - __DEF 
;; LFA
                        DD      VOC_LINK
VOC_LINK                =       __DEF      + IMAGE_BASE

;; CFA
                        IFNB    <CODE>
                  &CODE LABEL FAR
                        ENDIF

                        IFNB    <EXECUTOR>
                          DD      EXECUTOR + IMAGE_BASE
                        ELSE
                          DD      __CODE   + IMAGE_BASE
                        ENDIF
__CODE:
;; PFA
                        ENDM    $DEF

;******************************************************************************
;  Use this macro to compile FORTH threaded definitions
;******************************************************************************
                     CW MACRO   NAME
                        DD      NAME + IMAGE_BASE
                        ENDM

                  CWLIT MACRO   VALUE
                        CW      $LIT
                        CW      VALUE
                        ENDM

;******************************************************************************
;  Use this macro to compile constants
;******************************************************************************
                     CC MACRO   VALUE
                        DD      VALUE
                        ENDM

                  CCLIT MACRO   VALUE
                        CW      $LIT
                        DD      VALUE
                        ENDM

;******************************************************************************
;  Compile @
;******************************************************************************
                 CFETCH MACRO   ADDR
                        CW      ADDR
                        CW      $FETCH
                        ENDM

;******************************************************************************
;  Compile !
;******************************************************************************
                 CSTORE MACRO   ADDR
                        CW      ADDR
                        CW      $STORE
                        ENDM

;******************************************************************************
;  Compile a conditional branch ?BRANCH
;******************************************************************************
                   CQBR MACRO   VALUE
                        CW      $QBRANCH
                        CW      VALUE
                        ENDM

;******************************************************************************
;  Compile an unconditional branch BRANCH
;******************************************************************************
                    CBR MACRO   VALUE
                        CW      $BRANCH
                        CW      VALUE
                        ENDM

;******************************************************************************
;  Compile THROW
;******************************************************************************
                 CTHROW MACRO   VALUE
                        CCLIT   VALUE
                        CW      $THROW
                        ENDM

;******************************************************************************
;  Compile EXIT
;******************************************************************************
                  CEXIT MACRO   
                        CW      $EXIT
                        ENDM

;******************************************************************************
;  Push a value to return stack
;******************************************************************************
                 PUSHRS MACRO   SRC
                        SUB     EBP,CELL_SIZE
                        MOV     DWORD PTR [EBP],&SRC
                        ENDM

;******************************************************************************
;  Pop a value from return stack
;******************************************************************************
                  POPRS MACRO   DST
                        MOV     &DST,DWORD PTR [EBP]
                        ADD     EBP,CELL_SIZE
                        ENDM

;******************************************************************************
;  Fetch a value from the return stack
;******************************************************************************
                FETCHRS MACRO   DST,NUM
                        IFNB    <NUM>
                          MOV     &DST,DWORD PTR [EBP + &NUM * CELL_SIZE]
                        ELSE
                          MOV     &DST,DWORD PTR [EBP]
                        ENDIF
                        ENDM

;******************************************************************************
;  Push a value to data stack
;******************************************************************************
                 PUSHDS MACRO   SRC
                        PUSH    &SRC
                        ENDM

;******************************************************************************
;  Pop a value from data stack
;******************************************************************************
                  POPDS MACRO   DST
                        POP     &DST
                        ENDM

;******************************************************************************
;  Fetch a value from the data stack
;******************************************************************************
                FETCHDS MACRO   DST,NUM
                        IFNB    <NUM>
                          MOV     &DST,DWORD PTR [ESP + &NUM * CELL_SIZE]
                        ELSE
                          MOV     &DST,DWORD PTR [ESP]
                        ENDIF
                        ENDM

;******************************************************************************
;
;******************************************************************************
                 $CONST MACRO   NAME,CODE
                        $DEF    &NAME,&CODE,$DOCONST
                        ENDM

                   $VAR MACRO   NAME,CODE
                        $DEF    &NAME,&CODE,$DOVAR
                        ENDM

                  $USER MACRO   NAME,CODE
                        $DEF    &NAME,&CODE,$DOUSER
                        ENDM

                 $COLON MACRO   NAME,CODE,FLAGS
                        $DEF    &NAME,&CODE,$ENTER,&FLAGS
                        ENDM

                 $DEFER MACRO   NAME,CODE,FLAGS
                        $DEF    &NAME,&CODE,$DODEFER,&FLAGS
                        ENDM

                  $CODE MACRO   NAME,CODE,FLAGS
                        $DEF    &NAME,&CODE,"",&FLAGS
                        ENDM

;******************************************************************************
;
;******************************************************************************
                 $WRITE MACRO   TEXT
                        LOCAL   __S_END
                        CW      $PTYPE
                        DB      __S_END - $ - 1
                        DB      &TEXT
__S_END:
                        ENDM

;******************************************************************************
;
;******************************************************************************
                    $CR MACRO   
                        CCLIT   13
                        CW      $EMIT
                        CCLIT   10
                        CW      $EMIT
                        ENDM

