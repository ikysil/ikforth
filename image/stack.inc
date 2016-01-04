;******************************************************************************
;
;  stack.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Stack manipulation
;******************************************************************************

;  6.1.0630 ?DUP
;  Duplicate top stack cell if it is not equal to zero
;  D: a -- a | a a
                        $DEF    '?DUP',$QDUP
                        FETCHDS EAX
                        AND     EAX,EAX
                        JZ      SHORT QDUPZERO
                        PUSHDS  EAX
QDUPZERO:
                        $NEXT

;  6.1.0370 2DROP
;  D: a b --
                        $DEF    '2DROP',$2DROP
                        POPDS   EAX
                        POPDS   EAX
                        $NEXT

;  6.1.0380 2DUP
;  D: a b -- a b a b
                        $DEF    '2DUP',$2DUP
                        FETCHDS EAX,1
                        FETCHDS EBX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  6.1.0400 2OVER
;  D: a b c d -- a b c d a b
                        $DEF    '2OVER',$2OVER
                        FETCHDS EAX,3
                        FETCHDS EBX,2
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  6.1.0430 2SWAP
;  D: a b c d -- c d a b
                        $DEF    '2SWAP',$2SWAP
                        POPDS   EDX
                        POPDS   ECX
                        POPDS   EBX
                        POPDS   EAX
                        PUSHDS  ECX
                        PUSHDS  EDX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT


;  6.1.1260 DROP
;  Remove top cell from the stack
;  D: a --
                        $DEF    'DROP',$DROP
                        POPDS   EAX
                        $NEXT

;  6.1.1290 DUP
;  D: a -- a a
                        $DEF    'DUP',$DUP
                        FETCHDS EAX
                        PUSHDS  EAX
                        $NEXT

;  6.2.1930 NIP
;  Drop the first item below the top of stack.
;  D: x1 x2 -- x2
                        $DEF    'NIP',$NIP
                        POPDS   EAX
                        POPDS   EBX
                        PUSHDS  EAX
                        $NEXT

;  6.1.1990 OVER
;  D: a b -- a b a
                        $DEF    'OVER',$OVER
                        FETCHDS EAX,1
                        PUSHDS  EAX
                        $NEXT

;  6.1.2160 ROT
;  D: a b c -- b c a
                        $DEF    'ROT',$ROT
                        POPDS   ECX
                        POPDS   EBX
                        POPDS   EAX
                        PUSHDS  EBX
                        PUSHDS  ECX
                        PUSHDS  EAX
                        $NEXT

;  8.6.2.0420 2ROT
;  D: a1 a2 b1 b2 c1 c2 -- b1 b2 c1 c2 a1 a2
                        $DEF    '2ROT',$2ROT
                        PUSHRS  EDI
                        PUSHRS  ESI
                        POPDS   EDX     \ c2
                        POPDS   ECX     \ c1
                        POPDS   EBX     \ b2
                        POPDS   EAX     \ b1
                        POPDS   EDI     \ a2
                        POPDS   ESI     \ a1
                        PUSHDS  EAX
                        PUSHDS  EBX
                        PUSHDS  ECX
                        PUSHDS  EDX
                        PUSHDS  ESI
                        PUSHDS  EDI
                        POPRS   ESI
                        POPRS   EDI
                        $NEXT

;  -ROT
;  D: a b c -- c a b 
                        $DEF    '-ROT',$MROT
                        POPDS   ECX
                        POPDS   EBX
                        POPDS   EAX
                        PUSHDS  ECX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  6.1.2260 SWAP
;  D: a b -- b a
                        $DEF    'SWAP',$SWAP
                        POPDS   EAX
                        POPDS   EBX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        $NEXT

;  6.2.2030 PICK
;  D: xu ... x1 x0 u -- xu ... x1 x0 xu
;  Remove u. Copy the xu to the top of the stack. An ambiguous condition exists
;  if there are less than u+2 items on the stack before PICK is executed. 
                        $DEF    'PICK',$PICK
                        POPDS   EBX
                        FETCHDS EAX,EBX
                        PUSHDS  EAX
                        $NEXT

;  6.2.2300 TUCK
;  D: x1 x2 -- x2 x1 x2
;  Copy the first (top) stack item below the second stack item. 
                        $DEF    'TUCK',$TUCK
                        POPDS   EAX
                        POPDS   EBX
                        PUSHDS  EAX
                        PUSHDS  EBX
                        PUSHDS  EAX
                        $NEXT

;  DS-SIZE
                        $CONST  'DS-SIZE'
                        CC      DATA_STACK_SIZE

;  SP0
                        $DEF    'SP0',$SP0
                        PUSHDS  <[DWORD PTR EDI + ESP_VAR]>
                        $NEXT

;  SP@
                        $DEF    'SP@',$SPFETCH
                        MOV     EAX,ESP
                        PUSHDS  EAX
                        $NEXT

;  SP!
                        $DEF    'SP!',$SPSTORE
                        POPDS   EAX
                        MOV     ESP,EAX
                        $NEXT

