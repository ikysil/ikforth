\ DEBUG-ON
USER F*-YL*XH  2 CELLS USER-ALLOC
USER F*-YH*XL  2 CELLS USER-ALLOC
USER F*-YH*XH  2 CELLS USER-ALLOC
USER F*-EXP    1 CELLS USER-ALLOC

: (F*RN) (S udlow udhigh -- ud exp-corr )
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

: (F*RESULT) (S ud exp sign -- ud nflags )
   \G Build result representation for the F*.
   \DEBUG S" (F*RESULT)-INPUT: " CR TYPE CR H.S CR
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
   (F*RESULT)
   \DEBUG S" F*-RESULT: " CR TYPE CR H.S CR
   'FPY FPE!
   'FPY FPM!
   FDROP
   \DEBUG S" F*-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF
