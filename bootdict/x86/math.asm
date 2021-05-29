;******************************************************************************
;
;  math.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Integer math
;******************************************************************************

;  6.1.0090 *
;  Multiply n1|u1 by n2|u2 giving the product n3|u3.
;  D: n1|u1 n2|u2 -- n3|u3
                $CODE       '*',$STAR,VEF_USUAL
                POPDS       EAX
                POPDS       EBX
                IMUL        EBX
                PUSHDS      EAX
                $NEXT

;  6.1.0120 +
;  D: a b -- a+b
                $CODE       '+',$ADD,VEF_USUAL
                POPDS       EAX
                POPDS       EBX
                ADD         EAX,EBX
                PUSHDS      EAX
                $NEXT

;  6.1.0160 -
;  D: a b -- a-b
                $CODE       '-',$SUB,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                SUB         EAX,EBX
                PUSHDS      EAX
                $NEXT

;  6.1.0290 1+
;  D: a -- a+1
                $CODE       '1+',$1ADD,VEF_USUAL
                POPDS       EAX
                INC         EAX
                PUSHDS      EAX
                $NEXT

;  6.1.0300 1-
;  D: a -- a-1
                $CODE       '1-',$1SUB,VEF_USUAL
                POPDS       EAX
                DEC         EAX
                PUSHDS      EAX
                $NEXT

;  6.1.0320 2*
;  D: a -- a*2
                $CODE       '2*',$2MUL,VEF_USUAL
                POPDS       EAX
                SAL         EAX,1
                PUSHDS      EAX
                $NEXT

;  6.1.0330 2/
;  D: a -- a/2
                $CODE       '2/',$2DIV,VEF_USUAL
                POPDS       EAX
                SAR         EAX,1
                PUSHDS      EAX
                $NEXT

;  6.1.1805 LSHIFT
;  D: a b -- a << b
                $CODE       'LSHIFT',$LSHIFT,VEF_USUAL
                POPDS       ECX
                POPDS       EAX
                SHL         EAX,CL
                PUSHDS      EAX
                $NEXT

;  6.1.2162 RSHIFT
;  D: a b -- a >> b
                $CODE       'RSHIFT',$RSHIFT,VEF_USUAL
                POPDS       ECX
                POPDS       EAX
                SHR         EAX,CL
                PUSHDS      EAX
                $NEXT

;  6.1.1810 M*
;  d is the signed product of n1 times n2.
;  D: n1 n2 -- d
                $CODE       'M*',$MMUL,VEF_USUAL
                POPDS       EAX
                POPDS       EBX
                IMUL        EBX
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT

;  6.1.1910 NEGATE
;  D: a -- -a
                $CODE       'NEGATE',$NEGATE,VEF_USUAL
                POPDS       EAX
                NEG         EAX
                PUSHDS      EAX
                $NEXT

;  6.1.2214 SM/REM
;  Divide d1 by n1, giving the symmetric quotient n3 and the remainder n2.
;  Input and output stack arguments are signed. An ambiguous condition exists
;  if n1 is zero or if the quotient lies outside the range of a single-cell signed integer.
;  D: d1 n1 -- n2 n3
                $CODE       'SM/REM',$SMDIVREM,VEF_USUAL
                POPDS       EBX                     ; n1
                POPDS       EDX
                POPDS       EAX
                IDIV        EBX
                PUSHDS      EDX                     ; n2
                PUSHDS      EAX                     ; n3
                $NEXT

;******************************************************************************
;  Unsigned integer math
;******************************************************************************

;  6.1.2360 UM*
;  Multiply u1 by u2, giving the unsigned double-cell product ud.
;  All values and arithmetic are unsigned.
;  D: u1 u2 -- ud
                $CODE       'UM*',$UMMUL,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                MUL         EBX
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT

;  6.1.2370 UM/MOD
;  Divide ud by u1, giving the quotient u3 and the remainder u2.
;  All values and arithmetic are unsigned. An ambiguous condition exists if u1
;  is zero or if the quotient lies outside the range of a single-cell unsigned integer.
;  D: ud u1 -- u2 u3
                $CODE       'UM/MOD',$UMDIVMOD,VEF_USUAL
                POPDS       EBX                     ; u1
                POPDS       EDX
                POPDS       EAX
                DIV         EBX
                PUSHDS      EDX                     ; u2
                PUSHDS      EAX                     ; u3
                $NEXT

;  UMOD
;  Divide u1 by u2, giving the remainder u3.
;  All values and arithmetic are unsigned. An ambiguous condition exists if u2
;  is zero.
;  D: u1 u2 -- u3
                $CODE       'UMOD',$UMOD,VEF_USUAL
                POPDS       EBX                     ; u2
                POPDS       EAX                     ; u1
                XOR         EDX,EDX                 ; unsigned
                DIV         EBX
                PUSHDS      EDX                     ; u3
                $NEXT

;******************************************************************************
;  Logic
;******************************************************************************

;  6.1.0720 AND
;  D: a b -- a and b
                $CODE       'AND',$AND,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                AND         EAX,EBX
                PUSHDS      EAX
                $NEXT

;  6.1.1720 INVERT
;  D: a -- NOT a
                $CODE       'INVERT',$INVERT,VEF_USUAL
                POPDS       EAX
                NOT         EAX
                PUSHDS      EAX
                $NEXT

;  6.1.1980 OR
;  D: a b -- a or b
                $CODE       'OR',$OR,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                OR          EAX,EBX
                PUSHDS      EAX
                $NEXT

;  6.1.2490 XOR
;  D: a b -- a xor b
                $CODE       'XOR',$XOR,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                XOR         EAX,EBX
                PUSHDS      EAX
                $NEXT

;  UD/
;  D: UD1 UD2 -- REMD QD
                $CODE       'UD/',$UDDIV,VEF_USUAL
                PUSHRS      EDI
                PUSHRS      ESI
                POPDS       ECX
                POPDS       EBX
                POPDS       EDX
                POPDS       EAX
                PUSHDS      EBP
;
                MOV         EBP,64
                XOR         ESI,ESI
                XOR         EDI,EDI
UD_LOOP:
                SHL         EAX,1
                RCL         EDX,1
                RCL         EDI,1
                RCL         ESI,1
                CMP         ESI,ECX
                JA          SHORT UD_DIV
                JB          SHORT UD_NEXT
                CMP         EDI,EBX
                JB          SHORT UD_NEXT
UD_DIV:
                SUB         EDI,EBX
                SBB         ESI,ECX
                INC         EAX
UD_NEXT:
                DEC         EBP
                JNE         UD_LOOP
;
                POPDS       EBP
                PUSHDS      EDI
                PUSHDS      ESI
                PUSHDS      EAX
                PUSHDS      EDX
                POPRS       ESI
                POPRS       EDI
                $NEXT
