\ DEBUG-ON
USER F/-Q    3 CELLS USER-ALLOC
USER F/-QBIT 3 CELLS USER-ALLOC
USER F/-YM   3 CELLS USER-ALLOC
USER F/-XM   3 CELLS USER-ALLOC

: (F/EXP) (S -- exp ) (F r1 r2 -- r1 r2 )
   \G Compute the exponent for float division result.
   'FPY FPE@ FPFLAGS>EXP
   'FPX FPE@ FPFLAGS>EXP
   - 1+
;

: (F/EXACT) (S ud1 ud2 -- udlow udhigh )
   \G Perform exact division of unsigned double values.
   \DEBUG S" (F/EXACT)-INPUT: " CR TYPE CR H.S CR
   2>R 2>R
   0 S>T F/-Q T!
   0 0 FPV-MSBIT 1 TRSHIFT F/-QBIT T!
   0 2R>         2 TRSHIFT F/-YM T!
   0 2R>         2 TRSHIFT TNEGATE F/-XM T!
   BEGIN
      F/-QBIT T@ T0<>
      F/-YM   T@ T0<>
      AND
   WHILE
      F/-YM T@
      F/-XM T@
      \ DEBUG CR S" F/-LOOP1: " TYPE CR H.S CR
      T+ DUP 0<
      \ DEBUG CR S" F/-LOOP2: " TYPE CR H.S CR
      IF
         3DROP
      ELSE
         F/-YM T!
         F/-Q T@ F/-QBIT T@ 3OR F/-Q T!
      THEN
      F/-XM   T@ T2/ F/-XM   T!
      F/-QBIT T@ T2/ F/-QBIT T!
   REPEAT
   0 F/-Q T@
   \DEBUG S" (F/EXACT)-RESULT: " CR TYPE CR H.S CR
;

: (F/NORMALIZE) (S t1 -- t1' exp-corr )
   \G Normalize exact division result - most significant 3 cells.
   \G exp-corr is exponent correction if required.
   0 >R
   BEGIN
      DUP FPV-MSBIT AND 0=
   WHILE
      T2*
      R> 1- >R
   REPEAT
   R>
;

\ DEBUG-ON
: (F/RN) (S udlo udhi -- ud exp-corr )
   \G Round exact division result to nearest.
   \G exp-corr is exponent correction if required.
   \DEBUG CR ." (F/RN)-INPUT:  " 2OVER 2OVER H.8 H.8 SPACE H.8 H.8 CR
   (F*RN)
   \DEBUG CR ." (F/RN)-RESULT: " 3DUP H.8 SPACE H.8 H.8 CR
   EXIT

   2SWAP OR 0<> 1 AND >R  \ S: dm     R: stiky
   OVER 1 AND R> AND S>D
   \DEBUG S" (F/RN)-CORR: " CR TYPE CR H.S CR
   2>R 0 2R> 0
   \DEBUG S" (F/RN)-ROUND: " CR TYPE CR H.S CR
   T+
   DUP 0<>  IF  T2/ 1  ELSE  0  THEN
   NIP
;
\DEBUG-OFF


: F/ (F r1 r2 -- r3 ) \ 12.6.1.1430 F/
   \G Divide r1 by r2, giving the quotient r3.
   \G An ambiguous condition exists if r2 is zero,
   \G or the quotient lies outside of the range of a floating-point number.
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F/-INPUT: " CR TYPE CR F.DUMP CR
   ?FP2OP-NAN  IF  EXIT  THEN
   ?FPX-INF ?FPY-INF AND  IF
      \ (F*/SIGN) FDROP 'FPX FPE!
      FDROP
      FPX-NAN! EXIT
   THEN
   ?FPX-INF ?FPY-INF XOR  IF
      (F*/SIGN)
      ?FPX-INF  IF
         FDROP FDROP
         FZERO  IF  FNEGATE  THEN
      ELSE
         FDROP
         DROP
      THEN
      EXIT
   THEN
   ?FPX0=  IF
      ?FPY-INF  IF  FDROP FPX-NAN! EXIT  THEN
      ?FPY0=    IF  FDROP FPX-NAN! EXIT  THEN
      (F*/SIGN) FDROP 'FPX FPE! FPX-INF! EXIT
   THEN
   ?FPY0=  IF
      F0<  IF  FNEGATE  THEN
      EXIT
   THEN
   (F*/SIGN) >R
   (F/EXP)  >R
   'FPY FPM@ 'FPX FPM@
   (F/EXACT)
   \DEBUG S" F/-EXACT: " CR TYPE CR H.S CR
   (F/NORMALIZE)
   \DEBUG S" F/-NORMALIZED: " CR TYPE CR H.S CR
   R> + >R
   (F/RN)
   \DEBUG S" F/-ROUND: " CR TYPE CR H.S CR
   R> + R>
   (F*/RESULT)
   \DEBUG S" F/-RESULT: " CR TYPE CR H.S CR
   'FPY FPE!
   'FPY FPM!
   FDROP
   \DEBUG S" F/-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF
