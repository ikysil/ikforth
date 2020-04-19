;******************************************************************************
;
;  purpose.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Source documentation words.
;******************************************************************************

;   (PURPOSE) ( -- )
;   Parse till the end of the string and output to the terminal
                $COLON      '(PURPOSE)',$PPURPOSEP
                CW          $ZERO, $PARSE
                $CR
                CW          $TYPE,$BL,$EMIT

                $END_COLON

;   PURPOSE: ( -- ) IMMEDIATE
;   Parse till the end of the string and output to the terminal.
                $DEFER      'PURPOSE:',,$PPURPOSEP,VEF_IMMEDIATE

;   COPYRIGHT: ( -- ) IMMEDIATE
;   Parse till the end of the string and output to the terminal.
                $DEFER      'COPYRIGHT:',,$PBSLASH,VEF_IMMEDIATE

;   LICENSE: ( -- ) IMMEDIATE
;   Parse till the end of the string and output to the terminal.
                $DEFER      'LICENSE:',,$PBSLASH,VEF_IMMEDIATE
