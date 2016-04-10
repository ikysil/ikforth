\
\  double.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading DOUBLE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @
HEX

\ 8.6.1.1050 D-
\ (S d1|ud1 d2|ud2 -- d3|ud3 )
\ Subtract d2|ud2 from d1|ud1, giving the difference d3|ud3.
CODE D-
  59 B,                    \ POP     ECX
  5B B,                    \ POP     EBX
  5A B,                    \ POP     EDX
  58 B,                    \ POP     EAX
  2B B, C3 B,              \ SUB     EAX,EBX
  1B B, D1 B,              \ SBB     EDX,ECX
  50 B,                    \ PUSH    EAX
  52 B,                    \ PUSH    EDX
  $NEXT
END-CODE

\ 8.6.1.1090 D2*
\ (S xd1 -- xd2 )
\ xd2 is the result of shifting xd1 one bit toward the most-significant bit, filling the vacated least-significant bit with zero.
CODE D2*
  5A B,                    \ POP     EDX
  58 B,                    \ POP     EAX
  D1 B, E0 B,              \ SAL     EAX,1
  D1 B, D2 B,              \ RCL     EDX,1
  50 B,                    \ PUSH    EAX
  52 B,                    \ PUSH    EDX
  $NEXT
END-CODE

\ 8.6.1.1100 D2/
\ (S xd1 -- xd2 )
\ xd2 is the result of shifting xd1 one bit toward the least-significant bit, leaving the most-significant bit unchanged.
CODE D2/
  5A B,                    \ POP     EDX
  58 B,                    \ POP     EAX
  D1 B, FA B,              \ SAR     EDX,1
  D1 B, D8 B,              \ RCR     EAX,1
  50 B,                    \ PUSH    EAX
  52 B,                    \ PUSH    EDX
  $NEXT
END-CODE

\ 8.6.1.1830 M+
\ (S d1|ud1 n -- d2|ud2 )
\ Add n to d1|ud1, giving the sum d2|ud2.
: M+ S>D D+ ;

BASE !

: 2CONSTANT CREATE HERE 2 CELLS ALLOT 2! DOES> 2@ ;

: 2VARIABLE CREATE 0. , , DOES> ;

: D0< NIP 0< ;

: D0> DNEGATE D0< ;

: D<-EXECUTE \ (S ln1 mn1 ln2 mn2 xt -- flag )
   >R
   ROT SWAP     \ S: ln1 ln2 mn1 mn2 R: xt
   2DUP = IF    \ compare ln* parts ONLY if mn* parts are equal
      2DROP
      U<
      R> DROP
      EXIT
   THEN
   2SWAP 2DROP  \ S: ln1 ln2 R: xt
   R>
   EXECUTE
;

: D< ['] < D<-EXECUTE ;

: D> 2SWAP D< ;

: D0= OR 0= ;

: D= D- D0= ;

\ 8.6.2.1270 DU<
\ (S ud1 ud2 -- flag )
\ flag is true if and only if ud1 is less than ud2.
: DU< (S ud1 ud2 -- flag )
   ['] U< D<-EXECUTE
;

: D>S DROP ;

: DXOR (S d1 d2 -- d1 xor d2 )
  ROT XOR -ROT XOR SWAP
;

\ 8.6.1.1220 DMIN
\ (S d1 d2 -- d3 )
\ d3 is the lesser of d1 and d2.
: DMIN (S d1 d2 -- d3 )
   2OVER 2OVER D> IF 2SWAP THEN 2DROP
;

\ 8.6.1.1210 DMAX
\ (S d1 d2 -- d3 )
\ d3 is the greater of d1 and d2.
: DMAX (S d1 d2 -- d3 )
   2OVER 2OVER D< IF 2SWAP THEN 2DROP
;

\ 8.6.1.1160 DABS
\ ( d -- ud )
\ ud is the absolute value of d.
\ Assuming 2-complement representation
: DABS (S d -- ud )
  DUP SIGN-FILL DUP \ d sd
  2SWAP 2OVER       \ sd d sd
  D+ DXOR
;

: TNEGATE (S t1lo t1mid t1hi -- t2lo t2mid t2hi )
  INVERT >R
  INVERT >R
  INVERT 0 -1. D+ S>D R> 0 D+
  R> +
;

: UT* (S ulo uhi u -- utlo utmid uthi )
  SWAP >R DUP >R
  UM* 0 R> R> UM* D+
;

: MT* (S lo hi n -- tlo tmid thi )
  DUP 0<
  IF
    ABS OVER 0<
    IF
      >R DABS R> UT*
    ELSE
      UT* TNEGATE
    THEN
  ELSE
    OVER 0<
    IF
      >R DABS R> UT* TNEGATE
    ELSE
      UT*
    THEN
  THEN
;

: UT/ (S utlo utmid uthi n -- d1 )
  DUP >R UM/MOD -ROT R> UM/MOD
  NIP SWAP
;

: M*/ (S d1 n1 +n2 -- d2 )
  >R MT* DUP 0<
  IF
    TNEGATE R> UT/ DNEGATE
  ELSE
    R> UT/
  THEN
;

: 2+! \ (S x1 x2 addr -- )
  DUP >R 2@ D+ R> 2!
;

REPORT-NEW-NAME !
