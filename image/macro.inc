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

MAX_NAME_LENGTH         EQU     32

;******************************************************************************
;
;******************************************************************************
                        MACRO   $JMP
                        MOV     EBX,[DWORD PTR EAX]
                        JMP     EBX                     ; execute
                        ENDM    $JMP

;******************************************************************************
;  Because of usage of indirect threaded code the $NEXT macro is used at the end
;  of each definition to perform execution of next word.
;  Simply fetch a code pointer [DWORD PTR ESI] and jump there.
;******************************************************************************
                        MACRO   $NEXT                   ;
                        LODSD                           ; fetch address
                        $JMP
                        ENDM    $NEXT

VOC_LINK                =       0                       ; link to previous word
;******************************************************************************
;  Vocabulary entry flags
;******************************************************************************
VEF_USUAL               EQU     00h
VEF_IMMEDIATE           EQU     01h                     ; IMMEDIATE entry
VEF_HIDDEN              EQU     02h                     ; hidden word
VEF_COMPILE_ONLY        EQU     04h                     ; compile only mode

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
                        MACRO   $DEF NAME,CODE,EXECUTOR,FLAGS
                        LOCAL   $$DEF,$$PREVFLD,$$LBLNAME,$$CODE
$$DEF:
LASTWORD                =       $$DEF 
                        IFNB    <FLAGS>
                          DB    FLAGS
                        ELSE
                          DB    VEF_USUAL
                        ENDIF
;; NFA
                        DB      $$PREVFLD - $ - 1
                        DB      NAME
$$PREVFLD:
                        DB      $$PREVFLD - $$DEF 
;; LFA
                        DD      VOC_LINK
VOC_LINK                =       $$DEF + DESIRED_BASE_EQU

;; CFA
                        IFNB    <CODE>
                          LABEL   &CODE FAR
                        ENDIF
                        IFNB    <EXECUTOR>
                          DD      EXECUTOR + DESIRED_BASE_EQU
                        ELSE
                          DD      $$CODE + DESIRED_BASE_EQU
                        ENDIF
$$CODE:
;; PFA
                        ENDM    $DEF

;******************************************************************************
;  Use this macro to compile FORTH threaded definitions
;******************************************************************************
                        MACRO   CW NAME
                        DD      NAME + DESIRED_BASE_EQU
                        ENDM    CW

                        MACRO   CWLIT VALUE
                        CW      $LIT
                        CW      VALUE
                        ENDM    CWLIT

;******************************************************************************
;  Use this macro to compile constants
;******************************************************************************
                        MACRO   CC VALUE
                        DD      VALUE
                        ENDM    CC

                        MACRO   CCLIT VALUE
                        CW      $LIT
                        CC      VALUE
                        ENDM    CCLIT

;******************************************************************************
;  Compile @
;******************************************************************************
                        MACRO   CFETCH ADDR
                        CW      ADDR
                        CW      $FETCH
                        ENDM    CFETCH

;******************************************************************************
;  Compile !
;******************************************************************************
                        MACRO   CSTORE ADDR
                        CW      ADDR
                        CW      $STORE
                        ENDM    CSTORE

;******************************************************************************
;  Compile a conditional branch ?BRANCH
;******************************************************************************
                        MACRO   CQBR VALUE
                        CW      $QBRANCH
                        CW      VALUE
                        ENDM    CQBR

;******************************************************************************
;  Compile an unconditional branch BRANCH
;******************************************************************************
                        MACRO   CBR VALUE
                        CW      $BRANCH
                        CW      VALUE
                        ENDM    CBR

;******************************************************************************
;  Compile THROW
;******************************************************************************
                        MACRO   CTHROW VALUE
                        CCLIT   VALUE
                        CW      $THROW
                        ENDM    CTHROW

;******************************************************************************
;  Compile EXIT
;******************************************************************************
                        MACRO   CEXIT
                        CW      $EXIT
                        ENDM    CEXIT

;******************************************************************************
;  Push a value to return stack
;******************************************************************************
                        MACRO   PUSHRS SRC
                        SUB     EBP,CELL_SIZE
                        MOV     [DWORD PTR EBP],SRC
                        ENDM    PUSHRS

;******************************************************************************
;  Pop a value from return stack
;******************************************************************************
                        MACRO   POPRS DST
                        MOV     DST,[DWORD PTR EBP]
                        ADD     EBP,CELL_SIZE
                        ENDM    POPRS

;******************************************************************************
;  Fetch a value from the return stack
;******************************************************************************
                        MACRO   FETCHRS DST,NUM
                        IFNB     <NUM>
                          MOV     DST,[DWORD PTR EBP + &NUM * CELL_SIZE]
                        ELSE
                          MOV     DST,[DWORD PTR EBP]
                        ENDIF
                        ENDM    FETCHRS

;******************************************************************************
;  Push a value to data stack
;******************************************************************************
                        MACRO   PUSHDS SRC
                        PUSH    SRC
                        ENDM    PUSHDS

;******************************************************************************
;  Pop a value from data stack
;******************************************************************************
                        MACRO   POPDS DST
                        POP     DST
                        ENDM    POPDS

;******************************************************************************
;  Fetch a value from the data stack
;******************************************************************************
                        MACRO   FETCHDS DST,NUM
                        IFNB     <NUM>
                          MOV     DST,[DWORD PTR ESP + &NUM * CELL_SIZE]
                        ELSE
                          MOV     DST,[DWORD PTR ESP]
                        ENDIF
                        ENDM    FETCHDS

;******************************************************************************
;
;******************************************************************************
                        MACRO   $CONST NAME,CODE
                        $DEF    NAME,CODE,$DOCONST
                        ENDM    $CONST

                        MACRO   $VAR NAME,CODE
                        $DEF    NAME,CODE,$DOVAR
                        ENDM    $VAR

                        MACRO   $USER NAME,CODE
                        $DEF    NAME,CODE,$DOUSER
                        ENDM    $USER

                        MACRO   $COLON NAME,CODE,FLAGS
                        $DEF    NAME,CODE,$ENTER,FLAGS
                        ENDM    $COLON

                        MACRO   $DEFER NAME,CODE,FLAGS
                        $DEF    NAME,CODE,$DODEFER,FLAGS
                        ENDM    $DEFER

;******************************************************************************
;
;******************************************************************************
                        MACRO   $WRITE TEXT
                        LOCAL   @@S_END
                        CW      $PTYPE
                        DB      @@S_END - $ - 1,'&TEXT'
@@S_END:
                        ENDM    $WRITE

;******************************************************************************
;
;******************************************************************************
                        MACRO   $CR
                        CW      $LIT
                        CC      13
                        CW      $EMIT
                        CW      $LIT
                        CC      10
                        CW      $EMIT
                        ENDM    $CR
