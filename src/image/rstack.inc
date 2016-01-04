;******************************************************************************
;
;  rstack.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Return stack manipulation
;******************************************************************************

;  6.1.0580 >R
;  Move value from the data stack to return stack
;  D: a --
;  R:   -- a
                        $CODE   '>R',$TOR,VEF_COMPILE_ONLY
                        POPDS   EAX
                        PUSHRS  EAX
                        $NEXT

;  6.1.2060 R>
;  Interpretation: Interpretation semantics for this word are undefined.
;  Execution: ( -- x ) ( R:  x -- )
;    Move x from the return stack to the data stack.
                        $CODE   'R>',$RFROM,VEF_COMPILE_ONLY
                        POPRS   EAX
                        PUSHDS  EAX
                        $NEXT

;  6.1.2070 R@
;  Copy value from the return stack to data stack
;  R: a -- a
;  D:   -- a
                        $CODE   'R@',$RFETCH
                        FETCHRS EAX
                        PUSHDS  EAX
                        $NEXT

;  6.2.0340 2>R
;  D: a b --
;  R:     -- a b
                        $CODE   '2>R',$2TOR,VEF_COMPILE_ONLY
                        POPDS   EBX
                        POPDS   EAX
                        PUSHRS  EAX
                        PUSHRS  EBX
                        $NEXT

;  6.2.0410 2R>
;  D:     -- a b
;  R: a b --
                        $CODE   '2R>',$2RFROM,VEF_COMPILE_ONLY
                        POPRS   EBX
                        POPRS   EAX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  6.2.0415 2R@
;  D:     -- a b
;  R: a b -- a b
                        $CODE   '2R@',$2RFETCH
                        FETCHRS EBX,0
                        FETCHRS EAX,1
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  R-PICK
                        $CODE   'R-PICK',$R_PICK
                        POPDS   EBX
                        FETCHRS EAX,EBX
                        PUSHDS  EAX
                        $NEXT

;  RS-SIZE
                        $CONST  'RS-SIZE'
                        CC      RETURN_STACK_SIZE

;  RP0
                        $CODE   'RP0',$RP0
                        LEA     EAX,[DWORD PTR EDI + RSTACK_VAR]
                        PUSHDS  EAX
                        $NEXT

;  RP@
                        $CODE   'RP@',$RPFETCH
                        PUSHDS  EBP
                        $NEXT

;  RP!
                        $CODE   'RP!',$RPSTORE,VEF_COMPILE_ONLY
                        POPDS   EBP
                        $NEXT

;  +R
;  D: x - x
;  R:   - x
                        $CODE   '+R',$PLUS_R,VEF_COMPILE_ONLY
                        FETCHDS EAX
                        PUSHRS  EAX
                        $NEXT

;  2+R
;  D: x1 x2 - x1 x2
;  R:       - x1 x2
                        $CODE   '2+R',$2PLUS_R,VEF_COMPILE_ONLY
                        FETCHDS EAX
                        FETCHDS EBX,1
                        PUSHRS  EBX
                        PUSHRS  EAX
                        $NEXT

;  N>R
;  D: xn .. x1 n -
;  R:            - x1 .. xn n
                        $CODE   'N>R',$N_TO_R,VEF_COMPILE_ONLY
                        POPDS   ECX
                        MOV     EAX,ECX
                        OR      ECX,ECX
@@N_TO_R_LOOP:
                        JECXZ   @@N_TO_R_EXIT
                        POPDS   EBX
                        PUSHRS  EBX
                        DEC     ECX
                        JMP     @@N_TO_R_LOOP
@@N_TO_R_EXIT:
                        PUSHRS  EAX
                        $NEXT

;  NR>
;  D:            - xn .. x1 n
;  R: x1 .. xn n -
                        $CODE   'NR>',$N_R_FROM,VEF_COMPILE_ONLY
                        POPRS   ECX
                        MOV     EAX,ECX
                        OR      ECX,ECX
@@N_R_FROM_LOOP:
                        JECXZ   @@N_R_FROM_EXIT
                        POPRS   EBX
                        PUSHDS  EBX
                        DEC     ECX
                        JMP     @@N_R_FROM_LOOP
@@N_R_FROM_EXIT:
                        PUSHDS  EAX
                        $NEXT

