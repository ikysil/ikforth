;******************************************************************************
;
;  data.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Data space
;******************************************************************************

;  6.1.0150 ,
;  Reserve one cell of data space and store x in the cell
;  D: x --
                        $CODE   ',',$COMMA
                        POPDS   EAX
                        MOV     EBX,DWORD [VAR_DP + IMAGE_BASE]
                        MOV     DWORD [EBX],EAX
                        ADD     DWORD [VAR_DP + IMAGE_BASE],CELL_SIZE
                        $NEXT

;  COMPILE,
                        $COLON  'COMPILE,',$COMPILEC,VEF_COMPILE_ONLY
                        XT_$COMMA
                        XT_$EXIT

;  6.1.0710 ALLOT
;  Allocates n memory cells on the top of vocabulary
;  D: n --
                        $CODE   'ALLOT',$ALLOT

                        POPDS   EAX
                        ADD     DWORD [VAR_DP + IMAGE_BASE],EAX
                        $NEXT

;  6.1.0860 C,
;  Reserve one character of data space and store x in the character
;  D: x --
                        $CODE   'C,',$CCOMMA

                        POPDS   EAX
                        MOV     EBX,DWORD [VAR_DP + IMAGE_BASE]
                        MOV     BYTE [EBX],AL
                        INC     DWORD [VAR_DP + IMAGE_BASE]
                        $NEXT

;  6.1.1780 LITERAL
                        $COLON  'LITERAL',$LITERAL,VEF_IMMEDIATE_COMPILE_ONLY
                        CWLIT   $LIT
                        XT_$COMPILEC
                        XT_$COMMA
                        XT_$EXIT

;  6.1.1650 HERE
;  addr is the data-space pointer.
;  D: -- addr
                        $COLON  'HERE',$HERE
                        CFETCH  $DP
                        XT_$EXIT

