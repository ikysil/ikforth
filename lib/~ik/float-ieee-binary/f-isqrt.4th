16  CONSTANT  FISQRT-ITERATIONS-DEFAULT


: FISQRT-NEWTON-STEP (F r1 r2 -- r3 )
   \G Perform step in Newton approximation for an inverse square root.
   \G Calculate next approximation r3 for an inverse square root of
   \G r1 given the previous approximation r2.
   ?FPX0=  IF  FNIP EXIT  THEN
   \ r3 = r2 * (3 - r1 * r2**2) / 2
   FSWAP FOVER F* FOVER F*   \ F: r2 r1*r2*r2
   [ -3. D>F ] FLITERAL F+   \ F: r2 r1*r2*r2-3
   F* FNEGATE
   FTWO F/
;


: FISQRT-APPROX (F r1 -- r2 )
   \G r2 is the initial approximation of inverse square root of r1.
   'FPX FPE@ DUP
   FPFLAGS>EXP 2/ FPV-EXP-MASK AND
   SWAP FPV-EXP-MASK INVERT AND OR
   'FPX FPE!
   FONE FSWAP F/
;


: FISQRT (F r1 -- r2 )
   \G r2 is the inverse square root of r1. An ambiguous condition exists if r1 is less than zero.
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0=    IF  FPX-INF! EXIT  THEN
   ?FPX0<    IF  FPX-NAN! EXIT  THEN
   ?FPX-INF  IF  FDROP FZERO EXIT  THEN
   FDUP FISQRT-APPROX
   FISQRT-ITERATIONS-DEFAULT ['] FISQRT-NEWTON-STEP FNEWTON
;


[UNDEFINED] FSQRT [IF]
: FSQRT (F r1 -- r2 ) \ 12.6.2.1618 FSQRT
   \G r2 is the square root of r1. An ambiguous condition exists if r1 is less than zero.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0=    IF  EXIT  THEN
   ?FPX0<    IF  FPX-NAN! EXIT  THEN
   ?FPX-INF  IF  EXIT  THEN
   FDUP FISQRT F*
;
[THEN]
