;******************************************************************************
;
;  rstack.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Return stack manipulation
;******************************************************************************

;  6.1.0580 >R
;  Move value from the data stack to return stack
;  D: a --
;  R:   -- a
                        $DEF    '>R',$TOR,,VEF_COMPILE_ONLY
                        POPDS   EAX
                        PUSHRS  EAX
                        $NEXT

;  6.1.2060 R>
;  Interpretation: Interpretation semantics for this word are undefined.
;  Execution: ( -- x ) ( R:  x -- )
;    Move x from the return stack to the data stack.
                        $DEF    'R>',$RFROM,,VEF_COMPILE_ONLY
                        POPRS   EAX
                        PUSHDS  EAX
                        $NEXT

;  6.1.2070 R@
;  Copy value from the return stack to data stack
;  R: a -- a
;  D:   -- a
                        $DEF    'R@',$RFETCH
                        FETCHRS EAX
                        PUSHDS  EAX
                        $NEXT

;  6.2.0340 2>R
;  D: a b --
;  R:     -- a b
                        $DEF    '2>R',$2TOR,,VEF_COMPILE_ONLY
                        POPDS   EBX
                        POPDS   EAX
                        PUSHRS  EAX
                        PUSHRS  EBX
                        $NEXT

;  6.2.0410 2R>
;  D:     -- a b
;  R: a b --
                        $DEF    '2R>',$2RFROM,,VEF_COMPILE_ONLY
                        POPRS   EBX
                        POPRS   EAX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  6.2.0415 2R@
;  D:     -- a b
;  R: a b -- a b
                        $DEF    '2R@',$2RFETCH
                        FETCHRS EBX,0
                        FETCHRS EAX,1
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  R-PICK
                        $DEF    'R-PICK',$R_PICK
                        POPDS   EBX
                        FETCHRS EAX,EBX
                        PUSHDS  EAX
                        $NEXT

;  RS-SIZE
                        $CONST  'RS-SIZE'
                        CC      RETURN_STACK_SIZE

;  RP0
                        $DEF    'RP0',$RP0
                        MOV     EAX,EDI
                        ADD     EAX,RSTACK_VAR
                        PUSHDS  EAX
                        $NEXT

;  RP@
                        $DEF    'RP@',$RPFETCH
                        PUSHDS  EBP
                        $NEXT

;  RP!
                        $DEF    'RP!',$RPSTORE,,VEF_COMPILE_ONLY
                        POPDS   EBP
                        $NEXT

