USER >FLOAT-M-SIGN 1 CELLS USER-ALLOC

: >FLOAT-PARSE-EXPONENT (S c-addr u -- exp-sign udexp c-addr' u')
   \G Parse exponent.
   \G udexp - usigned exponent value
   \G exp-sign - sign of the exponent (1/0/-1), 0 if exponent value is absent
   DUP 1 < IF  2>R 0 0. 2R> EXIT  THEN
   OVER C@ CASE
      'D' OF  1 /STRING  ENDOF
      'd' OF  1 /STRING  ENDOF
      'E' OF  1 /STRING  ENDOF
      'e' OF  1 /STRING  ENDOF
   ENDCASE
   DUP 0> IF
      OVER C@ CASE
         '+' OF  1 /STRING  1  ENDOF
         '-' OF  1 /STRING -1  ENDOF
         >R 1 R>
      ENDCASE
   ELSE
      0
   THEN
   -ROT
   \ S: exp-sign c-addr" u"
   \DEBUG S" >FLOAT-PARSE-EXPONENT-A: " CR TYPE CR H.S CR
   0. 2SWAP
   \ S: exp-sign 0 0 c-addr" u"
   \DEBUG S" >FLOAT-PARSE-EXPONENT-B: " CR TYPE CR H.S CR
   DUP 0> IF  >NUMBER  THEN
   \ S: exp-sign udexp c-addr' u'
   \DEBUG S" >FLOAT-PARSE-EXPONENT-C: " CR TYPE CR H.S CR
;

: >FLOAT-FIX-EXPONENT (S +exp-corr exp-sign udexp -- ) (F r -- r')
   \G Restore scale using unsigned exponent value udexp,
   \G exponent sign exp-sign (1/0/-1), and correction +exp-corr.
   \G exp-corr is the number of the positions after decimal dot.
   \DEBUG S" >FLOAT-FIX-EXPONENT-A: " CR TYPE CR H.S CR F.DUMP CR
   2DUP FPV-EXP-MAX S>D DU< INVERT IF  EXC-FLOAT-OUT-OF-RANGE THROW  THEN
   D>S
   \ S: +exp-corr exp-sign uexp
   \DEBUG S" >FLOAT-FIX-EXPONENT-B: " CR TYPE CR H.S CR F.DUMP CR
   * SWAP -
   DUP 0= IF  DROP EXIT  THEN
   DUP 0< IF  ['] F/  ELSE  ['] F*  THEN SWAP
   ABS
   FTEN FSWAP
   \ S: op-xt abs(exp)      F: 10. ud
   \DEBUG S" >FLOAT-FIX-EXPONENT-C: " CR TYPE CR H.S CR F.DUMP CR
   BEGIN
      DUP 0>
   WHILE
      FOVER
      OVER EXECUTE
      \DEBUG S" >FLOAT-FIX-EXPONENT-D: " CR TYPE CR H.S CR F.DUMP CR
      1-
   REPEAT
   \ S: op-xt 0             F: 10. (fra+int)*10**exp
   2DROP
   FNIP
;

: ?DECIMAL (S -- flag )
   \G flag is true only if current BASE is DECIMAL
   BASE @ D# 10 =
;

USER >FLOAT-VALUE      2 CELLS USER-ALLOC
USER >FLOAT-INT-DIGITS 1 CELLS USER-ALLOC
USER >FLOAT-FRA-DIGITS 1 CELLS USER-ALLOC
USER >FLOAT-FRA?       1 CELLS USER-ALLOC

: >FLOAT-RESET (S -- )
   0. >FLOAT-VALUE 2!
   0 >FLOAT-INT-DIGITS !
   0 >FLOAT-FRA-DIGITS !
   FALSE >FLOAT-FRA? !
;

: >FLOAT-COUNT-DIGIT (S -- )
   1
   >FLOAT-FRA? @ IF  >FLOAT-FRA-DIGITS  ELSE  >FLOAT-INT-DIGITS  THEN
   +!
;

\ DEBUG-ON
: >FLOAT-PARSE-MANTISSA (S c-addr u -- c-addr' u' flag)
   \G Attempt to parse mantissa.
   \G flag is true if format was correct
   DUP 0= IF  FALSE EXIT  THEN
   \DEBUG S" >FLOAT-PARSE-MANTISSA-A: " CR TYPE CR H.S CR
   BEGIN
     2DUP
     0>
     DUP IF
        SWAP C@
        DUP D# 10 >DIGIT -1 >
        SWAP '.' = OR
        AND
     ELSE
        NIP
     THEN
     \DEBUG S" >FLOAT-PARSE-MANTISSA-B: " CR TYPE CR H.S CR
   WHILE
     OVER C@
     DUP D# 10 >DIGIT DUP -1 > IF
        \DEBUG S" >FLOAT-PARSE-MANTISSA-C: " CR TYPE CR H.S CR
        >FLOAT-VALUE 2@
        \DEBUG S" >FLOAT-PARSE-MANTISSA-D: " CR TYPE CR H.S CR
        DUP H# E0000000 AND 0= IF
           D# 10 UT* DROP
           ROT S>D D+
           >FLOAT-VALUE 2!
           >FLOAT-COUNT-DIGIT
        ELSE
           2DROP DROP
        THEN
        \DEBUG S" >FLOAT-PARSE-MANTISSA-E: " CR TYPE CR H.S CR
     ELSE
        DROP
     THEN
     DUP '.' = IF
        >FLOAT-FRA? @ IF  FALSE EXIT  THEN
        TRUE >FLOAT-FRA? !
     THEN
     DROP
     1 /STRING
     \DEBUG S" >FLOAT-PARSE-MANTISSA-F: " CR TYPE CR H.S CR
   REPEAT
   >FLOAT-INT-DIGITS @
   >FLOAT-FRA-DIGITS @
   \DEBUG S" >FLOAT-PARSE-MANTISSA-G: " CR TYPE CR H.S CR
   + 0<>
;
\DEBUG-OFF

\ DEBUG-ON
: >FLOAT (S c-addr u -- true | false ) (F -- r | ~ ) \ 12.6.1.0558 >FLOAT
   \G An attempt is made to convert the string specified by c-addr and u
   \G to internal floating-point representation. If the string represents
   \G a valid floating-point number in the syntax below, its value r and true are returned.
   \G If the string does not represent a valid floating-point number only false is returned.
   \G
   \G A string of blanks should be treated as a special case representing zero.
   \G
   \G The syntax of a convertible string
   \G :=	<significand>[<exponent>]
   \G <significand> := [<sign>]{<digits>[.<digits0>] | .<digits> }
   \G <exponent> := <marker><digits0>
   \G <marker> := {<e-form> | <sign-form>}
   \G <e-form> := <e-char>[<sign-form>]
   \G <sign-form> :=	{ + | - }
   \G <e-char> := { D | d | E | e }
   >FLOAT-RESET
   ?DECIMAL INVERT IF  EXC-INVALID-FLOAT-BASE THROW  THEN

   2DUP
   SKIP-BLANK
   DUP 0=
   IF  2DROP 2DROP FZERO TRUE EXIT  THEN

   2OVER D= INVERT
   IF  2DROP FALSE EXIT  THEN

   OVER C@ CASE
      '+' OF   0 >FLOAT-M-SIGN ! 1 /STRING  ENDOF
      '-' OF  -1 >FLOAT-M-SIGN ! 1 /STRING  ENDOF
      0 >FLOAT-M-SIGN !
   ENDCASE

   \ S: c-addr2 u2
   >FLOAT-PARSE-MANTISSA
   \ S: c-addr2 u2 flag
   \DEBUG S" >FLOAT-A: " CR TYPE CR H.S CR
   INVERT IF  2DROP FALSE EXIT  THEN

   \ S: c-addr2 u2
   \DEBUG S" >FLOAT-B: " CR TYPE CR H.S CR
   >FLOAT-PARSE-EXPONENT
   \ S: exp-sign udexp c-addr4 u4
   \DEBUG S" >FLOAT-C: " CR TYPE CR H.S CR
   DUP 0<> IF  5 NDROP FALSE EXIT  THEN

   2DROP

   >FLOAT-VALUE 2@ D>F
   \ S:                F: ud
   \DEBUG S" >FLOAT-D: " CR TYPE CR H.S CR F.DUMP CR

   ROT >FLOAT-FRA-DIGITS @ SWAP 2SWAP
   \ S: +exp-corr exp-sign udexp
   \DEBUG S" >FLOAT-E: " CR TYPE CR H.S CR F.DUMP CR
   >FLOAT-FIX-EXPONENT

   >FLOAT-M-SIGN @ 0< IF  FNEGATE  THEN
   TRUE
   \ S: TRUE           F: ud'
   \DEBUG S" >FLOAT-F: " CR TYPE CR H.S CR F.DUMP CR
;
\DEBUG-OFF
