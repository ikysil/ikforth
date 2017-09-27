\ DEBUG-ON
: REPRESENT-EXP (S -- n) (F r -- r')
   \G Scale the value r to lay in range [0.1, 1.0) and return decimal exponent n.
   ?FPX0= INVERT
   0 SWAP
   \ S: exp(=0) flag
   BEGIN
      0<>
   WHILE
      FDUP FONE F< INVERT IF
         FTEN F/
         1
      ELSE
         FDUP 0.1E F< IF
            FTEN F*
            -1
         ELSE
            0
         THEN
      THEN
      \ S: exp dexp
      DUP >R + R>
      \ S: exp' dexp
   REPEAT
;

: REPRESENT (S c-addr u -- n flag1 flag2 ) (F r -- ) \ 12.6.1.2143 REPRESENT
   \G At c-addr, place the character-string external representation of the
   \G significand of the floating-point number r. Return the decimal-base exponent
   \G as n, the sign as flag1 and "valid result" as flag2. The character string
   \G shall consist of the u most significant digits of the significand represented
   \G as a decimal fraction with the implied decimal point to the left of the first
   \G digit, and the first digit zero only if all digits are zero. The significand
   \G is rounded to u digits following the "round to nearest" rule; n is adjusted,
   \G if necessary, to correspond to the rounded magnitude of the significand. If
   \G flag2 is true then r was in the implementation-defined range of
   \G floating-point numbers. If flag1 is true then r is negative.
   \G
   \G An ambiguous condition exists if the value of BASE is not decimal ten.
   \G
   \G When flag2 is false, n and flag1 are implementation defined, as are the
   \G contents of c-addr. Under these circumstances, the string at c-addr shall
   \G consist of graphic characters.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   ?DECIMAL INVERT  IF  EXC-INVALID-FLOAT-BASE THROW  THEN
   \DEBUG S" REPRESENT-INPUT: " CR TYPE CR F.DUMP CR
   2DUP BL FILL
   ?FPX-NAN  IF
      S" NaN" 2SWAP ROT MIN MOVE
      0 FALSE FALSE
      FDROP
      EXIT
   THEN
   ?FPX-INF  IF
      ?FPX0<  IF  S" -INF"  ELSE  S" +INF"  THEN
      2SWAP ROT MIN MOVE
      0 ?FPX0< FALSE
      FDROP
      EXIT
   THEN
   MAX-REPRESENT-DIGITS MIN
   2DUP '0' FILL
   'FPX FPE@ ?FPV-NEGATIVE >R
   ?FPX0=  IF
      DROP '0' SWAP C!
      1
      R>
      TRUE
      FDROP
      EXIT
   THEN
   FABS
   REPRESENT-EXP
   \DEBUG S" REPRESENT-EXP: " CR TYPE CR H.S CR
   >R
   FONE DUP 0  ?DO  FTEN F*  LOOP  F*
   \DEBUG S" REPRESENT-MAN1: " CR TYPE CR F.DUMP CR
   FROUND F>D
   \DEBUG S" REPRESENT-MAN2: " CR TYPE CR H.S CR
   \DEBUG S" REPRESENT-BUF: " CR TYPE CR 2DUP TYPE CR
   <# #S #>
   \ S: c-addr u' hld-addr hld-u
   \DEBUG S" REPRESENT-HLD: " CR TYPE CR 2DUP TYPE CR H.S CR
   2SWAP ROT 2DUP
   \ S: hld-addr c-addr u' hld-u u' hld-u
   SWAP - R> + >R
   MIN 1 MAX MOVE
   R> R> TRUE
   \DEBUG S" REPRESENT-RESULT: " CR TYPE CR H.S CR
;
\DEBUG-OFF
