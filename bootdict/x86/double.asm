;******************************************************************************
;
;  double.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Double number words
;******************************************************************************

;  8.6.1.1040 D+
;  ( d1|ud1 d2|ud2 -- d3|ud3 )
;  Add d2|ud2 to d1|ud1, giving the sum d3|ud3.
                $CODE       'D+',$D_PLUS,VEF_USUAL
                POPDS       ECX
                POPDS       EBX
                POPDS       EDX
                POPDS       EAX
                ADD         EAX,EBX
                ADC         EDX,ECX
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT

;  8.6.1.1230 DNEGATE
;  ( d1 -- d2 )
;  d2 is the negation of d1.
                $CODE       'DNEGATE',$D_NEGATE,VEF_USUAL
                POPDS       EDX
                POPDS       EAX
                SUB         EAX,1
                SBB         EDX,0
                NOT         EAX
                NOT         EDX
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT
