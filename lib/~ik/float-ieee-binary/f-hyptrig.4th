\ DEBUG-ON
: FHYPEXP (F r1 -- exp[r1] exp[-r1])
   \G Calculate exponents for hyperbolic functions.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   FDUP FEXP
   FSWAP FNEGATE FEXP
;

: FSINH (F r1 -- r2 ) \ 12.6.2.1617 FSINH
   \G r2 is the hyperbolic sine of r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FSINH-INPUT: " CR TYPE CR F.DUMP CR
   FHYPEXP F- FTWO F/
   \DEBUG S" FSINH-RESULT: " CR TYPE CR F.DUMP CR
;

: FCOSH (F r1 -- r2 ) \ 12.6.2.1494 FCOSH
   \G r2 is the hyperbolic cosine of r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FCOSH-INPUT: " CR TYPE CR F.DUMP CR
   FHYPEXP F+ FTWO F/
   \DEBUG S" FCOSH-RESULT: " CR TYPE CR F.DUMP CR
;

: FTANH (F r1 -- r2 ) \ 12.6.2.1626 FTANH
   \G r2 is the hyperbolic tangent of r1.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FTANH-INPUT: " CR TYPE CR F.DUMP CR
   FHYPEXP FOVER FOVER F+ FP> F- >FP F/
   \DEBUG S" FTANH-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
: FASINH (F r1 -- r2 ) \ 12.6.2.1487 FASINH
   \G r2 is the floating-point value whose hyperbolic sine is r1.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FASINH-INPUT: " CR TYPE CR F.DUMP CR
   FDUP FDUP F* FONE F+ FSQRT
   F+ FLN
   \DEBUG S" FASINH-RESULT: " CR TYPE CR F.DUMP CR
;

: FACOSH (F r1 -- r2 ) \ 12.6.2.1477 FACOSH
   \G r2 is the floating-point value whose hyperbolic cosine is r1.
   \G An ambiguous condition exists if r1 is less than one.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FACOSH-INPUT: " CR TYPE CR F.DUMP CR
   FDUP FDUP F* FONE F- FSQRT
   F+ FLN
   \DEBUG S" FACOSH-RESULT: " CR TYPE CR F.DUMP CR
;

: FATANH (F r1 -- r2 ) \ 12.6.2.1491 FATANH
   \G r2 is the floating-point value whose hyperbolic tangent is r1.
   \G An ambiguous condition exists if r1 is outside the range of -1E0 to 1E0.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FATANH-INPUT: " CR TYPE CR F.DUMP CR
   FONE FOVER FABS F< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FONE FOVER F+
   FONE FROT F-
   F/ FLN
   FTWO F/
   \DEBUG S" FATANH-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF
