\DEBUG-ON


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


: (F*+ORDER) (S q1 q2 e1 e2 -- q1' q2' +diffexp )
   \G Prepare operands for add/subtract operation.
   \G Swap q1 and q2 if (e1-e2) < 0, +dexp is the absolute value of diffexp.
   - DUP 0<  IF  NEGATE >R QSWAP R>  THEN
;


: (F*+MALIGN) (S q +diffexp -- q' )
   \G Align mantissa represented as quadruple-cell value q by +diffexp positions.
   \G Preserve sign!
   0 MAX QUADRUPLE-BITS MIN
   DUP 0=  IF  DROP EXIT  THEN
   0  ?DO
      Q2/
   LOOP
;


: F*+ (F r1 r2 r3 -- r4 )
   \G Perform fused multiply-add operation r4 = round(r1 + r2 * r3).
   3 ?FPSTACK-UNDERFLOW
   \DEBUG CR ." F*+-INPUT: " CR DEPTH . CR FDEPTH . CR F.DUMP CR
   'FPY FPM@ 'FPX FPM@
   UD*
   Q2/ Q2/ Q2/ Q2/
   (F*EXP)
   4 + >R
   (F*/SIGN)
   FDROP FDROP
   FPV-NEGATIVE =  IF
      H# 0FFFFFFF AND
      QNEGATE
   THEN
   0 0 'FPX FPM@
   'FPX FPE@ FPFLAGS>EXP
   4 + >R
   Q2/ Q2/ Q2/ Q2/
   ?FPX0<  IF
      H# 0FFFFFFF AND
      QNEGATE
   THEN
   R> R> SWAP
   2DUP MAX >R
   (F*+ORDER)
   0 ?DO
      Q2/
   LOOP
   \DEBUG CR H.S CR
   Q+
   \DEBUG CR H.S CR
   BEGIN
      DUP H# 80000000 AND 0=
   WHILE
      Q2*
      R> 1- >R
   REPEAT
   DUP 0<  IF  QNEGATE FPV-NEGATIVE  ELSE  FPV-POSITIVE  THEN
   R> SWAP
   FP-RESULT
   'FPX FPE!
   'FPX FPM!
   2DROP
   \DEBUG CR ." F*+-RESULT: " CR DEPTH . CR FDEPTH . CR F.DUMP CR
;


\DEBUG-OFF
