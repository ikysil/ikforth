;******************************************************************************
;
;  compare.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Compare
;******************************************************************************

;  6.2.1485 FALSE
;  Return a false flag.
;  D: -- false
                $CODE       'FALSE',$FALSE
                PUSHDS      F_FALSE
                $NEXT

;  6.2.2298 TRUE
;  Return a true flag, a single-cell value with all bits set.
;  D: -- true
                $CODE       'TRUE',$TRUE
                PUSHDS      F_TRUE
                $NEXT

                MACRO       COMP_OP COND {
                POPDS       EBX
                POPDS       EAX
                CMP         EAX,EBX
                MOV         EAX,F_FALSE
                MOV         EBX,F_TRUE
                CMOV#COND   EAX,EBX
                PUSHDS      EAX
                }

                MACRO       COMPZ_OP COND {
                POPDS       EAX
                OR          EAX,EAX
                MOV         EAX,F_FALSE
                MOV         EBX,F_TRUE
                CMOV#COND   EAX,EBX
                PUSHDS      EAX
                }

;  <
                $CODE       '<',$LESS_THAN
                COMP_OP     L
                $NEXT

;  >
                $CODE       '>',$GREATER_THAN
                COMP_OP     G
                $NEXT

;  6.1.0530 =
;  D: a b -- flag ( a = b )
                $CODE       '=',$EQUALS
                COMP_OP     Z
                $NEXT

;  6.2.0500 <>
;  Flag is true if and only if x1 is not bit-for-bit the same as x2.
;  D: x1 x2 -- flag
                $CODE       '<>',$NOT_EQUALS
                COMP_OP     NZ
                $NEXT

;  6.1.0250 0<
;  D: a -- flag ( a < 0 )
                $CODE       '0<',$ZERO_LESS,VEF_USUAL
                COMPZ_OP    L
                $NEXT

;  6.1.0270 0=
;  D: a -- flag ( a = 0 )
                $CODE       '0=',$ZERO_EQUALS,VEF_USUAL
                COMPZ_OP    Z
                $NEXT

;  6.2.0260 0<>
;  Flag is true if and only if x is not equal to zero.
;  D: x -- flag
                $CODE       '0<>',$ZERO_NOT_EQUALS,VEF_USUAL
                COMPZ_OP    NZ
                $NEXT

;  6.2.0280 0>
;  Flag is true if and only if n is greater than zero.
;  D: n -- flag
                $CODE       '0>',$ZEROGR,VEF_USUAL
                COMPZ_OP    G
                $NEXT

;******************************************************************************
;  Unsigned compare
;******************************************************************************

;  6.1.2340 U<
;  Flag is true if and only if u1 is less than u2.
;  D: u1 u2 -- flag ( u1 < u2 )
                $CODE       'U<',$ULE,VEF_USUAL
                COMP_OP     B
                $NEXT

;  6.2.2350 U>
;  D: u1 u2 -- flag
;  flag is true if and only if u1 is greater than u2.
                $CODE       'U>',$UGR,VEF_USUAL
                COMP_OP     A
                $NEXT
