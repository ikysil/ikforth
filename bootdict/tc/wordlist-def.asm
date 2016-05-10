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
WL_LINK                 =       0                       ; link to the previous wordlist
;******************************************************************************
;  Vocabulary entry flags
;******************************************************************************
VEF_USUAL               EQU     00h
VEF_IMMEDIATE           EQU     01h  ; IMMEDIATE entry
VEF_HIDDEN              EQU     02h  ; hidden word
VEF_COMPILE_ONLY        EQU     04h  ; compile only mode
VEF_LOCATE              EQU     08h  ; LOCATE information is present
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
                MACRO       $REPORT_UNUSED NAME {
                IF          ~ NAME EQ
                IF          ~ USED NAME
                DISPLAY     `NAME # " not used.",13,10
                END IF
                END IF
                }

                MACRO       $DEFLABEL PFX,CFA_NAME,REPORT_UNUSED {
                IF          ~ CFA_NAME EQ
                LABEL       PFX#_#CFA_NAME DWORD
                IF          REPORT_UNUSED EQ TRUE
                $REPORT_UNUSED PFX#_#CFA_NAME
                END IF
                END IF
                }

                MACRO       $DEF NAME,CFA_NAME,CODE,FLAGS {

                LOCAL       __DEF,__PREVFLD,__LBLNAME,__CODE
__DEF:
LASTWORD = __DEF
                $DEFLABEL   HEAD,CFA_NAME
                IF          ~ FLAGS eq
                DB          FLAGS
                ELSE
                DB          VEF_USUAL
                END IF
;; NFA
                $DEFLABEL   NFA,CFA_NAME
                DB          __PREVFLD - $ - 1
                IF          ~ NAME eq
                DB          NAME
                END IF
__PREVFLD:
                DB          __PREVFLD - __DEF
;; LFA
                $DEFLABEL   LFA,CFA_NAME
                DD          VOC_LINK
VOC_LINK = __DEF + IMAGE_BASE

;; CFA
                IF          CODE eq
                $CFA        __CODE,CFA_NAME
                ELSE
                $CFA        CFA_#CODE,CFA_NAME
                END IF
__CODE:
                $DEFLABEL   PFA,CFA_NAME
;; PFA
                }

                POSTPONE {
                LATEST_WL   = WL_LINK
                LABEL       HERE
                }

;******************************************************************************
;
;******************************************************************************
                MACRO       $CONST NAME,CFA_NAME,VALUE {
                $DEF        NAME,CFA_NAME,$DOCONST
                CC          VALUE
                }

                MACRO       $VAR NAME,CFA_NAME,VALUE {
                $DEF        NAME,CFA_NAME,$DOVAR
                CC          VALUE
                }

                MACRO       $CREATE NAME,CFA_NAME {
                $DEF        NAME,CFA_NAME,$DOCREATE
                }

                MACRO       $USER NAME,CFA_NAME,VALUE {
                $DEF        NAME,CFA_NAME,$DOUSER
                CC          VALUE
                }

                MACRO       $COLON NAME,CFA_NAME,FLAGS {
                $DEF        NAME,CFA_NAME,$ENTER,FLAGS
                }

                MACRO       $NONAME CFA_NAME,FLAGS {
                $DEF        <>,CFA_NAME,$ENTER,FLAGS
                }

                MACRO       $END_COLON {
                CW          $END_COLON
                }

                MACRO       $DEFER NAME,CFA_NAME,VALUE,FLAGS {
                $DEF        NAME,CFA_NAME,$DODEFER,FLAGS
                CW          VALUE
                }

                MACRO       $CODE NAME,CFA_NAME,FLAGS {
                $DEF        NAME,CFA_NAME,<>,FLAGS
                }

                MACRO       $END_CODE {
                }

                MACRO       $VALUE NAME,CFA_NAME,VALUE,VT,FLAGS {
                $DEF        NAME,CFA_NAME,$DOVALUE,FLAGS
                IF          VT eq
                CC          0
                ELSE
                CW          VT
                END IF
                CC          VALUE
                }

                MACRO       $RTABLE NAME,CFA_NAME,INT_XT,COMP_XT,POST_XT,FLAGS {
                $DEF        NAME,CFA_NAME,$DOCREATE,FLAGS
                CW          INT_XT,COMP_XT,POST_XT
                }

                MACRO       $DEFINITIONS CFA_NAME {
                VOC_LINK    EQU VOC_LINK_#CFA_NAME
                }

                MACRO       $WORDLIST NAME,CFA_NAME,LINK {
                VOC_LINK_#CFA_NAME = 0
                IF          LINK EQ
                RESTORE     VOC_LINK
                VOC_LINK    = 0
                END IF
                $CREATE     NAME,CFA_NAME
                DD          LATEST_WORD_#CFA_NAME   ; last word in a list
                CC          0                       ; wordlist name
                CC          WL_LINK                 ; wordlist link
                $DEFLABEL   VT,CFA_NAME
                PW          $WORDLIST_VT            ; wordlist VT

                WL_LINK     = PFA_#CFA_NAME + IMAGE_BASE
                VOC_LINK_#CFA_NAME = VOC_LINK

                POSTPONE \{
                LATEST_WORD_#CFA_NAME = VOC_LINK_#CFA_NAME
                \}

                }

