\ DEBUG-ON

: (F+EXTRACT) (S -- t1 t2 e1 e2 ) (F r1 r2 -- r1 r2 )
   \G Extract the mantissa of the two top items on the FP stack and sign-extend to triple-cell values.
   \G e1 is exponent of r1 and e2 is exponent of r2.
   'FPY FPM@ 0 ?FPY0<  IF  TNEGATE  THEN
   'FPX FPM@ 0 ?FPX0<  IF  TNEGATE  THEN
   'FPY FPE@ FPFLAGS>EXP
   'FPX FPE@ FPFLAGS>EXP
;


: (F+ORDER) (S t1 t2 e1 e2 -- t1' t2' +diffexp )
   \G Prepare operands for add/subtract operation.
   \G Swap t1 and t2 if (e1-e2) < 0, +dexp is the absolute value of diffexp.
   - DUP 0<  IF  NEGATE >R 3SWAP R>  THEN
;


4                      CONSTANT  /F+GUARDBITS
1 /F+GUARDBITS LSHIFT  CONSTANT  F+EVENBIT
F+EVENBIT 1 RSHIFT     CONSTANT  F+GUARDBIT
F+GUARDBIT 1-          CONSTANT  F+STICKYBITS


: (F+MALIGN) (S t +diffexp -- t' )
   \G Align mantissa represented as triple-cell value t by +diffexp positions.
   \DEBUG S" (F+DENORM)-INPUT: " CR TYPE CR H.S CR
   0 MAX 96 MIN
   DUP 0=               IF  DROP EXIT  THEN
   >R 3DUP T0= R> SWAP  IF  DROP EXIT  THEN
   \DEBUG S" (F+DENORM)-LOOP: " CR TYPE CR H.S CR
   0  ?DO  T2/  LOOP
   ROT 1 OR -ROT
   \DEBUG S" (F+DENORM)-RESULT: " CR TYPE CR H.S CR
;


: (F+GD+) (S t -- t' )
   \G Add guard bits - shift left for a predefined amount.
   /F+GUARDBITS 0  ?DO  T2*  LOOP
;


: (F+GD-) (S t -- t' )
   \G Remove guard bits - shift right for a predefined amount.
   /F+GUARDBITS 0  ?DO  T2/  LOOP
;


: (F+RN) (S t -- t')
   \G Round exact addition result to nearest.
   EXIT
   \DEBUG S" (F+RN)-INPUT: " CR TYPE CR H.S CR
   ROT DUP >R -ROT           \ S: t           R: tlo
   R@ F+GUARDBIT   AND       \ S: t g         R: tlo
   R@ F+EVENBIT    AND       \ S: t g e       R: tlo
   R@ F+STICKYBITS AND       \ S: t g e s     R: tlo
   \DEBUG S" (F+RN)-BITS: " CR TYPE CR H.S CR
   R> DROP
   OR 0<> AND 0<> F+EVENBIT AND
   \DEBUG S" (F+RN)-CORR: " CR TYPE CR H.S CR
   S>T T+
   \DEBUG S" (F+RN)-RESULT: " CR TYPE CR H.S CR
;


: F+ (F r1 r2 -- r3 ) \ 12.6.1.1420 F+
   (G Add r1 to r2 giving the sum r3.)
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F+-INPUT: " CR TYPE CR F.DUMP CR
   ?FP2OP-NAN  IF  EXIT  THEN
   ?FPX-INF ?FPY-INF AND  IF
      ?FPX0< ?FPY0< XOR
      FDROP
      IF  FPX-NAN!  THEN
      EXIT
   THEN
   ?FPX-INF ?FPY-INF XOR  IF
      ?FPX-INF  IF  FSWAP  THEN
      FDROP EXIT
   THEN
   ?FPX0= ?FPY0= AND  IF
      ?FPX0< ?FPY0< AND
      FDROP FDROP
      FZERO  IF  FNEGATE  THEN
      EXIT
   THEN
   ?FPX0=  IF  FDROP EXIT  THEN
   ?FPY0=  IF  FNIP  EXIT  THEN
   (F+EXTRACT)
   \DEBUG S" F+-EXTRACT: " CR TYPE CR H.S CR
   2DUP MAX >R
   (F+ORDER)
   \DEBUG S" F+-ORDER: " CR TYPE CR H.S CR
   >R
   3SWAP (F+GD+)
   3SWAP (F+GD+)
   R>
   \DEBUG S" F+-GUARD: " CR TYPE CR H.S CR
   (F+MALIGN)
   \DEBUG S" F+-MALIGN: " CR TYPE CR H.S CR
   T+ T2/
   \DEBUG S" F+-EXACT: " CR TYPE CR H.S CR
   DUP FPV-SIGN-MASK AND DUP >R
   0<>  IF  TNEGATE  THEN
   (F+RN)
   \DEBUG S" F+-ROUND: " CR TYPE CR H.S CR
   (F+GD-)
   \DEBUG S" F+-SUM: " CR TYPE CR H.S CR
   FDROP
   ABORT" MUST BE ZERO IN F+!"
   R>
   R> FPFLAGS>EXP 1+ FPV-EXP-MASK AND OR
   \DEBUG S" F+-RESULT: " CR TYPE CR H.S CR
   'FPX FPE!
   'FPX FPM!
   FPX-NORMALIZE
   \DEBUG S" F+-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


: F- (F r1 r2 -- r3 ) \ 12.6.1.1425 F-
   (G Subtract r2 from r1, giving r3.)
   ?FP2OP-NAN  IF  EXIT  THEN
   FNEGATE F+
;
