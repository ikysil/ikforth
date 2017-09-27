\ DEBUG-ON
: F**-INTEGER (S ud -- ) (F r1 -- r2 )
   \G Raise r1 to the integer power ud.
   \DEBUG CR ." F**-INTEGER-INPUT: " CR 2DUP H.8 H.8 CR F.DUMP CR
   2DUP D0=  IF  2DROP FDROP FONE EXIT  THEN
   OVER 1 AND   IF  FDUP  ELSE  FONE  THEN
   BEGIN
      2DUP OR 0<>
   WHILE
      FSWAP FDUP F* FSWAP
      1 DRSHIFT
      OVER 1 AND   IF  FOVER F*  THEN
   REPEAT
   2DROP
   FNIP
   \DEBUG CR ." F**-INTEGER-RESULT: " CR F.DUMP CR
;

: F** (F r1 r2 -- r3 )  \ 12.6.2.1415 F**
   \G Raise r1 to the power r2, giving the product r3.
   2 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   \DEBUG CR ." F**-INPUT: " CR F.DUMP CR
   ?FPX0<  IF
      FNEGATE
      RECURSE
      FONE FSWAP F/
      \DEBUG CR ." F**-RESULT: " CR F.DUMP CR
      EXIT
   THEN
   FDUP FDUP FLOOR F=  IF
      0
      BEGIN
         ['] F>D CATCH
         EXC-OUT-OF-RANGE =
      WHILE
         FPX2/
         1+
      REPEAT
      F**-INTEGER
      0 ?DO
         FDUP F*
      LOOP
      \DEBUG CR ." F**-RESULT: " CR F.DUMP CR
      EXIT
   THEN
   FOVER F0= IF
      FNIP
      FDUP F0= IF
         FDROP
         FONE
      ELSE
         F0< IF
            EXC-FLOAT-DIVISION-BY-ZERO THROW
         ELSE
            FZERO
         THEN
      THEN
   ELSE
      FDUP F0= IF
         FDROP FDROP
         FONE
      ELSE
         FSWAP
         FABS FLN F* FEXP
      THEN
   THEN
   \DEBUG CR ." F**-RESULT: " CR F.DUMP CR
;
\DEBUG-OFF
