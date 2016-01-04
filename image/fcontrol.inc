;******************************************************************************
;
;  fcontrol.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Flow control words
;******************************************************************************

;  6.1.1760 LEAVE
                        $DEF    'LEAVE',$LEAVE,,VEF_COMPILE_ONLY
                        POPRS   EAX
                        POPRS   EAX
                        POPRS   ESI
                        $NEXT

;  6.1.1680 I
;  D: ( -- loop-index )
                        $DEF    'I',$I,,VEF_COMPILE_ONLY
                        FETCHRS EAX
                        PUSHDS  EAX
                        $NEXT

;  6.1.1730 J
;  D: ( -- outer-loop-index )
                        $DEF    'J',$J,,VEF_COMPILE_ONLY
                        FETCHRS EAX,3
                        PUSHDS  EAX
                        $NEXT                   

;  I'
;  D: ( -- loop-limit )
                        $DEF    'I''',$ITICK,,VEF_COMPILE_ONLY
                        FETCHRS EAX,1
                        PUSHDS  EAX
                        $NEXT

;  6.1.1370 EXECUTE
                        $DEF    'EXECUTE',$EXECUTE
                        POPDS   EAX                     ; pop new IP from data stack
                        $JMP

