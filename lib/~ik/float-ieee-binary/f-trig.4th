3.1415926535897932384626433832795E FCONSTANT FPI
FPI FTWO F* FCONSTANT FTWOPI
FPI FTWO F/ FCONSTANT FHALFPI
FHALFPI FTWO F/ FCONSTANT FQUOTERPI

: FSCALE-TRIG (F r1 -- r2)
   \G Scale r1 into range [0, 2*pi)
   1 ?FPSTACK-UNDERFLOW
   FTWOPI FMOD
;

 0.99940307E FCONSTANT FCOS32-C1
-0.49558072E FCONSTANT FCOS32-C2
 0.03679168E FCONSTANT FCOS32-C3

: FCOS32-APPROX (F r1 -- r2 )
   \G computes cosine (r1)
   \G Accurate to about 3.2 decimal digits over the range [0, pi/2].
   \G r1 is in radians.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   \ cos(x)= c1 + x**2(c2 + c3*x**2)
   FDUP F*
   FCOS32-C3    FOVER F*
   FCOS32-C2 F+ FOVER F*
   FCOS32-C1 F+
   FNIP
;

 0.9999932946 FCONSTANT FCOS52-C1
-0.4999124376 FCONSTANT FCOS52-C2
 0.0414877472 FCONSTANT FCOS52-C3
-0.0012712095 FCONSTANT FCOS52-C4

: FCOS52-APPROX (F r1 -- r2 )
   \G computes cosine (r1)
   \G Accurate to about 5.2 decimal digits over the range [0, pi/2].
   \G r1 is in radians.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   \ cos(x)= c1 + x**2(c2 + x**2(c3 + c4*x**2))
   FDUP F*
   FCOS52-C4    FOVER F*
   FCOS52-C3 F+ FOVER F*
   FCOS52-C2 F+ FOVER F*
   FCOS52-C1 F+
   FNIP
;

\ DEBUG-ON
: FCOS (F r1 -- r2 ) \ 12.6.2.1493 FCOS
   \G r2 is the cosine of the radian angle r1.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0= IF
      FDROP FONE
      EXIT
   THEN
   2 ?FPSTACK-OVERFLOW
   FSCALE-TRIG
   FABS
   \DEBUG S" FCOS-A: " CR TYPE CR F.DUMP CR
   FDUP FHALFPI
   \DEBUG S" FCOS-B: " CR TYPE CR H.S CR F.DUMP CR
   F/ FLOOR
   \DEBUG S" FCOS-C: " CR TYPE CR H.S CR F.DUMP CR
   F>D
   D>S
   ['] FCOS52-APPROX SWAP
   \DEBUG S" FCOS-D: " CR TYPE CR H.S CR F.DUMP CR
   CASE
      0 OF
         EXECUTE
      ENDOF
      1 OF
         FPI FSWAP F-
         EXECUTE
         FNEGATE
      ENDOF
      2 OF
         FPI F-
         EXECUTE
         FNEGATE
      ENDOF
      3 OF
         FTWOPI FSWAP F-
         EXECUTE
      ENDOF
      ABORT
   ENDCASE
   \DEBUG S" FCOS-E: " CR TYPE CR H.S CR F.DUMP CR
;
\DEBUG-OFF


: FSIN (F r1 -- r2 ) \ 12.6.2.1614 FSIN
   \G r2 is the sine of the radian angle r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0= IF
      FDROP FZERO
   ELSE
      FHALFPI FSWAP F- FCOS
   THEN
;


: FSINCOS (F r1 -- r2 r3 ) \ 12.6.2.1616 FSINCOS
   \G r2 is the sine of the radian angle r1. r3 is the cosine of the radian angle r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   FDUP FSIN
   FSWAP FCOS
;


\ DEBUG-ON
: FTAN (F r1 -- r2 ) \ 12.6.2.1625 FTAN
   \G r2 is the tangent of the radian angle r1. An ambiguous condition exists if (r1) is zero.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FSINCOS
   \DEBUG S" FTAN-A: " CR TYPE CR F.DUMP CR
   F/
;
\DEBUG-OFF


FPI 6. D>F    F/  FCONSTANT FSIXTHPI
FSIXTHPI FTWO F/  FCONSTANT FTWELFTHPI
FSIXTHPI   FTAN   FCONSTANT FTANSIXTHPI
FTWELFTHPI FTAN   FCONSTANT FTANTWELFTHPI

1.6867629106 FCONSTANT FATAN66-C1
0.4378497304 FCONSTANT FATAN66-C2
1.6867633134 FCONSTANT FATAN66-C3

: FATAN66-APPROX (F r1 -- r2 )
   \G r2 is atan(r1).
   \G Accurate to about 6.6 decimal digits over the range [0, pi/12].
   \G atan(x)= x*(c1 + c2*x**2)/(c3 + x**2)
   FDUP FDUP F*
   FDUP FATAN66-C2 F* FATAN66-C1 F+
   FSWAP FATAN66-C3 F+ F/ F*
;

\ DEBUG-ON
: FATAN66-ZERO-ONE-RANGE (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,1].
   \DEBUG S" FATAN-ZERO-ONE-INPUT: " CR TYPE CR F.DUMP CR
   FTANTWELFTHPI FOVER F< IF
      FDUP  FTANSIXTHPI F-
      FSWAP FTANSIXTHPI F* FONE F+
      F/
      FATAN66-APPROX
      FSIXTHPI F+
   ELSE
      FATAN66-APPROX
   THEN
   \DEBUG S" FATAN-ZERO-ONE-RESULT: " CR TYPE CR F.DUMP CR
;

: FATAN66-POSITIVE (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \DEBUG S" FATAN-POSITIVE-INPUT: " CR TYPE CR F.DUMP CR
   FONE FOVER F< IF
      FONE FSWAP F/
      FATAN66-ZERO-ONE-RANGE
      FHALFPI FSWAP F-
   ELSE
      FATAN66-ZERO-ONE-RANGE
   THEN
   \DEBUG S" FATAN-POSITIVE-RESULT: " CR TYPE CR F.DUMP CR
;

0.596227E  FCONSTANT FATAN-2NDORDER-B

: FATAN-2NDORDER (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \G This is for x in [0, Infinity). When x is negative just use -atan_approx(-x).
   \G atan_approx(x) = (Pi/2)*(b*x + x*x)/(1 + 2*b*x + x*x) where b = 0.596227,
   \G with a maximum approximation error of 0.1620º
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FDUP FDUP F*
   FSWAP FATAN-2NDORDER-B F* FSWAP
   \ F: b*x x*x
   FOVER F+
   \ F: b*x b*x+x*x
   FSWAP FOVER F+
   \ F: b*x+x*x b*x+b*x+x*x
   FONE F+
   F/
   FHALFPI F*
;

17. D>F FSQRT FONE F+ 8. D>F F/
FCONSTANT FATAN-3RDORDER-C
FATAN-3RDORDER-C FONE F+  FCONSTANT FATAN-3RDORDER-CP1

: FATAN-3RDORDER (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \G This is for x in [0, Infinity). When x is negative just use -atan_approx(-x).
   \G atan_approx(x) = (Pi/2)*(c*x + x*x + x*x*x)/(1 + (c+1)*x + (c+1)x*x + x*x*x)
   \G where c = (1 + sqrt(17))/8 and the maximum approximation error is 0.00811º
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FATAN-3RDORDER-C FOVER F*
   FOVER FDUP F* FDUP FP> F+
   FOVER >FP F* F+
   FSWAP
   \ F: (c*x + x*x + x*x*x) x
   FATAN-3RDORDER-CP1 FOVER F*
   FOVER FDUP F* FDUP FP> FATAN-3RDORDER-CP1 F* F+
   FSWAP >FP F* F+
   FONE F+
   \ F: (c*x + x*x + x*x*x) (1 + (c+1)*x + (c+1)x*x + x*x*x)
   F/
   FHALFPI F*
;

: FATAN-FLOAT-RANGE (S xt -- ) (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range (-FLOAT-MAX,+FLOAT-MAX).
   \G xt is the word to calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \DEBUG S" FATAN-FLOAT-RANGE-INPUT: " CR TYPE CR F.DUMP CR
   'FPX FPE@ ?FPV-NEGATIVE IF
      FNEGATE
      EXECUTE
      FNEGATE
   ELSE
      EXECUTE
   THEN
   \DEBUG S" FATAN-FLOAT-RANGE-RESULT: " CR TYPE CR F.DUMP CR
;

: FATAN (F r1 -- r2 ) \ 12.6.2.1488 FATAN
   \G r2 is the principal radian angle whose tangent is r1.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FATAN-INPUT: " CR TYPE CR F.DUMP CR
   \ ['] FATAN66-POSITIVE
   \ ['] FATAN-2NDORDER
   ['] FATAN-3RDORDER
   FATAN-FLOAT-RANGE
   \DEBUG S" FATAN-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
: FASIN (F r1 -- r2 ) \ 12.6.2.1486 FASIN
   \G r2 is the principal radian angle whose sine is r1.
   \G An ambiguous condition exists if | r1 | is greater than one.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FDUP FABS FONE F- F0= IF
      FHALFPI F*
      EXIT
   THEN
   FDUP FDUP F* FONE FSWAP F- FSQRT
   \DEBUG S" FASIN-A: " CR TYPE CR F.DUMP CR
   F/ FATAN
;
\DEBUG-OFF


: FACOS (F r1 -- r2 ) \ 12.6.2.1476 FACOS
   \G r2 is the principal radian angle whose cosine is r1.
   \G An ambiguous condition exists if | r1 | is greater than one.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FASIN FHALFPI FSWAP F-
;


\ DEBUG-ON
: FATAN2 (F r1 r2 -- r3 ) \ 12.6.2.1489 FATAN2
   \G r3 is the principal radian angle (between -π and π) whose tangent is r1/r2.
   \G A system that returns false for "-0E 0E 0E F~" shall return a value
   \G (approximating) -π when r1 = 0E and r2 is negative.
   \G An ambiguous condition exists if r1 and r2 are zero.
   2 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   \DEBUG S" FATAN2-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX0= ?FPY0= AND  IF
      ?FPY0< ?FPX0<
      FDROP FDROP
      IF  FPI  ELSE  FZERO  THEN
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-00: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPX0= IF
      \ r2 = 0
      FDROP F0< FHALFPI
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-2: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPY-INF ?FPX-INF AND  IF
      ?FPY0< ?FPX0<
      FDROP FDROP
      FQUOTERPI
      IF  FHALFPI  ELSE  FZERO  THEN
      F+
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-INF-INF: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPY-INF INVERT ?FPX-INF AND  IF
      ?FPY0< ?FPX0<
      FDROP FDROP
      IF  FPI  ELSE  FZERO  THEN
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-N-INF: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPY-INF ?FPX-INF INVERT AND  IF
      ?FPY0<
      FDROP FDROP
      FHALFPI
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-INF-N: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   FDUP FNEGATE F0< IF
      \ r2 > 0
      F/ FATAN
   ELSE
      \ r2 <= 0
      FOVER FSWAP
      \DEBUG S" FATAN2-C1: " CR TYPE CR F.DUMP CR
      F/ FATAN
      \DEBUG S" FATAN2-C2: " CR TYPE CR F.DUMP CR
      FSWAP
      \DEBUG S" FATAN2-C3: " CR TYPE CR F.DUMP CR
      F0< FPI IF  FNEGATE  THEN
      F+
   THEN
   \DEBUG S" FATAN2-RESULT-2: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF
