\ DEBUG-ON
: FPCMP-SIGN (S -- flag1 flag2 ) (F r1 r2 -- r1 r2 )
   \G Compare signs.
   \G flag1 is result of comparation.
   \G flag2 is true if sign comparation result is available.
   ?FPY0= ?FPX0= AND  IF
       0 TRUE EXIT
   THEN
   ?FPY0< ?FPX0< INVERT AND  IF
      -1 TRUE EXIT
   THEN
   ?FPY0< INVERT ?FPX0< AND  IF
      1 TRUE EXIT
   THEN
   0 FALSE
;

: FPCMP-INF (S -- flag1 flag2 ) (F r1 r2 -- r1 r2 )
   \G Compare infinities.
   \G flag1 is result of comparation.
   \G flag2 is true if infinity comparation result is available.
   ?FPX-INF ?FPY-INF INVERT AND  IF
      -1 TRUE EXIT
   THEN
   ?FPY-INF ?FPX-INF INVERT AND  IF
       1 TRUE EXIT
   THEN
   ?FPY-INF ?FPX-INF AND  IF
      FPCMP-SIGN  IF
         TRUE EXIT
      ELSE
         DROP
      THEN
   THEN
   0 FALSE
;

: FPCMP (S -- flag1 flag2 ) (F r1 r2 -- r1 r2 )
   \G Compare r1 and r2, output flag1 as follows:
   \G -1 when r1<r2
   \G  0 when r1=r2
   \G  1 when r1>r2
   \G flag2 is true if both r1 and r2 are comparable values,
   \G false otherwise. flag1 is underfined if flag2 is false.
   \G Comparable value is not a NaN.
   \G Also, infinities of the same sign are not comparable.
   \DEBUG S" FPCMP-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX-NAN ?FPY-NAN OR  IF
      0 FALSE EXIT
   THEN
   FPCMP-INF  IF  DUP 0<> EXIT  THEN
   DROP
   FPCMP-SIGN  IF  TRUE EXIT  THEN
   DROP
   'FPY FPE@ FPFLAGS>EXP
   'FPX FPE@ FPFLAGS>EXP
   \DEBUG S" FPCMP-EXP: " CR TYPE CR 2DUP SWAP H.8 SPACE H.8 CR
   - SGN
   DUP 0=  IF
      DROP
      'FPY FPM@ 0
      'FPX FPM@ 0
      TNEGATE T+
      SGN
      DUP 0=  IF
         DROP OR 0<> ABS
      ELSE
         >R 2DROP R>
      THEN
   ELSE
      ?FPY0=  IF  DROP -1  THEN
      ?FPX0=  IF  DROP  1  THEN
   THEN
   ?FPY0< ?FPX0< OR  IF  NEGATE  THEN
   TRUE
   \DEBUG S" FPCMP-RESULT: " CR TYPE CR 2DUP SWAP H.8 SPACE H.8 CR
;

: FCMP (S -- flag1 flag2 ) (F r1 r2 -- )
   \G Compare r1 and r2, output flag1 as follows:
   \G -1 when r1<r2
   \G  0 when r1=r2
   \G  1 when r1>r2
   \G flag2 is true if both r1 and r2 are comparable (non-NaN) values,
   \G false otherwise.
   FPCMP
   FDROP FDROP
;

: F< (S -- flag ) (F r1 r2 -- ) \ 2.6.1.1460 F<
   \G flag is true if and only if r1 is less than r2.
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F<-INPUT: " CR TYPE CR F.DUMP CR
   FCMP DROP
   0<
   \DEBUG S" F<-RESULT: " CR TYPE CR H.S CR
;
\DEBUG-OFF


: F> (S -- flag ) (F r1 r2 -- )
   \G flag is true if and only if r1 is larger than r2.
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F>-INPUT: " CR TYPE CR F.DUMP CR
   FCMP DROP
   0>
   \DEBUG S" F>-RESULT: " CR TYPE CR H.S CR
;


: FMIN (F r1 r2 -- r3 ) \ 12.6.1.1565 FMIN
   (G r3 is the lesser of r1 and r2.)
   2 ?FPSTACK-UNDERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   FPCMP  IF
      0< IF  FDROP  ELSE  FNIP  THEN
   ELSE
      FDROP
      FPX-NAN!
   THEN
;


: FMAX (F r1 r2 -- r3 ) \ 12.6.1.1562 FMAX
   (G r3 is the greater of r1 and r2.)
   2 ?FPSTACK-UNDERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   FPCMP  IF
      0> IF  FDROP  ELSE  FNIP  THEN
   ELSE
      FDROP
      FPX-NAN!
   THEN
;

\ DEBUG-ON
: F~ (S -- flag ) (F r1 r2 r3 -- ) \ 12.6.2.1640 F~
   \G If r3 is positive, flag is true if the absolute value of (r1 minus r2) is less than r3.
   \G
   \G If r3 is zero, flag is true if the implementation-dependent encoding of r1 and r2 are exactly
   \G identical (positive and negative zero are unequal if they have distinct encodings).
   \G
   \G If r3 is negative, flag is true if the absolute value of (r1 minus r2) is less than
   \G the absolute value of r3 times the sum of the absolute values of r1 and r2.
   3 ?FPSTACK-UNDERFLOW
   \DEBUG CR ." F~-INPUT: " CR F.DUMP CR
   ?FPX0= IF
      FDROP
      'FPX 'FPY 1 FLOATS TUCK
      \DEBUG CR ." F~-ENC-INPUT: " CR H.S CR
      COMPARE 0=
      \DEBUG CR ." F~-RESULT: " DUP H.8 CR
      FDROP FDROP
      EXIT
   THEN
   ?FPX0< IF
      FABS FP>          \ F: r1 r2                                S: abs(r3)
      FDUP FABS FP>     \ F: r1 r2                                S: abs(r3) abs(r2)
      FOVER FABS FP>    \ F: r1 r2                                S: abs(r3) abs(r2) abs(r1)
      \DEBUG CR ." F~-B1: " CR F.DUMP CR H.S CR
      F- FABS           \ F: abs(r1-r2)                           S: abs(r3) abs(r2) abs(r1)
      \DEBUG CR ." F~-B2: " CR F.DUMP CR H.S CR
      >FP >FP F+        \ F: abs(r1-r2) abs(r1)+abs(r2)           S: abs(r3)
      \DEBUG CR ." F~-B3: " CR F.DUMP CR H.S CR
      >FP F*            \ F: abs(r1-r2) (abs(r1)+abs(r2))*abs(r3)
      \DEBUG CR ." F~-B4: " CR F.DUMP CR H.S CR
      F-
      \DEBUG CR ." F~-B5: " CR F.DUMP CR H.S CR
      F0<
      \DEBUG CR ." F~-B6: " CR H.S CR
   ELSE
      FP> F- FABS >FP
      \DEBUG CR ." F~-C1: " CR F.DUMP CR
      F<
   THEN
   \DEBUG CR ." F~-RESULT: " DUP H.8 CR
;
\DEBUG-OFF


\ DEBUG-ON
: F= (F r1 r2 -- ) (S -- flag )
   \G flag is true if and only if r1 is equal to r2.
   \G +0 = -0 as per IEEE.
   2 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   \DEBUG S" F=-INPUT: " CR TYPE CR F.DUMP CR
   ?FP2OP-NAN         IF  FDROP FALSE      EXIT  THEN
   ?FPX0= ?FPY0= AND  IF  FDROP FDROP TRUE EXIT  THEN
   0. D>F F~
   \DEBUG S" F=-RESULT: " CR TYPE CR H.S CR
;
\DEBUG-OFF
