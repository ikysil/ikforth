\ DEBUG-ON


: ~(F/NR-STEP) (F r1 r2 -- r1 r2' )
   \G Perform iteration step for Newton-Raphson division by r1 given the initial approximation r2.
   \G r2' is the new approximation.
   2 ?FPSTACK-OVERFLOW
   FOVER FOVER       \ F: r1 r2 r1 r2
   F*                \ F: r1 r2 r1*r2
   FNEGATE FTWO F+   \ F: r1 r2 2-r1*r2
   F*                \ F: r1 r2'
;


: (F/NR-STEP) (F r1 r2 -- r1 r2' )
   \G Perform iteration step for Newton-Raphson division by r1 given the initial approximation r2.
   \G r2' is the new approximation.
   3 ?FPSTACK-OVERFLOW
   FOVER             \ F: r1 r2
   FTWO FROT FROT    \ F: r1 2.e r2 r1
   FNEGATE F*+       \ F: r1 r2'
;


: F/ (F r1 r2 -- r3 ) \ 12.6.1.1430 F/
   \G Divide r1 by r2, giving the quotient r3.
   \G An ambiguous condition exists if r2 is zero,
   \G or the quotient lies outside of the range of a floating-point number.
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F/-INPUT: " CR TYPE CR DEPTH . CR FDEPTH . CR F.DUMP CR
   ?FP2OP-NAN  IF  EXIT  THEN
   \DEBUG S" F/-INPUT-A: " CR TYPE CR FDEPTH . CR F.DUMP CR
   ?FPX-INF ?FPY-INF AND  IF
      \ (F*/SIGN) FDROP 'FPX FPE!
      FDROP
      FPX-NAN! EXIT
   THEN
   \DEBUG S" F/-INPUT-B: " CR TYPE CR FDEPTH . CR F.DUMP CR
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
   \DEBUG S" F/-INPUT-C: " CR TYPE CR FDEPTH . CR F.DUMP CR
   ?FPX0=  IF
      ?FPY-INF  IF  FDROP FPX-NAN! EXIT  THEN
      ?FPY0=    IF  FDROP FPX-NAN! EXIT  THEN
      (F*/SIGN) FDROP 'FPX FPE! FPX-INF! EXIT
   THEN
   \DEBUG S" F/-INPUT-D: " CR TYPE CR FDEPTH . CR F.DUMP CR
   ?FPY0=  IF
      F0<  IF  FNEGATE  THEN
      EXIT
   THEN
   (F*/SIGN) IF  FPV-NEGATIVE  ELSE  FPV-POSITIVE  THEN
   >R
   FABS
   FREXP INVERT ABORT" unexpected" >R
   \DEBUG S" F/-STEP-E0: " CR TYPE CR FDEPTH . CR F.DUMP CR
   FPX2/
   FONE
   \DEBUG S" F/-STEP-E: " CR TYPE CR FDEPTH . CR F.DUMP CR
   (F/NR-STEP)
   \DEBUG S" F/-STEP-F: " CR TYPE CR FDEPTH . CR F.DUMP CR
   (F/NR-STEP)
   \DEBUG S" F/-STEP-G: " CR TYPE CR FDEPTH . CR F.DUMP CR
   (F/NR-STEP)
   \DEBUG S" F/-STEP-H: " CR TYPE CR FDEPTH . CR F.DUMP CR
   (F/NR-STEP)
   \DEBUG S" F/-STEP-I: " CR TYPE CR FDEPTH . CR F.DUMP CR
   (F/NR-STEP)
   \DEBUG S" F/-STEP-J: " CR TYPE CR FDEPTH . CR F.DUMP CR
   (F/NR-STEP)
   \DEBUG S" F/-STEP-K: " CR TYPE CR FDEPTH . CR F.DUMP CR
   FNIP F*
   \DEBUG S" F/-STEP-L: " CR TYPE CR FDEPTH . CR F.DUMP CR
   ?FPX-NAN  IF  R> R> 2DROP EXIT  THEN
   FREXP INVERT ABORT" unexpected"
   R> 1+ - R>
   'FPX FPM@ 2SWAP
   FDROP FP-RESULT >FP
   \DEBUG S" F/-RESULT: " CR TYPE CR FDEPTH . CR F.DUMP CR
;
\DEBUG-OFF
