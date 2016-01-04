;******************************************************************************
;
;  double.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Double number words
;******************************************************************************

;  8.6.1.0390 2LITERAL
                        $COLON  '2LITERAL',$2LITERAL,<VEF_IMMEDIATE OR VEF_COMPILE_ONLY>
                        CW      $LIT
                        CW      $2LIT
                        CW      $COMPILEC
                        CW      $SWAP
                        CW      $COMMA
                        CW      $COMMA
                        CW      $EXIT

;  8.6.1.1040 D+
;  ( d1|ud1 d2|ud2 -- d3|ud3 )
;  Add d2|ud2 to d1|ud1, giving the sum d3|ud3. 
                        $DEF    'D+',$DADD
                        POPDS   ECX
                        POPDS   EBX
                        POPDS   EDX
                        POPDS   EAX
                        ADD     EAX,EBX
                        ADC     EDX,ECX
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1050 D-
;  ( d1|ud1 d2|ud2 -- d3|ud3 )
;  Subtract d2|ud2 from d1|ud1, giving the difference d3|ud3. 
                        $DEF    'D-',$DSUB
                        POPDS   ECX
                        POPDS   EBX
                        POPDS   EDX
                        POPDS   EAX
                        SUB     EAX,EBX
                        SBB     EDX,ECX
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1090 D2*
;  ( xd1 -- xd2 )
;  xd2 is the result of shifting xd1 one bit toward the most-significant bit,
;  filling the vacated least-significant bit with zero. 
                        $DEF    'D2*',$D2MUL
                        POPDS   EDX
                        POPDS   EAX
                        SAL     EAX,1
                        RCL     EDX,1
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1100 D2/
;  ( xd1 -- xd2 )
;  xd2 is the result of shifting xd1 one bit toward the least-significant bit,
;  leaving the most-significant bit unchanged. 
                        $DEF    'D2/',$D2DIV
                        POPDS   EDX
                        POPDS   EAX
                        SAR     EDX,1
                        RCR     EAX,1
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1160 DABS
;  ( d -- ud )
;  ud is the absolute value of d. 
                        $DEF    'DABS',$DABS
                        POPDS   EDX
                        POPDS   EAX
                        OR      EDX,EDX
                        JNS     SHORT DABS_OK
                        SUB     EAX,1
                        SBB     EDX,0
                        NOT     EAX
                        NOT     EDX
DABS_OK:
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1210 DMAX
;  ( d1 d2 -- d3 )
;  d3 is the greater of d1 and d2. 
                        $DEF    'DMAX',$DMAX
                        POPDS   EDX
                        POPDS   EAX
                        POPDS   ECX
                        POPDS   EBX
                        CMP     EDX,ECX
                        JG      SHORT DMAX_OK
                        CMP     EAX,EBX
                        JG      SHORT DMAX_OK
                        MOV     EAX,EBX
                        MOV     EDX,ECX
DMAX_OK:
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1220 DMIN
;  ( d1 d2 -- d3 )
;  d3 is the greater of d1 and d2. 
                        $DEF    'DMIN',$DMIN
                        POPDS   EDX
                        POPDS   EAX
                        POPDS   ECX
                        POPDS   EBX
                        CMP     EDX,ECX
                        JL      SHORT DMIN_OK
                        CMP     EAX,EBX
                        JL      SHORT DMIN_OK
                        MOV     EAX,EBX
                        MOV     EDX,ECX
DMIN_OK:
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1230 DNEGATE 
;  ( d1 -- d2 )
;  d2 is the negation of d1.
                        $DEF    'DNEGATE',$DNEGATE
                        POPDS   EDX
                        POPDS   EAX
                        SUB     EAX,1
                        SBB     EDX,0
                        NOT     EAX
                        NOT     EDX
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  8.6.1.1830 M+
;  ( d1|ud1 n -- d2|ud2 )
;  Add n to d1|ud1, giving the sum d2|ud2. 
                        $DEF    'M+',$MADD
                        POPDS   EBX
                        POPDS   EDX
                        POPDS   EAX
                        ADD     EAX,EBX
                        ADC     EDX,0
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

