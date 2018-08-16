\ DEBUG-ON

HEX
8000000000000000.  2CONSTANT  F*GBIT
F*GBIT 1 RSHIFT    2CONSTANT  F*RBIT
F*RBIT 1 RSHIFT    2CONSTANT  F*SBIT
F*RBIT 1. D-       2CONSTANT  F*STICKYBITS
1                   CONSTANT  F*EBIT
DECIMAL
CELL-BITS 3 -       CONSTANT  /F*GRSSHIFT

: DRSHIFT (S ud1 u -- ud2)
   \G Perform a logic right shift of u bit-places on ud1, giving ud2.
   DUP 0=  IF  DROP EXIT  THEN
   DOUBLE-BITS OVER U<  IF  DROP 2DROP 0 S>D EXIT  THEN
   CELL-BITS   OVER U<  IF  >R NIP 0 R> CELL-BITS -  THEN
   >R
   R@ /RSHIFT          \ S: lo1 hi2 lo1'
   ROT R> /RSHIFT      \ S: hi2 lo1' lo2 lo'
   DROP OR SWAP
;


: (F*GRS) (S ud -- grs)
   \G Compute grs bits for result of F* based on lowest double-cell of exact result.
   2>R
   2R@ F*STICKYBITS DAND OR 0<> DUP F*SBIT DAND NIP    \ S: sbit             R: ud
   2R@ F*RBIT       DAND NIP                   \ S: sbit rbit        R: ud
   2R@ F*GBIT       DAND NIP                   \ S: sbit rbit gbit   R: ud
   OR OR                                       \ S: grs              R: ud
   2R> 2DROP
   /F*GRSSHIFT RSHIFT
;


: (F*CORR) (S grs e -- n)
   \G Compute correction based on grs and e bits.
   OVER 4 <  IF
      2DROP 0 EXIT
   THEN
   OVER 4 =  IF
      NIP
      0<> F*EBIT AND
      EXIT
   THEN
   2DROP
   F*EBIT
;


\ DEBUG-ON
: (F*RN) (S udlow udhigh -- ud exp-corr )
   \G Round exact multiplication result to nearest.
   \G exp-corr is exponent correction if required.
   \DEBUG CR ." (F*RN)-INPUT:  " 2OVER 2OVER H.8 H.8 SPACE H.8 H.8 CR
   2SWAP
   (F*GRS)
   >R OVER F*EBIT AND R> SWAP   \ S: udhigh grs e
   \DEBUG CR ." (F*RN)-BITS:   " 2DUP H.8 SPACE H.8 SPACE 2OVER H.8 H.8 CR
   (F*CORR)
   \DEBUG CR ." (F*RN)-CORR:   " DUP H.8 CR
   >R 0 R> S>T
   T+
   DUP 0<>  IF  T2/ 1  ELSE  0  THEN
   NIP
   \DEBUG CR ." (F*RN)-RESULT: " 3DUP H.8 SPACE H.8 H.8 CR
;
\DEBUG-OFF


: (F*NORMALIZE) (S t1 -- t1' exp-corr )
   \G Normalize exact multiplication result - most significant 3 cells.
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

: (F*/RESULT) (S ud exp sign -- ud nflags )
   \G Build result representation for the F* and F/.
   \DEBUG S" (F*/RESULT)-INPUT: " CR TYPE CR H.S CR
   FP-RESULT
   \DEBUG S" (F*/RESULT)-RESULT: " CR TYPE CR H.S CR
;

: F* (F r1 r2 -- r3 ) \ 12.6.1.1410 F*
   \G Multiply r1 by r2 giving r3.
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F*-INPUT: " CR TYPE CR F.DUMP CR
   ?FP2OP-NAN  IF  EXIT  THEN
   ?FPX0=  IF
      FSWAP
      F0<  IF  FNEGATE  THEN
      EXIT
   THEN
   ?FPY0=  IF
      F0<  IF  FNEGATE  THEN
      EXIT
   THEN
   ?FPX-INF ?FPY-INF OR  IF
      \DEBUG CR ." F*-INF: " DEPTH . CR
      (F*/SIGN) FDROP 'FPX FPE! FPX-INF! EXIT
   THEN
   (F*/SIGN) >R
   (F*EXP)  >R
   'FPY FPM@ 'FPX FPM@
   UD*
   (F*NORMALIZE)
   \DEBUG S" F*-NORMALIZED: " CR TYPE CR H.S CR
   R> + >R
   (F*RN)
   \DEBUG S" F*-ROUND: " CR TYPE CR H.S CR
   R> + R>
   (F*/RESULT)
   \DEBUG S" F*-RESULT: " CR TYPE CR H.S CR
   'FPY FPE!
   'FPY FPM!
   FDROP
   \DEBUG S" F*-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF
