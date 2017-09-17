\ DEBUG-ON
USER F*-YL*XH  2 CELLS USER-ALLOC
USER F*-YH*XL  2 CELLS USER-ALLOC
USER F*-YH*XH  2 CELLS USER-ALLOC
USER F*-EXP    1 CELLS USER-ALLOC

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

: DAND (S xd1 xd2 -- xd3)
   \G xd3 is the result of bit AND between xd1 and xd2.
   ROT AND
   ROT ROT AND
   SWAP
;

: DINVERT (S xd1 -- xd2)
   \G xd2 is the result of bit INVERT on xd1.
   INVERT SWAP
   INVERT SWAP
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
   EXIT


   2SWAP OR 0<> 1 AND >R  \ S: dm     R: stiky
   OVER 1 AND R> AND S>D
   \DEBUG S" (F*RN)-CORR: " CR TYPE CR H.S CR
   2>R 0 2R> 0
   \DEBUG S" (F*RN)-ROUND: " CR TYPE CR H.S CR
   T+
   DUP 0<>  IF  T2/ 1  ELSE  0  THEN
   NIP
;
\DEBUG-OFF


: ~~~(F*RN) (S udlow udhigh -- ud exp-corr )
   \G Round exact multiplication result to nearest.
   \G exp-corr is exponent correction if required.
   2SWAP OR 0<> 1 AND >R  \ S: dm     R: stiky
   OVER 1 AND R> AND S>D
   \DEBUG S" (F*RN)-CORR: " CR TYPE CR H.S CR
   2>R 0 2R> 0
   \DEBUG S" (F*RN)-ROUND: " CR TYPE CR H.S CR
   T+
   DUP 0<>  IF  T2/ 1  ELSE  0  THEN
   NIP
;

: (F*EXACT) (S ud1 ud2 -- udlow udhigh )
   \G Perform exact multiplication of unsigned double values.
   \DEBUG S" (F*EXACT)-INPUT: " CR TYPE CR H.S CR
   2DUP 2>R               \ S: yl yh xl xh     R: xl xh
   ROT SWAP OVER          \ S: yl xl yh xh yh
   UM* F*-YH*XH 2!
   UM* F*-YH*XL 2!
   2R>                    \ S: yl xl xh
   ROT SWAP OVER          \ S: xl yl xh yl
   UM* F*-YL*XH 2!
   UM* 0
   0 F*-YL*XH 2@
   0 F*-YH*XL 2@
   0
   0 F*-YH*XH 2@
   \DEBUG S" (F*EXACT)-PART: " CR TYPE CR H.S CR
   T+ T+ T+
   \DEBUG S" (F*EXACT)-SUM: " CR TYPE CR H.S CR
;

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

: (F*EXP) (S -- exp ) (F r1 r2 -- r1 r2 )
   \G Compute the exponent for float multiplication result.
   'FPY FPE@ FPFLAGS>EXP
   'FPX FPE@ FPFLAGS>EXP
   + 1+
;

: (F*/SIGN) (S -- nflags ) (F r1 r2 -- r1 r2 )
   \G Compute the sign mask for float multiplication or division result.
   'FPY FPE@ 'FPX FPE@ XOR
   FPV-SIGN-MASK AND
;

: (F*/RESULT) (S ud exp sign -- ud nflags )
   \G Build result representation for the F* and F/.
   \DEBUG S" (F*/RESULT)-INPUT: " CR TYPE CR H.S CR
   OVER FPV-EXP-MAX >  IF  >R DROP 2DROP R> FINF EXIT  THEN
   OVER FPV-EXP-MIN <  IF  2SWAP 2DROP NIP 0. ROT FPV-ZERO-MASK OR EXIT  THEN
   SWAP
   FPV-EXP-MASK AND
   OR
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
   (F*EXACT)
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
