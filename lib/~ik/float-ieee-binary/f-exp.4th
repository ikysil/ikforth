\ DEBUG-ON
18  CONSTANT  FEXPM1-ITERATIONS-DEFAULT

: FEXPM1-APPROX (S +n -- ) (F r1 -- r2 )
   \G Approximate exp(r1 - 1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FDUP FDUP
   1 2>R
   BEGIN
      2R> 1 +
      2DUP >
      \ S: n i flag    R:          F: r2(i-1)' r1 (r1**(i-1))/(i-1)!
   WHILE
      DUP S>D 2SWAP 2>R
      \ S: di          R: n i      F: r2(i-1)' r1 (r1**(i-1))/(i-1)!
      FOVER F*
      D>F F/
      \ S:             R: n i      F: r2(i-1)' r1 (r1**(i))/(i)!
      FROT FOVER F+
      \ S:             R: n i      F: r1 (r1**(i))/(i)!  r2'+(r1**(i))/(i)!
      FROT FROT
      \ S:             R: n i      F: r2(i)' r1 (r1**(i))/(i)!
   REPEAT
   2DROP
   \ F: r2(i)' r1 (r1**(i))/(i)!
   FDROP FDROP
;

: FEXPM1 (F r1 -- r2 ) \ 12.6.2.1516 FEXPM1
   \G Raise e to the power r1 and subtract one, giving r2.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX-INF  IF
      ?FPX0<  IF  FDROP FZERO  THEN
      EXIT
   THEN
   \DEBUG S" FEXPM1-INPUT: " CR TYPE CR F.DUMP CR
   FEXPM1-ITERATIONS-DEFAULT FEXPM1-APPROX
   \DEBUG S" FEXPM1-RESULT: " CR TYPE CR F.DUMP CR
;

: FEXP (F r1 -- r2 ) \ 12.6.2.1515 FEXP
   \G Raise e to the power r1, giving r2.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   \DEBUG S" FEXP-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX-INF  IF
      ?FPX0<  IF  FDROP FZERO  THEN
      EXIT
   THEN
   ?FPX0< FABS
   FEXPM1 FONE F+
   IF  FONE FSWAP F/  THEN
   \DEBUG S" FEXP-RESULT: " CR TYPE CR F.DUMP CR
;

1.E FEXP  FCONSTANT  FLNBASE
\DEBUG-OFF
