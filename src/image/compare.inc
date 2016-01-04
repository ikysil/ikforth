;******************************************************************************
;
;  compare.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Compare
;******************************************************************************

;  6.2.1485 FALSE
;  Return a false flag.
;  D: -- false
                        $CODE   'FALSE',$FALSE
                        PUSHDS  F_FALSE
                        $NEXT

;  6.2.2298 TRUE
;  Return a true flag, a single-cell value with all bits set.
;  D: -- true
                        $CODE   'TRUE',$TRUE
                        PUSHDS  F_TRUE
                        $NEXT

;  <
                        $CODE   '<',$LE
                        POPDS   EBX
                        POPDS   EAX
                        CMP     EAX,EBX
                        MOV     EAX,F_TRUE
                        JL      SHORT LE_YES
                        MOV     EAX,F_FALSE
LE_YES:
                        PUSHDS  EAX
                        $NEXT

;  >
                        $CODE   '>',$GR
                        POPDS   EBX
                        POPDS   EAX
                        CMP     EAX,EBX
                        MOV     EAX,F_TRUE
                        JG      SHORT GR_YES
                        MOV     EAX,F_FALSE
GR_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.1.0530 =
;  D: a b -- flag ( a = b )
                        $CODE   '=',$EQ
                        POPDS   EBX
                        POPDS   EAX
                        CMP     EAX,EBX
                        MOV     EAX,F_TRUE
                        JZ      SHORT EQ_YES
                        MOV     EAX,F_FALSE
EQ_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.2.0500 <>
;  Flag is true if and only if x1 is not bit-for-bit the same as x2.
;  D: x1 x2 -- flag
                        $CODE   '<>',$NOEQ
                        POPDS   EBX
                        POPDS   EAX
                        CMP     EAX,EBX
                        MOV     EAX,F_TRUE
                        JNZ     SHORT NOEQ_YES
                        MOV     EAX,F_FALSE
NOEQ_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.1.0250 0<
;  D: a -- flag ( a < 0 )
                        $CODE   '0<',$ZEROLE
                        POPDS   EAX
                        OR      EAX,EAX
                        MOV     EAX,F_TRUE
                        JL      SHORT ZEROLE_YES
                        MOV     EAX,F_FALSE
ZEROLE_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.1.0270 0=
;  D: a -- flag ( a = 0 )
                        $CODE   '0=',$ZEROEQ
                        POPDS   EAX
                        OR      EAX,EAX
                        MOV     EAX,F_TRUE
                        JZ      SHORT ZEROEQ_YES
                        MOV     EAX,F_FALSE
ZEROEQ_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.2.0260 0<>
;  Flag is true if and only if x is not equal to zero.
;  D: x -- flag
                        $CODE   '0<>',$ZERONOEQ
                        POPDS   EAX
                        OR      EAX,EAX
                        MOV     EAX,F_TRUE
                        JNZ     SHORT ZERONOEQ_YES
                        MOV     EAX,F_FALSE
ZERONOEQ_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.2.0280 0>
;  Flag is true if and only if n is greater than zero.
;  D: n -- flag
                        $CODE   '0>',$ZEROGR
                        POPDS   EAX
                        OR      EAX,EAX
                        MOV     EAX,F_TRUE
                        JG      SHORT ZEROGR_YES
                        MOV     EAX,F_FALSE
ZEROGR_YES:
                        PUSHDS  EAX
                        $NEXT

;******************************************************************************
;  Unsigned compare
;******************************************************************************

;  6.1.2340 U<
;  Flag is true if and only if u1 is less than u2.
;  D: u1 u2 -- flag ( u1 < u2 )
                        $CODE   'U<',$ULE
                        POPDS   EBX
                        POPDS   EAX
                        CMP     EAX,EBX
                        MOV     EAX,F_TRUE
                        JB      SHORT ULE_YES           ; jump if EAX < EBX
                        MOV     EAX,F_FALSE
ULE_YES:
                        PUSHDS  EAX
                        $NEXT

;  6.2.2350 U>
;  D: u1 u2 -- flag
;  flag is true if and only if u1 is greater than u2. 
                        $CODE   'U>',$UGR
                        POPDS   EBX
                        POPDS   EAX
                        CMP     EAX,EBX
                        MOV     EAX,F_TRUE
                        JA      SHORT UGR_YES           ; jump if EAX > EBX
                        MOV     EAX,F_FALSE
UGR_YES:
                        PUSHDS  EAX
                        $NEXT

