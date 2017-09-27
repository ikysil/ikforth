64 CONSTANT FSQRT-ITERATIONS-DEFAULT

: FSQRT-APPROX (F r1 -- r2 )
   \G r2 is the initial approximation of square root of r1.
   'FPX FPE@ DUP
   FPFLAGS>EXP 2/ FPV-EXP-MASK AND
   SWAP FPV-EXP-MASK INVERT AND OR
   'FPX FPE!
;

: FSQRT-NEWTON-STEP (F r1 r2 -- r3 )
   \G Perform step in Newton approximation for a square root.
   \G Calculate next approximation r3 for the square root of
   \G r1 given the previous approximation r2.
   ?FPX0= IF  FNIP EXIT  THEN
   FSWAP FOVER      \ F: r2 r1 r2
   F/ F+
   FPX2/
;

: FSQRT-NEWTON (S +n -- ) (F r1 r2 -- r3 )
   \G Calculate square root of r1 given the initial approximation r2 and number of iterations +n.
   1 ?FPSTACK-OVERFLOW
   BEGIN
      DUP 0>
      ?FPX0= INVERT \ stop iterations if approximation eq. zero
      AND
   WHILE
      FOVER FSWAP
      \DEBUG S" FSQRT-NEWTON-A1: " CR TYPE CR F.DUMP CR
      FSQRT-NEWTON-STEP
      \DEBUG S" FSQRT-NEWTON-A2: " CR TYPE CR F.DUMP CR
      1-
   REPEAT
   DROP
   FNIP
   \DEBUG S" FSQRT-NEWTON-B: " CR TYPE CR F.DUMP CR
;

: FSQRT (F r1 -- r2 ) \ 12.6.2.1618 FSQRT
   \G r2 is the square root of r1. An ambiguous condition exists if r1 is less than zero.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0=    IF  EXIT  THEN
   ?FPX0<    IF  FPX-NAN! EXIT  THEN
   ?FPX-INF  IF  EXIT  THEN
   FSQRT-ITERATIONS-DEFAULT FDUP FSQRT-APPROX FSQRT-NEWTON
;
