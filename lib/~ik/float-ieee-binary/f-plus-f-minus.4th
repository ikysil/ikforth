\ DEBUG-ON

: (F+EXTRACT) (S -- t1 t2 e1 e2 ) (F r1 r2 -- r1 r2 )
   \G Extract the mantissa of the two top items on the FP stack and sign-extend to triple-cell values.
   \G e1 is exponent of r1 and e2 is exponent of r2.
   'FPY FPM@ 0 ?FPY0<  IF  TNEGATE  THEN
   'FPX FPM@ 0 ?FPX0<  IF  TNEGATE  THEN
   'FPY FPE@ FPFLAGS>EXP
   'FPX FPE@ FPFLAGS>EXP
;


: (F+ORDER) (S t1 t2 e1 e2 -- t1' t2' +diffexp )
   \G Prepare operands for add/subtract operation.
   \G Swap t1 and t2 if (e1-e2) < 0, +dexp is the absolute value of diffexp.
   - DUP 0<  IF  NEGATE >R 3SWAP R>  THEN
;


16                     CONSTANT  /F+GUARDBITS
1 /F+GUARDBITS LSHIFT  CONSTANT  F+EVENBIT
F+EVENBIT  1 RSHIFT    CONSTANT  F+GUARDBIT
F+GUARDBIT 1 RSHIFT    CONSTANT  F+RBIT
F+RBIT     1 RSHIFT    CONSTANT  F+SBIT
/F+GUARDBITS 3 -       CONSTANT  /F+GRSSHIFT
F+RBIT 1-              CONSTANT  F+STICKYBITS
F+GUARDBIT F+RBIT OR
F+RBIT 1 RSHIFT OR     CONSTANT  F+GRSBITS


\ DEBUG-ON
: (F+MALIGN) (S t +diffexp -- t' )
   \G Align mantissa represented as triple-cell value t by +diffexp positions.
   \G Preserve sign!
   \DEBUG CR ." (F+MALIGN)-INPUT:  " DUP . >R 3DUP H.8 H.8 H.8 R> CR
   0 MAX TRIPLE-BITS MIN
   DUP 0=               IF  DROP EXIT  THEN
   >R 3DUP T0= R> SWAP  IF  DROP EXIT  THEN
   \DEBUG CR ." (F+MALIGN)-LOOP:   " DUP . >R 3DUP H.8 H.8 H.8 R> CR
   0 SWAP
   0  ?DO              \ S: t'' sbit
      >R ROT DUP
      F+SBIT AND >R -ROT
      T2/
      R> R> OR
   LOOP
   0<>  IF
      ROT F+SBIT OR -ROT
   THEN
   \DEBUG CR ." (F+MALIGN)-RESULT: " 3DUP H.8 H.8 H.8 CR
;
\DEBUG-OFF


: (F+GD+) (S t -- t' )
   \G Add guard bits - shift left for a predefined amount.
   /F+GUARDBITS 0  ?DO  T2*  LOOP
;


: (F+GD-) (S t -- t' )
   \G Remove guard bits - shift right for a predefined amount.
   /F+GUARDBITS 0  ?DO  T2/  LOOP
;


: ~~~(F+RN) (S t -- t')
   \G Round exact addition result to nearest.
   EXIT
   \DEBUG S" (F+RN)-INPUT: " CR TYPE CR H.S CR
   ROT DUP >R -ROT           \ S: t           R: tlo
   R@ F+GUARDBIT   AND 0<>   \ S: t g         R: tlo
   R@ F+EVENBIT    AND 0<>   \ S: t g e       R: tlo
   R@ F+STICKYBITS AND 0<>   \ S: t g e s     R: tlo
   \DEBUG S" (F+RN)-BITS: " CR TYPE CR H.S CR
   R> DROP
   AND OR F+EVENBIT AND
   \DEBUG S" (F+RN)-CORR: " CR TYPE CR H.S CR
   S>T T+
   \DEBUG S" (F+RN)-RESULT: " CR TYPE CR H.S CR
;


: (F+GRSE) (S u -- grs e)
   \G Compute grs and e bits for result of F+/F- based on lowest cell of exact result.
   >R
   R@ F+STICKYBITS AND 0<> F+SBIT AND    \ S: sbit             R: u
   R@ F+RBIT       AND                   \ S: sbit rbit        R: u
   R@ F+GUARDBIT   AND                   \ S: sbit rbit gbit   R: u
   OR OR /F+GRSSHIFT RSHIFT              \ S: grs              R: u
   R> F+EVENBIT AND                      \ S: grs e
;


: (F+CORR) (S grs e -- n)
   \G Compute correction based on grs and e bits.
   OVER 4 <  IF
      2DROP 0 EXIT
   THEN
   OVER 4 =  IF
      NIP
      0<> F+EVENBIT AND
      EXIT
   THEN
   2DROP
   F+EVENBIT
;


\ DEBUG-ON
: (F+RN) (S t -- t')
   \G Round exact addition result to nearest.
   \DEBUG CR ." (F+RN)-INPUT:  " 3DUP H.8 H.8 H.8 CR
   ROT DUP >R -ROT           \ S: t                  R: tlo
   R> (F+GRSE)               \ S: t grs e
   \DEBUG CR ." (F+RN)-BITS:   " 2DUP H.8 SPACE H.8 CR
   (F+CORR)
   \DEBUG CR ." (F+RN)-CORR:   " DUP H.8 CR
   S>T T+
   \DEBUG CR ." (F+RN)-RESULT: " 3DUP H.8 H.8 H.8 CR
;
\DEBUG-OFF


\ DEBUG-ON
: (F+RALIGN) (S ut -- ut' expcorr)
   \G Align unsigned exact result so that the most significant bit of result is aligned to the left.
   \DEBUG CR ." (F+RALIGN)-INPUT:  " 3DUP H.8 H.8 H.8 CR
   3DUP T0=  IF  0 EXIT  THEN
   0 >R
   DUP F+EVENBIT AND 0<>  IF
      T2/
      R> 1+ >R
   THEN
   BEGIN
      DUP F+GUARDBIT AND 0=
   WHILE
      T2*
      R> 1- >R
   REPEAT
   R>
   \DEBUG CR ." (F+RALIGN)-RESULT: " DUP . >R 3DUP H.8 H.8 H.8 R> CR
;
\DEBUG-OFF


\ DEBUG-ON
: F+ (F r1 r2 -- r3 ) \ 12.6.1.1420 F+
   (G Add r1 to r2 giving the sum r3.)
   2 ?FPSTACK-UNDERFLOW
   \DEBUG CR ." F+-INPUT: " CR F.DUMP CR
   ?FP2OP-NAN  IF  EXIT  THEN
   ?FPX-INF ?FPY-INF AND  IF
      ?FPX0< ?FPY0< XOR
      FDROP
      IF  FPX-NAN!  THEN
      EXIT
   THEN
   ?FPX-INF ?FPY-INF XOR  IF
      ?FPX-INF  IF  FSWAP  THEN
      FDROP EXIT
   THEN
   ?FPX0= ?FPY0= AND  IF
      ?FPX0< ?FPY0< AND
      FDROP FDROP
      FZERO  IF  FNEGATE  THEN
      EXIT
   THEN
   ?FPX0=  IF  FDROP EXIT  THEN
   ?FPY0=  IF  FNIP  EXIT  THEN
   (F+EXTRACT)
   \DEBUG CR ." F+-EXTRACT: " 2DUP . . 2>R 3>R 3DUP H.8 H.8 H.8 SPACE 3R> 3DUP H.8 H.8 H.8 2R> CR
   2DUP MAX >R
   (F+ORDER)
   >R
   \DEBUG CR ." F+-ORDER:   " 3>R 3DUP H.8 H.8 H.8 SPACE 3R> 3DUP H.8 H.8 H.8 CR
   3SWAP (F+GD+)
   3SWAP (F+GD+)
   \DEBUG CR ." F+-GUARD:   " 3>R 3DUP H.8 H.8 H.8 SPACE 3R> 3DUP H.8 H.8 H.8 CR
   R>
   (F+MALIGN)
   \DEBUG CR ." F+-MALIGN:  " 3>R 3DUP H.8 H.8 H.8 SPACE 3R> 3DUP H.8 H.8 H.8 CR
   T+
   \DEBUG CR ." F+-EXACT:   " 3DUP H.8 H.8 H.8 CR
   DUP FPV-SIGN-MASK AND DUP R> SWAP >R >R
   0<>  IF  TNEGATE  THEN
   (F+RALIGN)
   R> + >R
   BEGIN
      (F+RN)
      (F+RALIGN)
      DUP 0<>
   WHILE
      R> + >R
   REPEAT
   DROP
   \DEBUG CR ." F+-ROUND:   " 3DUP H.8 H.8 H.8 CR
   (F+GD-)
   \DEBUG CR ." F+-SUM:     " 3DUP H.8 H.8 H.8 CR
   FDROP
   ABORT" MUST BE ZERO IN F+!"
   R> R> SWAP
   FPFLAGS>EXP FPV-EXP-MASK AND OR
   \DEBUG CR ." F+-RESULT:  " 3DUP H.8 SPACE H.8 H.8 CR
   'FPX FPE!
   'FPX FPM!
   FPX-NORMALIZE
   \DEBUG CR ." F+-RESULT: " CR F.DUMP CR
;
\DEBUG-OFF


: F- (F r1 r2 -- r3 ) \ 12.6.1.1425 F-
   (G Subtract r2 from r1, giving r3.)
   ?FP2OP-NAN  IF  EXIT  THEN
   FNEGATE F+
;
