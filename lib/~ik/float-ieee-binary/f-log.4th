\ DEBUG-ON
64  CONSTANT  FLN-ITERATIONS-DEFAULT

: FLN-TAYLOR (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FDUP F0< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   \ calculate y = (r1-1)/(r1+1)
   FDUP  FONE F-
   FSWAP FONE F+ F/
   \ S: +n             F: y
   FZERO FOVER
   FDUP F*
   \ S: +n             F: y sum(=0) y**2
   BEGIN
      DUP 0>
      \ S: n flag         F: y sum y**2
   WHILE
      DUP 1 LSHIFT 1- S>D
      \ S: n  dn*2-1      F: y sum y**2
      FSWAP FOVER F*
      \ S: n  dn*2-1      F: y y**2 sum*y**2
      FONE D>F F/
      \ S: n              F: y y**2 sum*y**2 1/(dn*2-1)
      F+ FSWAP
      \ S: n              F: y sum' y**2
      1-
      \ S: n'             F: y sum' y**2
   REPEAT
   DROP
   \ F: y sum' y**2
   FDROP
   F* FTWO F*
;

: FLN-TAYLOR2 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   \DEBUG S" FLN-TAYLOR2-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX0< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   \ calculate y = (r1-1)/(r1+1)
   FDUP  FONE F-
   \DEBUG S" FLN-TAYLOR2-R-1: " CR TYPE CR F.DUMP CR
   FSWAP FONE F+
   \DEBUG S" FLN-TAYLOR2-R+1: " CR TYPE CR F.DUMP CR
    F/
   \DEBUG S" FLN-TAYLOR2-Y: " CR TYPE CR F.DUMP CR
   \ S: +n             F: y
   FDUP FDUP F* FOVER
   \ S: +n             F: sum(=y) y**2 y**(2i-1)
   1 DO
      \ DEBUG S" FLN-TAYLOR2-STEP: " CR TYPE CR FDEPTH . CR F.DUMP CR
      \ F: sum y**2 y**(2i-1)
      FOVER F* FDUP
      \ F: sum y**2 y**(2i+1) y**(2i+1)
      I 1 LSHIFT 1+
      S>D D>F F/
      \ F: sum y**2 y**(2i+1) y**(2i+1)/(2i+1)
      FROT FROT FP> FP>
      F+ >FP >FP
      \ F: sum+y**(2i+1)/(2i+1) y**2 y**(2i+1)
   LOOP
   \ F: sum' y**2 y**(2n+1)
   FDROP FDROP
   FTWO F*
;

: FLN (F r1 -- r2 ) \ 12.6.2.1553 FLN
   \G r2 is the natural logarithm of r1.
   \G An ambiguous condition exists if r1 is less than or equal to zero.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   \DEBUG S" FLN-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0<    IF  FPX-NAN! EXIT  THEN
   ?FPX-INF  IF  EXIT  THEN
   FREXP  IF
      FLN-ITERATIONS-DEFAULT FLN-TAYLOR2
      2. D>F
      FLN-ITERATIONS-DEFAULT FLN-TAYLOR2
      S>D D>F
      F* F+
   ELSE
      DROP FPX-NAN!
   THEN
   \DEBUG S" FLN-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
64  CONSTANT  FLNP1-ITERATIONS-DEFAULT

: FLNP1-TAYLOR1 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1 + r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FDUP FNEGATE FOVER
   \ F: sum(=r1) -r1 r1
   1 2>R
   BEGIN
      2R> 1 +
      2DUP >
      \ S: n i flag    R:          F: r2(i-1)' r1 r1**(i-1)
   WHILE
      DUP S>D 2SWAP 2>R
      \ S: di          R: n i      F: r2(i-1)' r1 r1**(i-1)
      FOVER F* FDUP
      D>F
      \DEBUG S" FLNP1-TAYLOR-ITER: " CR TYPE CR F.DUMP CR
      F/
      \ S:             R: n i      F: r2(i-1)' r1 r1**(i) (r1**(i))/(i)
      FP> FROT >FP F+
      \ S:             R: n i      F: r1 r1**(i) r2(i-1)'+(r1**(i))/(i)
      FROT FROT
      \ S:             R: n i      F: r2(i)' r1 r1**(i)
   REPEAT
   2DROP
   \ F: r2(i)' r1 r1**(i)
   FDROP FDROP
;

: FLNP1-TAYLOR2 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1 + r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FZERO
   \ S: +n             F: r1 sum(=0)
   BEGIN
      1 -
      DUP 0>
      \ S: n' flag        F: r1 sum
   WHILE
      DUP S>D
      \ S: n' dn'         F: r1 sum
      FOVER FNEGATE F*
      \ S: n' dn'         F: r1 sum*(-r1)
      FONE D>F F/
      \ S: n'             F: r1 sum*(-r1) 1/(dn')
      F+
      \ S: n'             F: r1 sum'
   REPEAT
   DROP
   F*
;

: FLNP1-TAYLOR3 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1+r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   4 ?FPSTACK-OVERFLOW
   \DEBUG S" FLNP1-TAYLOR3-INPUT: " CR TYPE CR H.S CR F.DUMP CR
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   \ calculate y = r1 / (r1+2)
   FDUP FTWO F+ F/
   \ S: +n             F: y
   FZERO FOVER
   FDUP F*
   \ S: +n             F: y sum(=0) y**2
   BEGIN
      1 -
      DUP 0>
      \ S: n' flag        F: y sum y**2
   WHILE
      DUP S>D D2* 1. D-
      \ S: n' dn'*2-1     F: y sum y**2
      FSWAP FOVER F*
      \ S: n' dn'*2-1     F: y y**2 sum*y**2
      FONE D>F F/
      \ S: n'             F: y y**2 sum*y**2 1/(dn'*2-1)
      F+ FSWAP
      \ S: n'             F: y sum' y**2
   REPEAT
   DROP
   \ F: y sum' y**2
   FDROP
   F* FTWO F*
;

: FLNP1-TAYLOR4 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1+r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   4 ?FPSTACK-OVERFLOW
   \DEBUG S" FLNP1-TAYLOR4-INPUT: " CR TYPE CR H.S CR F.DUMP CR
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   \ calculate y = r1 / (r1+2)
   FDUP FTWO F+ F/
   \ S: +n             F: y
   \DEBUG S" FLNP1-TAYLOR4-Y: " CR TYPE CR F.DUMP CR
   \ S: +n             F: y
   FDUP FDUP F* FOVER
   \ S: +n             F: sum(=y) y**2 y**(2i-1)
   1 DO
      \DEBUG S" FLNP1-TAYLOR4-STEP: " CR TYPE CR FDEPTH . CR F.DUMP CR
      \ F: sum y**2 y**(2i-1)
      FOVER F* FDUP
      \ F: sum y**2 y**(2i+1) y**(2i+1)
      I 1 LSHIFT 1+
      S>D D>F F/
      \ F: sum y**2 y**(2i+1) y**(2i+1)/(2i+1)
      FROT FROT FP> FP>
      F+ >FP >FP
      \ F: sum+y**(2i+1)/(2i+1) y**2 y**(2i+1)
   LOOP
   \ F: sum' y**2 y**(2n+1)
   FDROP FDROP
   FTWO F*
;

: FLNP1 (F r1 -- r2 ) \ 12.6.2.1554 FLNP1
   \G r2 is the natural logarithm of the quantity r1 plus one.
   \G An ambiguous condition exists if r1 is less than or equal to negative one.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   \DEBUG S" FLNP1-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX-NAN  IF  EXIT  THEN
   FDUP FMONE F<  IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   ?FPX-INF  IF  EXIT  THEN
   FONE FOVER FABS F- F0<  IF
      \ abs(r1) > 1
      FONE F+ FLN
   ELSE
      \ abs(r1) <= 1
      FLNP1-ITERATIONS-DEFAULT FLNP1-TAYLOR4
   THEN
   \DEBUG S" FLNP1-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
FTEN FLN  FCONSTANT  FLOG-FLNTEN

: FLOG (F r1 -- r2 ) \ 12.6.2.1557 FLOG
   \G r2 is the base-ten logarithm of r1.
   \G An ambiguous condition exists if r1 is less than or equal to zero.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   \DEBUG S" FLOG-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0<    IF  FPX-NAN! EXIT  THEN
   ?FPX-INF  IF  EXIT  THEN
   FLN
   FLOG-FLNTEN F/
   \DEBUG S" FLOG-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF

\ DEBUG-ON
\ ln(10) = ln(2 * 2 * 2 * 1.25) = 3*ln(2) + ln(1.25) = 3*lnp1(1) + lnp1(0.25)
FONE FLNP1  FCONSTANT  FLNTWO
FLNTWO 3.E F* 0.25E FLNP1 F+  FCONSTANT  FALOG-FLNTEN

: FALOG (F r1 -- r2 ) \ 12.6.2.1484 FALOG
   \G Raise ten to the power r1, giving r2.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   \DEBUG S" FALOG-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX-INF  IF
      ?FPX0<  IF  FDROP FZERO  THEN
      EXIT
   THEN
   ?FPX0=  IF
      FDROP
      FONE
   ELSE
      FALOG-FLNTEN F*
      FEXP
   THEN
   \DEBUG S" FALOG-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF
