;******************************************************************************
;
;  wordlist-def.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Define Forth wordlists in Assembler
;******************************************************************************

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
;  Macro $DEF defines a wordlist entry.
;  Parameters:
;    NAME       the name of the entry to be created
;    CFA_NAME   label of the CFA
;    CODE       the code address of a word ( = [DWORD CFA_NAME] if ommited)
;    FLAGS      entry flags
;  Wordlist entry layout
;  Offset   Length // bytes
;  +0       1      FLAGS (VEF_XXX)
;  +1       1      name length (or 0)                       // NFA
;  +2       n      name (in OEM codepage)
;  +2+n     1      n + 2
;  +5+n     4      link to previous word or 0 if first word // LFA
;  +7+n     m      address of internal interpreter          // CFA
;                  code address in ITC
;                  machine code JMP to code address in DTC
;  +7+n+m   x                                               // PFA
;******************************************************************************
                        MACRO   $DEF NAME,CFA_NAME,CODE,FLAGS {

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
                        IF      CODE eq
                          $CFA    __CODE,CFA_NAME
                        ELSE
                          $CFA    CFA_#CODE,CFA_NAME
                        END IF
__CODE:
;; PFA
                        }

;******************************************************************************
;
;******************************************************************************
                        MACRO   $CONST NAME,CFA_NAME {
                        $DEF    NAME,CFA_NAME,$DOCONST
                        }

                        MACRO   $VAR NAME,CFA_NAME {
                        $DEF    NAME,CFA_NAME,$DOVAR
                        }

                        MACRO   $USER NAME,CFA_NAME {
                        $DEF    NAME,CFA_NAME,$DOUSER
                        }

                        MACRO   $COLON NAME,CFA_NAME,FLAGS {
                        $DEF    NAME,CFA_NAME,$ENTER,FLAGS
                        }

                        MACRO   $NONAME CFA_NAME,FLAGS {
                        $DEF    <>,CFA_NAME,$ENTER,FLAGS
                        }

                        MACRO   $DEFER NAME,CFA_NAME,FLAGS {
                        $DEF    NAME,CFA_NAME,$DODEFER,FLAGS
                        }

                        MACRO   $CODE NAME,CFA_NAME,FLAGS {
                        $DEF    NAME,CFA_NAME,<>,FLAGS
                        }
