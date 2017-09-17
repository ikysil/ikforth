\ DEBUG-ON
: (F/SIGN) (F r1 r2 -- r1' r2')
   \G Correct signs of divident and divisor for Goldschmidt division.
   \G Invert signs of r1 and r2 if r2 < 0.
   ?FPX0<  IF
      FSWAP FNEGATE
      FSWAP FNEGATE
   THEN
;

: (F/SCALE) (F r1 r2 -- r1' r2')
   \G Scale divident and divisor for Goldschmidt division.
   \G 0 < r2' <1.
   'FPY FPE@ FPFLAGS>EXP
   'FPX FPE@ FPFLAGS>EXP
   -
   FPV-EXP-MASK AND
   'FPY FPE@ FPV-EXP-MASK INVERT AND OR
   'FPY FPE!
   0
   FPV-EXP-MASK AND
   'FPX FPE@ FPV-EXP-MASK INVERT AND OR
   'FPX FPE!
;

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
   (F/SIGN)
   \DEBUG CR ." F/-SIGN: " CR F.DUMP CR
   (F/SCALE)
   \DEBUG CR ." F/-SCALE: " CR F.DUMP CR
   BEGIN
      FDUP FONE F- F0= INVERT
      'FPX FPM@ AND -1 <> AND
   WHILE
      FDUP FTWO F- FNEGATE      \ F: Ni Di Fi'
      \DEBUG CR ." F/-LOOP: " CR F.DUMP CR
      FSWAP FOVER F*            \ F: Ni Fi' Di'
      FP> F* >FP                \ F: Ni' Di'
   REPEAT
   FDROP
   \DEBUG CR ." F/-RESULT: " CR F.DUMP CR
;
\DEBUG-OFF
