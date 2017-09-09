\
\  float.4th
\
\  Copyright (C) 2017 Illya Kysil
\

CR .( Loading FLOAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

REQUIRES" sysdict/x86/486asm.4th"

ONLY FORTH DEFINITIONS

VOCABULARY FLOAT-PRIVATE

ALSO FLOAT-PRIVATE DEFINITIONS

\ private definitions go here

DECIMAL

32       CONSTANT  /FPSTACK
3 CELLS  CONSTANT  B/FLOAT
63       CONSTANT  D>F-EXPONENT
18       CONSTANT  MAX-REPRESENT-DIGITS

<ENV
                   TRUE  CONSTANT  FLOATING
                   TRUE  CONSTANT  FLOATING-EXT
               /FPSTACK  CONSTANT  FLOATING-STACK
   MAX-REPRESENT-DIGITS  CONSTANT  MAX-FLOAT-DIGITS
ENV>

\ floating point representation
\ +0   most  significant cell
\ +1   least significant cell
\ unsigned mantissa is stored as double value, aligned to the most significant bit
\ +2   exponent and flags cell

HEX
\ sign of mantissa
80000000 CONSTANT FPV-SIGN-MASK
\ Not A Number
40000000 CONSTANT FPV-NAN-MASK
\ infinity
20000000 CONSTANT FPV-INF-MASK
\ zero
10000000 CONSTANT FPV-ZERO-MASK

\ exponent value mask
0000FFFF CONSTANT FPV-EXP-MASK
\ sign of exponent
00008000 CONSTANT FPV-EXP-SIGN
\ maximum (unsigned) value of exponent
00007FFF DUP
CONSTANT FPV-EXP-MAX
NEGATE
CONSTANT FPV-EXP-MIN

00000000 CONSTANT FPV-POSITIVE
80000000 CONSTANT FPV-NEGATIVE

80000000 CONSTANT FPV-MSBIT

DECIMAL

2 CELLS CONSTANT FPV-EXP-OFFS

USER FPSTACK
/FPSTACK B/FLOAT * USER-ALLOC
USER FP0                    \ initial floats stack pointer
USER FP  1 CELLS USER-ALLOC \ floats stack pointer

: FP@ (S -- addr ) \ addr is floats stack pointer
   FP @
;

: FP! (S addr -- ) \ addr is floats stack pointer
   FP !
;

:NONAME
   FP0 FP!
;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

DEFER (F IMMEDIATE ' ( IS (F

: FDEPTH (S -- +n ) \ 12.6.1.1497 FDEPTH
   (G +n is the number of values contained on the floating-point stack. )
   (G If the system has an environmental restriction of keeping )
   (G the floating-point numbers on the data stack, +n is the current number )
   (G of possible floating-point values contained on the data stack. )
   FP0 FP@ - B/FLOAT /
;

: ?FPSTACK-OVERFLOW (S +n -- )
   (G Ensure that floats stack may accommodate +n values, throw exception otherwise )
   FDEPTH + /FPSTACK > IF  EXC-FLOAT-STACK-OVERFLOW THROW  THEN
;

: ?FPSTACK-UNDERFLOW (S +n -- )
   (G Ensure that floats stack has at least +n values, throw exception otherwise )
   FDEPTH > IF  EXC-FLOAT-STACK-UNDERFLOW THROW  THEN
;

: 'FPX (S -- addr )
   (G Return address of the top item on floating-point stack)
   FP@
;

: 'FPX-M (S -- addr )
   (G Return address of the mantissa cell of the top item on floating-point stack)
   'FPX
;

: 'FPX-E (S -- addr )
   (G Return address of the exponent cell of the top item on floating-point stack)
   'FPX FPV-EXP-OFFS +
;

: 'FPY (S -- addr )
   (G Return address of the second item on floating-point stack)
   FP@ [ B/FLOAT ] LITERAL +
;

: 'FPY-M (S -- addr )
   (G Return address of the mantissa cell of the second item on floating-point stack)
   'FPY
;

: 'FPY-E (S -- addr )
   (G Return address of the exponent cell of the second item on floating-point stack)
   'FPY FPV-EXP-OFFS +
;

: 'FPZ (S -- addr )
   (G Return address of the third item on floating-point stack)
   FP@ [ 2 B/FLOAT * ] LITERAL +
;

: 'FPZ-M (S -- addr )
   (G Return address of the mantissa cell of the third item on floating-point stack)
   'FPZ
;

: 'FPZ-E (S -- addr )
   (G Return address of the exponent cell of the third item on floating-point stack)
   'FPZ FPV-EXP-OFFS +
;

: FPFLAGS>EXP (S n1 -- n2 )
   (G Extract exponent value from n with sign expansion)
   FPV-EXP-MASK AND
   DUP FPV-EXP-SIGN AND
   IF  FPV-EXP-MASK INVERT OR  THEN
;

: FP> (S -- d n) (F r -- )
   (G Move float value from floating-point stack to data stack)
   1 ?FPSTACK-UNDERFLOW
   'FPX-M 2@
   'FPX-E @
   FP@ B/FLOAT + FP!
;

: >FP (S d n -- ) (F -- r )
   (G Move float value from data stack to floating-point stack)
   1 ?FPSTACK-OVERFLOW
   FP@ B/FLOAT - FP!
   'FPX-E !
   'FPX-M 2!
;

: ?FPX0= (S -- flag ) (F r -- r)
   (G flag is true if and only if r is equal to zero.)
   'FPX-M 2@ OR 0=
;

: ?FPY0= (S -- flag ) (F r1 r2 -- r1 r2)
   (G flag is true if and only if r1 is equal to zero.)
   'FPY-M 2@ OR 0=
;


: ?FPX0< (S -- flag ) (F r -- r)
   \G flag is true if and only if sign of mantissa of r is negative
   'FPX-E @ FPV-SIGN-MASK AND FPV-NEGATIVE =
;

: ?FPY0< (S -- flag ) (F r1 r2 -- r1 r2)
   \G flag is true if and only if sign of mantissa of r1 is negative
   'FPY-E @ FPV-SIGN-MASK AND FPV-NEGATIVE =
;


: ?FPX-NAN (S -- flag ) (F r -- r)
   \G flag is true if and only if r is NAN
   'FPX-E @ FPV-NAN-MASK AND 0<>
;

: ?FPY-NAN (S -- flag ) (F r1 r2 -- r1 r2)
   \G flag is true if and only if r1 is NAN
   'FPY-E @ FPV-NAN-MASK AND 0<>
;


: ?FPX-INF (S -- flag ) (F r -- r)
   \G flag is true if and only if r is INFinity
   'FPX-E @ FPV-INF-MASK AND 0<>
;

: ?FPY-INF (S -- flag ) (F r1 r2 -- r1 r2)
   \G flag is true if and only if r1 is INFinity
   'FPY-E @ FPV-INF-MASK AND 0<>
;


: FNAN (S -- ud n )
   \G Return NAN representation.
   -1.
   FPV-NAN-MASK
   FPV-EXP-MASK OR
;

: FPX-NAN! (S -- ) (F r -- NAN )
   \G Set top of FP stack to NAN.
   FNAN
   'FPX-E !
   'FPX-M 2!
;


: FINF (S sign -- ud n )
   \G Return signed INF representation.
   IF  FPV-NEGATIVE  ELSE  FPV-POSITIVE  THEN
   FPV-INF-MASK OR
   FPV-EXP-MASK OR
   -1.
   ROT
;

: FPX-INF! (S -- ) (F r -- +/-inf )
   \G Set top of FP stack to INFinity with sign copied from r.
   ?FPX0< FINF
   'FPX-E !
   'FPX-M 2!
;


: FPX-NORMALIZE (F r -- r' )
   (G Normalize representation of r on the top of the stack)
   ?FPX0= IF
      \ reset exponent on zero mantissa but preserve sign
      'FPX-E @
      FPV-EXP-MASK INVERT AND
      FPV-ZERO-MASK OR
      'FPX-E !
      EXIT
   THEN
   'FPX-E @ FPFLAGS>EXP >R
   'FPX-M 2@
   BEGIN
      DUP FPV-MSBIT AND 0=
   WHILE
      D2*
      R> 1- >R
   REPEAT
   'FPX-M 2!
   R> FPV-EXP-MASK AND 'FPX-E @ FPV-EXP-MASK INVERT AND OR 'FPX-E !
;

: FPX-DENORMALIZE (S +n -- ) (F r -- r')
   (G De-normalize representation of r on the top of the stack by n bits)
   ?FPX0=  IF  DROP EXIT  THEN
   DUP 0=  IF  DROP EXIT  THEN
   'FPX-E @ FPFLAGS>EXP >R >R
   'FPX-M 2@
   BEGIN
      R@ 0<>
   WHILE
      D2/ FPV-MSBIT INVERT AND
      R> 1- R> 1+ >R >R
   REPEAT
   2DUP OR 0=  IF  2DROP 1.  THEN
   'FPX-M 2!
   R> DROP R> FPV-EXP-MASK AND 'FPX-E @ FPV-EXP-MASK INVERT AND OR 'FPX-E !
;

: T+ (S nlo nmi nhi mlo mmi mhi -- tlo tmi thi)
   (G Add triple-cell numbers.)
   >R ROT  >R        \ S: nlo nmi mlo mmi   R: mhi nhi
   >R SWAP >R        \ S: nlo mlo           R: mhi nhi mmi nmi
   0 SWAP OVER       \ S: nlo 0 mlo 0       R: mhi nhi mmi nmi
   D+ 0              \ S: tlo tmi1 0        R: mhi nhi mmi nmi
   R> 0 D+           \ S: tlo tmi2 thi1     R: mhi nhi mmi
   R> 0 D+           \ S: tlo tmi thi2      R: mhi nhi
   R> R> + +         \ S: tlo tmi thi       R:
;

: T2/ (S nlo nmi nhi -- nlo' nmi' nhi')
   (G Divide triple-cell value by 2 - shift right with sign extension)
   >R DUP >R
   D2/ DROP
   R> R>
   D2/
;

: T2* (S nlo nmi nhi -- nlo' nmi' nhi')
   \G Multiply triple-cell value by 2 - shift left
   D2* 2>R
   0 D2*
   0 2R>
   D+
;

: F.DUMP
   (G Dump the content of the floating-point stack)
   FP@ DUP FP0 SWAP - CELL+ DUMP
;

: ?FPV-NEGATIVE (S n -- flag)
   \G flag is true if the sign flag in exponent cell n is set
   FPV-SIGN-MASK AND FPV-NEGATIVE =
;

ONLY FORTH DEFINITIONS ALSO FLOAT-PRIVATE

\ public definitions go here
\ private definitions are available for use

SYNONYM (F (F

SYNONYM FDEPTH FDEPTH

SYNONYM F.DUMP F.DUMP

: FLOATS (S n1 -- n2 ) \ 12.6.1.1556 FLOATS
   (G n2 is the size in address units of n1 floating-point numbers.)
   B/FLOAT *
;


: FLOAT+ (S f-addr1 -- f-addr2 ) \ 12.6.1.1555 FLOAT+
   \G Add the size in address units of a floating-point number to f-addr1, giving f-addr2.
   [ 1 FLOATS ] LITERAL +
;


: FDROP (F r -- ) \ 12.6.1.1500 FDROP
   (G Remove r from the floating-point stack.)
   1 ?FPSTACK-UNDERFLOW
   FP@ B/FLOAT + FP!
;

: FDUP (F r -- r r ) \ 12.6.1.1510 FDUP
   (G Duplicate r.)
   1 ?FPSTACK-UNDERFLOW
   'FPX-M 2@
   'FPX-E @
   >FP
;

: FSWAP (F r1 r2 -- r2 r1 ) \ 12.6.1.1620 FSWAP
   (G Exchange the top two floating-point stack items.)
   2 ?FPSTACK-UNDERFLOW
   'FPX-M 2@
   'FPX-E @
   'FPY-M 2@
   'FPY-E @
   'FPX-E !
   'FPX-M 2!
   'FPY-E !
   'FPY-M 2!
;

: FOVER (F r1 r2 -- r1 r2 r1 ) \ 12.6.1.1600 FOVER
   (G Place a copy of r1 on top of the floating-point stack.)
   2 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   'FPY-M 2@
   'FPY-E @
   >FP
;

: FROT (F r1 r2 r3 -- r2 r3 r1 ) \ 12.6.1.1610 FROT
   (G Rotate the top three floating-point stack entries.)
   FP> FSWAP >FP FSWAP
;

: D>F (S d -- ) (F -- r ) \ 12.6.1.1130 D>F
   (G r is the floating-point equivalent of d. )
   (G An ambiguous condition exists if d cannot be precisely represented as a floating-point value.)
   2DUP D0< IF  DABS FPV-NEGATIVE  ELSE  FPV-POSITIVE  THEN
   D>F-EXPONENT +
   >FP FPX-NORMALIZE
;


: F! (S f-addr -- ) (F r -- ) \ 12.6.1.1400 F!
   \G Store r at f-addr.
   1 ?FPSTACK-UNDERFLOW
   FP@ SWAP 1 FLOATS MOVE
   FDROP
;


: F@ (S f-addr -- ) (F -- r ) \ 12.6.1.1472 F@
   \G r is the value stored at f-addr.
   1 ?FPSTACK-OVERFLOW
   0. D>F
   FP@ 1 FLOATS MOVE
;


: FVARIABLE ( "<spaces>name" -- ) \ 12.6.1.1630 FVARIABLE
   \G Skip leading space delimiters. Parse name delimited by a space.
   \G Create a definition for name with the execution semantics defined below.
   \G Reserve 1 FLOATS address units of data space at a float-aligned address.
   \G
   \G name is referred to as an "f-variable".
   \G
   \G name Execution: (S -- f-addr )
   \G f-addr is the address of the data space reserved by FVARIABLE when it created name.
   \G A program is responsible for initializing the contents of the reserved space.
   CREATE  HERE 1 FLOATS DUP ALLOT ERASE
   DOES>
;


: FCONSTANT ( "<spaces>name" -- ) (F r -- ) \ 2.6.1.1492 FCONSTANT
   \G Skip leading space delimiters. Parse name delimited by a space.
   \G Create a definition for name with the execution semantics defined below.
   \G
   \G name is referred to as an "f-constant".
   \G
   \G name Execution: (S -- ) (F -- r )
   \G Place r on the floating-point stack.
   1 ?FPSTACK-UNDERFLOW
   CREATE  HERE 1 FLOATS ALLOT F!
   DOES>   1 ?FPSTACK-OVERFLOW F@
;


 0. D>F FCONSTANT FZERO
 1. D>F FCONSTANT FONE
-1. D>F FCONSTANT FMONE
 2. D>F FCONSTANT FTWO
10. D>F FCONSTANT FTEN


: FNEGATE (F r1 -- r2 ) \ 12.6.1.1567 FNEGATE
   (G r2 is the negation of r1.)
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   'FPX-E @
   FPV-SIGN-MASK XOR
   'FPX-E !
;

: F0< (S -- flag ) (F r -- ) \ 12.6.1.1440 F0<
   (G flag is true if and only if r is less than zero.)
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  FDROP FALSE  THEN
   ?FPX0< FDROP
;

: F0= (S -- flag ) (F r -- ) \ 12.6.1.1450 F0=
   (G flag is true if and only if r is equal to zero.)
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  FDROP FALSE  THEN
   ?FPX0= FDROP
;

: FNIP (F r1 r2 -- r2 )
   (G Drop the first item below the top of stack.)
   2 ?FPSTACK-UNDERFLOW
   FP> FDROP >FP
;

: ?FP2OP-NAN (S -- flag ) (F r1 r2 -- r1 r2 | NAN )
   \G Flag is true only if either r1 or r2 is NAN.
   \G FP stack remains untouched if neither r1 nor r1 is NAN, the values are replaced with NAN otherwise.
   2 ?FPSTACK-UNDERFLOW
   ?FPX-NAN ?FPY-NAN OR DUP
   IF  FDROP FPX-NAN!  THEN
;


: FPV-M>D (S umlo umhi flag -- mlo mhi sign)
   \G Adjust the value of mantissa - negate if flag is true
   DUP  IF  >R DNEGATE R>  THEN
;

: 3SWAP (S xl xm xh yl ym yh -- yl ym yh xl xm xh )
   2>R              \ S: xl xm xh yl           R: ym yh
   SWAP 2SWAP ROT   \ S: yl xl xm xh           R: ym yh
   2R> 2SWAP 2>R    \ S: yl xl ym yh           R: xm xh
   ROT 2R>          \ S: yl ym yh xl xm xh     R:
;


\ DEBUG-ON
: (F+EXTRACT) (S -- t1 t2 e1 e2 ) (F r1 r2 -- r1 r2 )
   \G Extract the mantissa of the two top items on the FP stack and sign-extend to triple-cell values.
   \G e1 is exponent of r1 and e2 is exponent of r2.
   'FPY-M 2@ ?FPY0< FPV-M>D
   'FPX-M 2@ ?FPX0< FPV-M>D
   'FPY-E @ FPFLAGS>EXP
   'FPX-E @ FPFLAGS>EXP
;

: (F+ORDER) (S t1 t2 e1 e2 -- t1' t2' +diffexp )
   \G Prepare operands for add/subtract operation.
   \G Swap t1 and t2 if (e1-e2) < 0, +dexp is the absolute value of diffexp.
   - DUP 0<  IF  NEGATE >R 3SWAP R>  THEN
;

1  CONSTANT  /F+GUARDBITS

: (F+DENORM) (S t +diffexp -- t' )
   \G Denormalize mantissa represented as triple-cell value t by +diffexp positions.
   \DEBUG S" (F+DENORM)-INPUT: " CR TYPE CR H.S CR
   0 MAX 64 MIN
   DUP 0=  IF  DROP EXIT  THEN
   \DEBUG S" (F+DENORM)-LOOP: " CR TYPE CR H.S CR
   0  ?DO  T2/  LOOP
   ROT 1 OR -ROT
   \DEBUG S" (F+DENORM)-RESULT: " CR TYPE CR H.S CR
;

: (F+GD+) (S t -- t' )
   \G Add guard bits - shift left for a predefined amount.
   /F+GUARDBITS 0  ?DO  T2*  LOOP
;

: (F+GD-) (S t -- t' )
   \G Remove guard bits - shift right for a predefined amount.
   /F+GUARDBITS 0  ?DO  T2/  LOOP
;

: F+ (F r1 r2 -- r3 ) \ 12.6.1.1420 F+
   (G Add r1 to r2 giving the sum r3.)
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F+-INPUT: " CR TYPE CR F.DUMP CR
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
   \DEBUG S" F+-EXTRACT: " CR TYPE CR H.S CR
   2DUP MAX >R
   (F+ORDER)
   \DEBUG S" F+-ORDER: " CR TYPE CR H.S CR
   >R
   3SWAP (F+GD+)
   3SWAP (F+GD+)
   R>
   (F+DENORM)
   \DEBUG S" F+-DENORM: " CR TYPE CR H.S CR
   T+ T2/
   (F+GD-)
   \DEBUG S" F+-SUM: " CR TYPE CR H.S CR
   FDROP
   0<> FPV-SIGN-MASK AND FPV-M>D
   R> FPFLAGS>EXP 1+ FPV-EXP-MASK AND OR
   \DEBUG S" F+-RESULT: " CR TYPE CR H.S CR
   'FPX-E !
   'FPX-M 2!
   FPX-NORMALIZE
   \DEBUG S" F+-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


: F- (F r1 r2 -- r3 ) \ 12.6.1.1425 F-
   (G Subtract r2 from r1, giving r3.)
   ?FP2OP-NAN  IF  EXIT  THEN
   FNEGATE F+
;


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
   'FPY-E @ FPFLAGS>EXP
   'FPX-E @ FPFLAGS>EXP
   + 1+
;

: (F*/SIGN) (S -- nflags ) (F r1 r2 -- r1 r2 )
   \G Compute the sign mask for float multiplication or division result.
   'FPY-E @ 'FPX-E @ XOR
   FPV-SIGN-MASK AND
;

: (F*RESULT) (S ud exp sign -- ud nflags )
   \G Build result representation for the F*.
   \DEBUG S" (F*RESULT)-INPUT: " CR TYPE CR H.S CR
   OVER FPV-EXP-MAX >  IF  2DROP 2DROP FINF EXIT  THEN
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
      (F*/SIGN) FDROP 'FPX-E ! FPX-INF! EXIT
   THEN
   (F*/SIGN) >R
   (F*EXP)  >R
   'FPY-M 2@ 'FPX-M 2@
   (F*EXACT)
   (F*NORMALIZE)
   R> + >R
   \DEBUG S" F*-NORMALIZED: " CR TYPE CR H.S CR
   (F*RN)
   R> + R>
   (F*RESULT)
   \DEBUG S" F*-RESULT: " CR TYPE CR H.S CR
   'FPY-E !
   'FPY-M 2!
   FDROP
   \DEBUG S" F*-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
USER F/-Q    2 CELLS USER-ALLOC
USER F/-QBIT 2 CELLS USER-ALLOC
USER F/-YM   2 CELLS USER-ALLOC
USER F/-XM   2 CELLS USER-ALLOC

: F/ (F r1 r2 -- r3 ) \ 12.6.1.1430 F/
   \G Divide r1 by r2, giving the quotient r3.
   \G An ambiguous condition exists if r2 is zero,
   \G or the quotient lies outside of the range of a floating-point number.
   2 ?FPSTACK-UNDERFLOW
   \DEBUG S" F/-INPUT: " CR TYPE CR F.DUMP CR
   ?FP2OP-NAN  IF  EXIT  THEN
   ?FPX-INF ?FPY-INF AND  IF
      \ (F*/SIGN) FDROP 'FPX-E !
      FDROP
      FPX-NAN! EXIT
   THEN
   ?FPX-INF ?FPY-INF XOR  IF
      (F*/SIGN)
      ?FPX-INF  IF
         FDROP FDROP
         FZERO  IF  FNEGATE  THEN
      ELSE
         FDROP
         DROP
      THEN
      EXIT
   THEN
   ?FPX0=  IF
      ?FPY-INF  IF  FDROP FPX-NAN! EXIT  THEN
      ?FPY0=    IF  FDROP FPX-NAN! EXIT  THEN
      (F*/SIGN) FDROP 'FPX-E ! FPX-INF! EXIT
   THEN
   ?FPY0=  IF
      F0<  IF  FNEGATE  THEN
      EXIT
   THEN
   \DEBUG CR S" F/-A: " TYPE CR F.DUMP CR
   0. F/-Q 2!
   0 FPV-MSBIT F/-QBIT 2!
   'FPY-M 2@ F/-YM 2!
   'FPX-M 2@ F/-XM 2!
   BEGIN
      F/-QBIT 2@ OR 0<>
      F/-YM 2@ OR 0<>
      AND
   WHILE
      F/-YM 2@ 0
      F/-XM 2@ 0
      \DEBUG CR S" F/-B1: " TYPE CR H.S CR
      TNEGATE
      \DEBUG CR S" F/-B2: " TYPE CR H.S CR
      T+ 0<
      \DEBUG CR S" F/-B3: " TYPE CR H.S CR
      IF
         2DROP
      ELSE
         F/-YM 2!
         F/-Q 2@ F/-QBIT 2@ ROT OR >R OR R> F/-Q 2!
      THEN
      F/-XM   2@ 0 T2/ DROP F/-XM   2!
      F/-QBIT 2@ 0 T2/ DROP F/-QBIT 2!
   REPEAT
   F/-Q 2@ 'FPY-M 2!
   'FPY-E @ DUP FPV-SIGN-MASK AND SWAP FPFLAGS>EXP
   'FPX-E @ DUP FPV-SIGN-MASK AND SWAP FPFLAGS>EXP
   ROT SWAP - FPV-EXP-MASK AND
   >R XOR R> OR 'FPY-E !
   FDROP
   \DEBUG CR S" F/-C: " TYPE CR F.DUMP CR
   FPX-NORMALIZE
   \DEBUG CR S" F/-D: " TYPE CR F.DUMP CR
;
\DEBUG-OFF

: F< (S -- flag ) (F r1 r2 -- ) \ 2.6.1.1460 F<
   \G flag is true if and only if r1 is less than r2.
   2 ?FPSTACK-UNDERFLOW
   ?FP2OP-NAN  IF  FDROP FALSE EXIT  THEN
   ?FPX0= ?FPY0= AND         IF  FDROP FDROP FALSE EXIT  THEN
   ?FPY0< ?FPX0< INVERT AND  IF  FDROP FDROP TRUE  EXIT  THEN
   ?FPY0< INVERT ?FPX0< AND  IF  FDROP FDROP FALSE EXIT  THEN
   F- F0<
;

: F> (S -- flag ) (F r1 r2 -- )
   \G flag is true if and only if r1 is larger than r2.
   2 ?FPSTACK-UNDERFLOW
   FSWAP F<
;

: FMIN (F r1 r2 -- r3 ) \ 12.6.1.1565 FMIN
   (G r3 is the lesser of r1 and r2.)
   2 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   FOVER FOVER F< IF  FDROP  ELSE  FNIP  THEN
;

: FMAX (F r1 r2 -- r3 ) \ 12.6.1.1562 FMAX
   (G r3 is the greater of r1 and r2.)
   2 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   FOVER FOVER F< IF  FNIP  ELSE  FDROP  THEN
;

: F>D ( -- d ) (F r -- ) \ 12.6.1.1470 F>D
   (G d is the double-cell signed-integer equivalent of the integer portion of r.)
   (G The fractional portion of r is discarded.)
   (G An ambiguous condition exists if the integer portion of r cannot be represented as a double-cell signed integer.)
   (G Note: Rounding the floating-point value prior to calling F>D is advised, because F>D rounds towards zero.)
   1 ?FPSTACK-UNDERFLOW
   \DEBUG CR S" F>D-A: " TYPE CR F.DUMP CR
   D>F-EXPONENT 'FPX-E @ FPFLAGS>EXP -
   DUP 0< IF  EXC-OUT-OF-RANGE THROW  THEN
   \DEBUG CR S" F>D-B: " TYPE CR H.S CR
   FPX-DENORMALIZE
   \DEBUG CR S" F>D-C: " TYPE CR F.DUMP CR
   'FPX-M 2@
   \DEBUG CR S" F>D-D: " TYPE CR H.S CR
   'FPX-E @ ?FPV-NEGATIVE FPV-M>D DROP
   FDROP
   \DEBUG CR S" F>D-E: " TYPE CR H.S CR
;

CODE FLIT
   PUSH        ESI
   ADD         ESI , # B/FLOAT
   NEXT
END-CODE COMPILE-ONLY

: FLITERAL \ 12.6.1.1552 FLITERAL
   \G Interpretation: Interpretation semantics for this word are undefined.
   \G Compilation: ( F: r -- )
   \G Append the run-time semantics given below to the current definition.
   \G
   \G Run-time: ( F: -- r )
   \G Place r on the floating-point stack.
   1 ?FPSTACK-UNDERFLOW
   POSTPONE FLIT
   HERE
   1 FLOATS ALLOT
   F!
   POSTPONE F@
; IMMEDIATE/COMPILE-ONLY

: FABS (F r1 -- r2 ) \ 12.6.2.1474 FABS
   \G r2 is the absolute value of r1.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   'FPX-E @ FPV-SIGN-MASK INVERT AND 'FPX-E !
;


\ DEBUG-ON
: F~ (S -- flag ) (F r1 r2 r3 -- ) \ 12.6.2.1640 F~
   \G If r3 is positive, flag is true if the absolute value of (r1 minus r2) is less than r3.
   \G
   \G If r3 is zero, flag is true if the implementation-dependent encoding of r1 and r2 are exactly
   \G identical (positive and negative zero are unequal if they have distinct encodings).
   \G
   \G If r3 is negative, flag is true if the absolute value of (r1 minus r2) is less than
   \G the absolute value of r3 times the sum of the absolute values of r1 and r2.
   3 ?FPSTACK-UNDERFLOW
   \DEBUG CR S" F~-INPUT: " TYPE CR F.DUMP CR
   ?FPX0= IF
      FDROP
      'FPX 'FPY 1 FLOATS TUCK COMPARE 0=
      FDROP FDROP
      EXIT
   THEN
   ?FPX0< IF
      FABS FP>          \ F: r1 r2                                S: abs(r3)
      FDUP FABS FP>     \ F: r1 r2                                S: abs(r3) abs(r2)
      FOVER FABS FP>    \ F: r1 r2                                S: abs(r3) abs(r2) abs(r1)
      \DEBUG CR S" F~-B1: " TYPE CR F.DUMP CR H.S CR
      F- FABS           \ F: abs(r1-r2)                           S: abs(r3) abs(r2) abs(r1)
      \DEBUG CR S" F~-B2: " TYPE CR F.DUMP CR H.S CR
      >FP >FP F+        \ F: abs(r1-r2) abs(r1)+abs(r2)           S: abs(r3)
      \DEBUG CR S" F~-B3: " TYPE CR F.DUMP CR H.S CR
      >FP F*            \ F: abs(r1-r2) (abs(r1)+abs(r2))*abs(r3)
      \DEBUG CR S" F~-B4: " TYPE CR F.DUMP CR H.S CR
      F-
      \DEBUG CR S" F~-B5: " TYPE CR F.DUMP CR H.S CR
      F0<
      \DEBUG CR S" F~-B6: " TYPE CR H.S CR
   ELSE
      FP> F- FABS >FP
      \DEBUG CR S" F~-C1: " TYPE CR F.DUMP CR
      F<
   THEN
;
\DEBUG-OFF


FONE FTWO F/ FCONSTANT FHALF

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

:NONAME (S c-addr u -- )
   ?DECIMAL IF
      2DUP
      >FLOAT IF
         STATE @ IF  POSTPONE FLITERAL  THEN
         2DROP EXIT
      THEN
   THEN

   DEFERRED INTERPRET-WORD-NOT-FOUND
; IS INTERPRET-WORD-NOT-FOUND


0 FPV-MSBIT 1. D- 2CONSTANT FLOOR-M-MASK
D# 32 CONSTANT FPV-BITS/CELL

: DRSHIFT (S xd n -- xd')
   \G Shift double value xd to the right by n positions preserving most significant bit
   FPV-BITS/CELL OVER U< IF  DROP 2DROP 0. EXIT  THEN
   OVER OVER FPV-BITS/CELL SWAP -  \ S: xd n xhi FPV-BITS/CELL-n
   LSHIFT >R                       \ S: xd n      R: xhi<<(FPV-BITS/CELL-n)
   TUCK RSHIFT >R                  \ S: xlo n     R: xhi<<(FPV-BITS/CELL-n) xhi>>n
   RSHIFT R> R>                    \ S: xlo>>n xhi>>n xhi<<(FPV-BITS/CELL-n)
   ROT OR SWAP
;

: DAND (S xd1 xd2 -- xd3 )
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

: FLOOR (F r1 -- r2 ) \ 12.6.1.1558 FLOOR
   \G Round r1 to an integral value using the "round toward negative infinity" rule, giving r2.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FLOOR-M-MASK
   'FPX-E @ FPFLAGS>EXP
   DUP 0< IF
      DROP
      2DROP -1.
   ELSE
      DRSHIFT
   THEN
   'FPX-M 2@                                \ S: mlo mhi rlo rhi
   \DEBUG S" FLOOR-A: " CR TYPE CR H.S CR F.DUMP CR
   2OVER 2OVER DAND
   \DEBUG S" FLOOR-B: " CR TYPE CR H.S CR
   OR 0<> 'FPX-E @ ?FPV-NEGATIVE AND
   \DEBUG S" FLOOR-B1: " CR TYPE CR H.S CR
   >R                                       \ S: mlo mhi rlo rhi    R: ?neg-with-fraction
   2SWAP DINVERT DAND
   \DEBUG S" FLOOR-C: " CR TYPE CR H.S CR
   'FPX-M 2!
   FPX-NORMALIZE
   \DEBUG S" FLOOR-C1: " CR TYPE CR H.S CR F.DUMP CR
   R>
   \DEBUG S" FLOOR-D: " CR TYPE CR H.S CR F.DUMP CR
   IF  FMONE F+  THEN
;


: FTRUNC (F r1 -- r2 ) \ 12.6.2.1627 FTRUNC
   \G Round r1 to an integral value using the "round towards zero" rule, giving r2.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FDUP F0= 0=
   IF
      FDUP F0<
      IF
         FNEGATE FLOOR FNEGATE
      ELSE
         FLOOR
      THEN
   THEN
;


: FROUND (F r1 -- r2 ) \ 12.6.1.1612 FROUND
   \G Round r1 to an integral value using the "round to nearest" rule, giving r2.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FDUP F0< IF
      FNEGATE RECURSE FNEGATE
   ELSE
      FDUP FLOOR
      \DEBUG S" FROUND-A: " CR TYPE CR H.S CR F.DUMP CR
      FSWAP FOVER F-
      \DEBUG S" FROUND-B: " CR TYPE CR H.S CR F.DUMP CR
      FHALF F< INVERT IF
         FONE F+
      THEN
   THEN
   \DEBUG S" FROUND-C: " CR TYPE CR H.S CR F.DUMP CR
;


12 CONSTANT FSQRT-ITERATIONS-DEFAULT

: FSQRT-APPROX (F r1 -- r2 )
   \G r2 is the initial approximation of square root of r1.
   'FPX-E @ DUP
   FPFLAGS>EXP 1 RSHIFT FPV-EXP-MASK AND
   SWAP FPV-EXP-MASK INVERT AND OR
   'FPX-E !
;

: FSQRT-NEWTON-STEP (F r1 r2 -- r3 )
   \G Perform step in Newton approximation for a square root.
   \G Calculate next approximation r3 for the square root of
   \G r1 given the previous approximation r2.
   ?FPX0= IF  FNIP EXIT  THEN
   FSWAP FOVER      \ F: r2 r1 r2
   F/ F+
   \ trick for speed - decrement exponent instead of dividing by two
   'FPX-E @ DUP
   FPFLAGS>EXP 1- FPV-EXP-MASK AND
   SWAP FPV-EXP-MASK INVERT AND OR
   'FPX-E !
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


: FMOD (F r1 r2 -- r3)
   \G r3 is floating point remainder of division r1 by r2.
   \G The absolute value of r3 lays in range [0, r2).
   \G r3 has the same sign as r1.
   2 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   ?FPX0= IF  EXC-FLOAT-DIVISION-BY-ZERO THROW  THEN
   \ r3 = r1 - trunc(r1 / r2) * r2
   FOVER FOVER F/ FTRUNC F* F-
;

3.1415926535897932384626433832795E FCONSTANT FPI
FPI FTWO F* FCONSTANT FTWOPI
FPI FTWO F/ FCONSTANT FHALFPI
FHALFPI FTWO F/ FCONSTANT FQUOTERPI

: FSCALE-TRIG (F r1 -- r2)
   \G Scale r1 into range [0, 2*pi)
   1 ?FPSTACK-UNDERFLOW
   FTWOPI FMOD
;

 0.99940307E FCONSTANT FCOS32-C1
-0.49558072E FCONSTANT FCOS32-C2
 0.03679168E FCONSTANT FCOS32-C3

: FCOS32-APPROX (F r1 -- r2 )
   \G computes cosine (r1)
   \G Accurate to about 3.2 decimal digits over the range [0, pi/2].
   \G r1 is in radians.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   \ cos(x)= c1 + x**2(c2 + c3*x**2)
   FDUP F*
   FCOS32-C3    FOVER F*
   FCOS32-C2 F+ FOVER F*
   FCOS32-C1 F+
   FNIP
;

 0.9999932946 FCONSTANT FCOS52-C1
-0.4999124376 FCONSTANT FCOS52-C2
 0.0414877472 FCONSTANT FCOS52-C3
-0.0012712095 FCONSTANT FCOS52-C4

: FCOS52-APPROX (F r1 -- r2 )
   \G computes cosine (r1)
   \G Accurate to about 5.2 decimal digits over the range [0, pi/2].
   \G r1 is in radians.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   \ cos(x)= c1 + x**2(c2 + x**2(c3 + c4*x**2))
   FDUP F*
   FCOS52-C4    FOVER F*
   FCOS52-C3 F+ FOVER F*
   FCOS52-C2 F+ FOVER F*
   FCOS52-C1 F+
   FNIP
;

\ DEBUG-ON
: FCOS (F r1 -- r2 ) \ 12.6.2.1493 FCOS
   \G r2 is the cosine of the radian angle r1.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0= IF
      FDROP FONE
      EXIT
   THEN
   2 ?FPSTACK-OVERFLOW
   FSCALE-TRIG
   FABS
   \DEBUG S" FCOS-A: " CR TYPE CR F.DUMP CR
   FDUP FHALFPI
   \DEBUG S" FCOS-B: " CR TYPE CR H.S CR F.DUMP CR
   F/ FLOOR
   \DEBUG S" FCOS-C: " CR TYPE CR H.S CR F.DUMP CR
   F>D
   D>S
   ['] FCOS52-APPROX SWAP
   \DEBUG S" FCOS-D: " CR TYPE CR H.S CR F.DUMP CR
   CASE
      0 OF
         EXECUTE
      ENDOF
      1 OF
         FPI FSWAP F-
         EXECUTE
         FNEGATE
      ENDOF
      2 OF
         FPI F-
         EXECUTE
         FNEGATE
      ENDOF
      3 OF
         FTWOPI FSWAP F-
         EXECUTE
      ENDOF
      ABORT
   ENDCASE
   \DEBUG S" FCOS-E: " CR TYPE CR H.S CR F.DUMP CR
;
\DEBUG-OFF


: FSIN (F r1 -- r2 ) \ 12.6.2.1614 FSIN
   \G r2 is the sine of the radian angle r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX0= IF
      FDROP FZERO
   ELSE
      FHALFPI FSWAP F- FCOS
   THEN
;


: FSINCOS (F r1 -- r2 r3 ) \ 12.6.2.1616 FSINCOS
   \G r2 is the sine of the radian angle r1. r3 is the cosine of the radian angle r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   FDUP FSIN
   FSWAP FCOS
;


\ DEBUG-ON
: FTAN (F r1 -- r2 ) \ 12.6.2.1625 FTAN
   \G r2 is the tangent of the radian angle r1. An ambiguous condition exists if (r1) is zero.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FSINCOS
   \DEBUG S" FTAN-A: " CR TYPE CR F.DUMP CR
   F/
;
\DEBUG-OFF


FPI 6. D>F    F/  FCONSTANT FSIXTHPI
FSIXTHPI FTWO F/  FCONSTANT FTWELFTHPI
FSIXTHPI   FTAN   FCONSTANT FTANSIXTHPI
FTWELFTHPI FTAN   FCONSTANT FTANTWELFTHPI

1.6867629106 FCONSTANT FATAN66-C1
0.4378497304 FCONSTANT FATAN66-C2
1.6867633134 FCONSTANT FATAN66-C3

: FATAN66-APPROX (F r1 -- r2 )
   \G r2 is atan(r1).
   \G Accurate to about 6.6 decimal digits over the range [0, pi/12].
   \G atan(x)= x*(c1 + c2*x**2)/(c3 + x**2)
   FDUP FDUP F*
   FDUP FATAN66-C2 F* FATAN66-C1 F+
   FSWAP FATAN66-C3 F+ F/ F*
;

\ DEBUG-ON
: FATAN66-ZERO-ONE-RANGE (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,1].
   \DEBUG S" FATAN-ZERO-ONE-INPUT: " CR TYPE CR F.DUMP CR
   FTANTWELFTHPI FOVER F< IF
      FDUP  FTANSIXTHPI F-
      FSWAP FTANSIXTHPI F* FONE F+
      F/
      FATAN66-APPROX
      FSIXTHPI F+
   ELSE
      FATAN66-APPROX
   THEN
   \DEBUG S" FATAN-ZERO-ONE-RESULT: " CR TYPE CR F.DUMP CR
;

: FATAN66-POSITIVE (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \DEBUG S" FATAN-POSITIVE-INPUT: " CR TYPE CR F.DUMP CR
   FONE FOVER F< IF
      FONE FSWAP F/
      FATAN66-ZERO-ONE-RANGE
      FHALFPI FSWAP F-
   ELSE
      FATAN66-ZERO-ONE-RANGE
   THEN
   \DEBUG S" FATAN-POSITIVE-RESULT: " CR TYPE CR F.DUMP CR
;

0.596227E  FCONSTANT FATAN-2NDORDER-B

: FATAN-2NDORDER (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \G This is for x in [0, Infinity). When x is negative just use -atan_approx(-x).
   \G atan_approx(x) = (Pi/2)*(b*x + x*x)/(1 + 2*b*x + x*x) where b = 0.596227,
   \G with a maximum approximation error of 0.1620º
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FDUP FDUP F*
   FSWAP FATAN-2NDORDER-B F* FSWAP
   \ F: b*x x*x
   FOVER F+
   \ F: b*x b*x+x*x
   FSWAP FOVER F+
   \ F: b*x+x*x b*x+b*x+x*x
   FONE F+
   F/
   FHALFPI F*
;

17. D>F FSQRT FONE F+ 8. D>F F/
FCONSTANT FATAN-3RDORDER-C
FATAN-3RDORDER-C FONE F+  FCONSTANT FATAN-3RDORDER-CP1

: FATAN-3RDORDER (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \G This is for x in [0, Infinity). When x is negative just use -atan_approx(-x).
   \G atan_approx(x) = (Pi/2)*(c*x + x*x + x*x*x)/(1 + (c+1)*x + (c+1)x*x + x*x*x)
   \G where c = (1 + sqrt(17))/8 and the maximum approximation error is 0.00811º
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FATAN-3RDORDER-C FOVER F*
   FOVER FDUP F* FDUP FP> F+
   FOVER >FP F* F+
   FSWAP
   \ F: (c*x + x*x + x*x*x) x
   FATAN-3RDORDER-CP1 FOVER F*
   FOVER FDUP F* FDUP FP> FATAN-3RDORDER-CP1 F* F+
   FSWAP >FP F* F+
   FONE F+
   \ F: (c*x + x*x + x*x*x) (1 + (c+1)*x + (c+1)x*x + x*x*x)
   F/
   FHALFPI F*
;

: FATAN-FLOAT-RANGE (S xt -- ) (F r1 -- r2 )
   \G Calculate atan approximation of r1 in range (-FLOAT-MAX,+FLOAT-MAX).
   \G xt is the word to calculate atan approximation of r1 in range [0,+FLOAT-MAX).
   \DEBUG S" FATAN-FLOAT-RANGE-INPUT: " CR TYPE CR F.DUMP CR
   'FPX-E @ ?FPV-NEGATIVE IF
      FNEGATE
      EXECUTE
      FNEGATE
   ELSE
      EXECUTE
   THEN
   \DEBUG S" FATAN-FLOAT-RANGE-RESULT: " CR TYPE CR F.DUMP CR
;

: FATAN (F r1 -- r2 ) \ 12.6.2.1488 FATAN
   \G r2 is the principal radian angle whose tangent is r1.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FATAN-INPUT: " CR TYPE CR F.DUMP CR
   \ ['] FATAN66-POSITIVE
   \ ['] FATAN-2NDORDER
   ['] FATAN-3RDORDER
   FATAN-FLOAT-RANGE
   \DEBUG S" FATAN-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
: FASIN (F r1 -- r2 ) \ 12.6.2.1486 FASIN
   \G r2 is the principal radian angle whose sine is r1.
   \G An ambiguous condition exists if | r1 | is greater than one.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FDUP FABS FONE F- F0= IF
      FHALFPI F*
      EXIT
   THEN
   FDUP FDUP F* FONE FSWAP F- FSQRT
   \DEBUG S" FASIN-A: " CR TYPE CR F.DUMP CR
   F/ FATAN
;
\DEBUG-OFF


: FACOS (F r1 -- r2 ) \ 12.6.2.1476 FACOS
   \G r2 is the principal radian angle whose cosine is r1.
   \G An ambiguous condition exists if | r1 | is greater than one.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   FASIN FHALFPI FSWAP F-
;


\ DEBUG-ON
: FATAN2 (F r1 r2 -- r3 ) \ 12.6.2.1489 FATAN2
   \G r3 is the principal radian angle (between -π and π) whose tangent is r1/r2.
   \G A system that returns false for "-0E 0E 0E F~" shall return a value
   \G (approximating) -π when r1 = 0E and r2 is negative.
   \G An ambiguous condition exists if r1 and r2 are zero.
   2 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   \DEBUG S" FATAN2-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX0= ?FPY0= AND  IF
      ?FPY0< ?FPX0<
      FDROP FDROP
      IF  FPI  ELSE  FZERO  THEN
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-00: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPX0= IF
      \ r2 = 0
      FDROP F0< FHALFPI
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-2: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPY-INF ?FPX-INF AND  IF
      ?FPY0< ?FPX0<
      FDROP FDROP
      FQUOTERPI
      IF  FHALFPI  ELSE  FZERO  THEN
      F+
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-INF-INF: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPY-INF INVERT ?FPX-INF AND  IF
      ?FPY0< ?FPX0<
      FDROP FDROP
      IF  FPI  ELSE  FZERO  THEN
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-N-INF: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   ?FPY-INF ?FPX-INF INVERT AND  IF
      ?FPY0<
      FDROP FDROP
      FHALFPI
      IF  FNEGATE  THEN
      \DEBUG S" FATAN2-RESULT-INF-N: " CR TYPE CR F.DUMP CR
      EXIT
   THEN
   FDUP FNEGATE F0< IF
      \ r2 > 0
      F/ FATAN
   ELSE
      \ r2 <= 0
      FOVER FSWAP
      \DEBUG S" FATAN2-C1: " CR TYPE CR F.DUMP CR
      F/ FATAN
      \DEBUG S" FATAN2-C2: " CR TYPE CR F.DUMP CR
      FSWAP
      \DEBUG S" FATAN2-C3: " CR TYPE CR F.DUMP CR
      F0< FPI IF  FNEGATE  THEN
      F+
   THEN
   \DEBUG S" FATAN2-RESULT-2: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
18  CONSTANT  FEXPM1-ITERATIONS-DEFAULT

: FEXPM1-APPROX (S +n -- ) (F r1 -- r2 )
   \G Approximate exp(r1 - 1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FDUP FDUP
   1 2>R
   BEGIN
      2R> 1 +
      2DUP >
      \ S: n i flag    R:          F: r2(i-1)' r1 (r1**(i-1))/(i-1)!
   WHILE
      DUP S>D 2SWAP 2>R
      \ S: di          R: n i      F: r2(i-1)' r1 (r1**(i-1))/(i-1)!
      FOVER F*
      D>F F/
      \ S:             R: n i      F: r2(i-1)' r1 (r1**(i))/(i)!
      FROT FOVER F+
      \ S:             R: n i      F: r1 (r1**(i))/(i)!  r2'+(r1**(i))/(i)!
      FROT FROT
      \ S:             R: n i      F: r2(i)' r1 (r1**(i))/(i)!
   REPEAT
   2DROP
   \ F: r2(i)' r1 (r1**(i))/(i)!
   FDROP FDROP
;

: FEXPM1 (F r1 -- r2 ) \ 12.6.2.1516 FEXPM1
   \G Raise e to the power r1 and subtract one, giving r2.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FEXPM1-INPUT: " CR TYPE CR F.DUMP CR
   FEXPM1-ITERATIONS-DEFAULT FEXPM1-APPROX
   \DEBUG S" FEXPM1-RESULT: " CR TYPE CR F.DUMP CR
;

: FEXP (F r1 -- r2 ) \ 12.6.2.1515 FEXP
   \G Raise e to the power r1, giving r2.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FEXP-INPUT: " CR TYPE CR F.DUMP CR
   FEXPM1 FONE F+
   \DEBUG S" FEXP-RESULT: " CR TYPE CR F.DUMP CR
;

1.E FEXP  FCONSTANT  FLNBASE
\DEBUG-OFF


\ DEBUG-ON
18  CONSTANT  FLN-ITERATIONS-DEFAULT

: FLN-TAYLOR (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FDUP F0< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   \ calculate y = (r1-1)/(r1+1)
   FDUP  FONE F-
   FSWAP FONE F+ F/
   \ S: +n             F: y
   FZERO FOVER
   FDUP F*
   \ S: +n             F: y sum(=0) y**2
   BEGIN
      1 -
      DUP 0>
      \ S: n' flag        F: y sum y**2
   WHILE
      DUP S>D D2* 1. D-
      \ S: n' dn'*2-1     F: y sum y**2
      FSWAP FOVER F*
      \ S: n' dn'*2-1     F: y y**2 sum*y**2
      FONE D>F F/
      \ S: n'             F: y y**2 sum*y**2 1/(dn'*2-1)
      F+ FSWAP
      \ S: n'             F: y sum' y**2
   REPEAT
   DROP
   \ F: y sum' y**2
   FDROP
   F* FTWO F*
;

: FLN (F r1 -- r2 ) \ 12.6.2.1553 FLN
   \G r2 is the natural logarithm of r1.
   \G An ambiguous condition exists if r1 is less than or equal to zero.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FLN-INPUT: " CR TYPE CR F.DUMP CR
   FDUP F0< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FLN-ITERATIONS-DEFAULT FLN-TAYLOR
   \DEBUG S" FLN-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
18  CONSTANT  FLNP1-ITERATIONS-DEFAULT

: FLNP1-TAYLOR1 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1 + r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FDUP FNEGATE FOVER
   \ F: sum(=r1) -r1 r1
   1 2>R
   BEGIN
      2R> 1 +
      2DUP >
      \ S: n i flag    R:          F: r2(i-1)' r1 r1**(i-1)
   WHILE
      DUP S>D 2SWAP 2>R
      \ S: di          R: n i      F: r2(i-1)' r1 r1**(i-1)
      FOVER F* FDUP
      D>F
      \ DEBUG S" FLNP1-TAYLOR-ITER: " CR TYPE CR F.DUMP CR
      F/
      \ S:             R: n i      F: r2(i-1)' r1 r1**(i) (r1**(i))/(i)
      FP> FROT >FP F+
      \ S:             R: n i      F: r1 r1**(i) r2(i-1)'+(r1**(i))/(i)
      FROT FROT
      \ S:             R: n i      F: r2(i)' r1 r1**(i)
   REPEAT
   2DROP
   \ F: r2(i)' r1 r1**(i)
   FDROP FDROP
;

: FLNP1-TAYLOR2 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1 + r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FZERO
   \ S: +n             F: r1 sum(=0)
   BEGIN
      1 -
      DUP 0>
      \ S: n' flag        F: r1 sum
   WHILE
      DUP S>D
      \ S: n' dn'         F: r1 sum
      FOVER FNEGATE F*
      \ S: n' dn'         F: r1 sum*(-r1)
      FONE D>F F/
      \ S: n'             F: r1 sum*(-r1) 1/(dn')
      F+
      \ S: n'             F: r1 sum'
   REPEAT
   DROP
   F*
;

: FLNP1-TAYLOR3 (S +n -- ) (F r1 -- r2 )
   \G Approximate ln(1+r1) using +n iterations.
   1 ?FPSTACK-UNDERFLOW
   4 ?FPSTACK-OVERFLOW
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   \ calculate y = r1 / (r1+2)
   FDUP FTWO F+ F/
   \ S: +n             F: y
   FZERO FOVER
   FDUP F*
   \ S: +n             F: y sum(=0) y**2
   BEGIN
      1 -
      DUP 0>
      \ S: n' flag        F: y sum y**2
   WHILE
      DUP S>D D2* 1. D-
      \ S: n' dn'*2-1     F: y sum y**2
      FSWAP FOVER F*
      \ S: n' dn'*2-1     F: y y**2 sum*y**2
      FONE D>F F/
      \ S: n'             F: y y**2 sum*y**2 1/(dn'*2-1)
      F+ FSWAP
      \ S: n'             F: y sum' y**2
   REPEAT
   DROP
   \ F: y sum' y**2
   FDROP
   F* FTWO F*
;

: FLNP1 (F r1 -- r2 ) \ 12.6.2.1554 FLNP1
   \G r2 is the natural logarithm of the quantity r1 plus one.
   \G An ambiguous condition exists if r1 is less than or equal to negative one.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FLNP1-INPUT: " CR TYPE CR F.DUMP CR
   FDUP FMONE F< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FONE FOVER FABS F- F0< IF
      \ abs(r1) > 1
      FONE F+ FLN
   ELSE
      \ abs(r1) <= 1
      FLNP1-ITERATIONS-DEFAULT FLNP1-TAYLOR3
   THEN
   \DEBUG S" FLNP1-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
FTEN FLN  FCONSTANT  FLOG-FLNTEN

: FLOG (F r1 -- r2 ) \ 12.6.2.1557 FLOG
   \G r2 is the base-ten logarithm of r1.
   \G An ambiguous condition exists if r1 is less than or equal to zero.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FLOG-INPUT: " CR TYPE CR F.DUMP CR
   FDUP F0< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FLN
   FLOG-FLNTEN F/
   \DEBUG S" FLOG-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
: F** (F r1 r2 -- r3 )  \ 12.6.2.1415 F**
   \G Raise r1 to the power r2, giving the product r3.
   2 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FP2OP-NAN  IF  EXIT  THEN
   \DEBUG S" F**-INPUT: " CR TYPE CR F.DUMP CR
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
   \DEBUG S" F**-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
\ ln(10) = ln(2 * 2 * 2 * 1.25) = 3*ln(2) + ln(1.25) = 3*lnp1(1) + lnp1(0.25)
FONE FLNP1  FCONSTANT  FLNTWO
FLNTWO 3.E F* 0.25E FLNP1 F+  FCONSTANT  FALOG-FLNTEN

: FALOG (F r1 -- r2 ) \ 12.6.2.1484 FALOG
   \G Raise ten to the power r1, giving r2.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FALOG-INPUT: " CR TYPE CR F.DUMP CR
   ?FPX0= IF
      FDROP
      FONE
   ELSE
      FALOG-FLNTEN F*
      FEXP
   THEN
   \DEBUG S" FALOG-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
: FHYPEXP (F r1 -- exp[r1] exp[-r1])
   \G Calculate exponents for hyperbolic functions.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   FDUP FEXP
   FSWAP FNEGATE FEXP
;

: FSINH (F r1 -- r2 ) \ 12.6.2.1617 FSINH
   \G r2 is the hyperbolic sine of r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FSINH-INPUT: " CR TYPE CR F.DUMP CR
   FHYPEXP F- FTWO F/
   \DEBUG S" FSINH-RESULT: " CR TYPE CR F.DUMP CR
;

: FCOSH (F r1 -- r2 ) \ 12.6.2.1494 FCOSH
   \G r2 is the hyperbolic cosine of r1.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FCOSH-INPUT: " CR TYPE CR F.DUMP CR
   FHYPEXP F+ FTWO F/
   \DEBUG S" FCOSH-RESULT: " CR TYPE CR F.DUMP CR
;

: FTANH (F r1 -- r2 ) \ 12.6.2.1626 FTANH
   \G r2 is the hyperbolic tangent of r1.
   1 ?FPSTACK-UNDERFLOW
   3 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FTANH-INPUT: " CR TYPE CR F.DUMP CR
   FHYPEXP FOVER FOVER F+ FP> F- >FP F/
   \DEBUG S" FTANH-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


\ DEBUG-ON
: FASINH (F r1 -- r2 ) \ 12.6.2.1487 FASINH
   \G r2 is the floating-point value whose hyperbolic sine is r1.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FASINH-INPUT: " CR TYPE CR F.DUMP CR
   FDUP FDUP F* FONE F+ FSQRT
   F+ FLN
   \DEBUG S" FASINH-RESULT: " CR TYPE CR F.DUMP CR
;

: FACOSH (F r1 -- r2 ) \ 12.6.2.1477 FACOSH
   \G r2 is the floating-point value whose hyperbolic cosine is r1.
   \G An ambiguous condition exists if r1 is less than one.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FACOSH-INPUT: " CR TYPE CR F.DUMP CR
   FDUP FDUP F* FONE F- FSQRT
   F+ FLN
   \DEBUG S" FACOSH-RESULT: " CR TYPE CR F.DUMP CR
;

: FATANH (F r1 -- r2 ) \ 12.6.2.1491 FATANH
   \G r2 is the floating-point value whose hyperbolic tangent is r1.
   \G An ambiguous condition exists if r1 is outside the range of -1E0 to 1E0.
   1 ?FPSTACK-UNDERFLOW
   2 ?FPSTACK-OVERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   \DEBUG S" FATANH-INPUT: " CR TYPE CR F.DUMP CR
   FONE FOVER FABS F< IF
      EXC-FLOAT-INVALID-ARGUMENT THROW
   THEN
   FONE FOVER F+
   FONE FROT F-
   F/ FLN
   FTWO F/
   \DEBUG S" FATANH-RESULT: " CR TYPE CR F.DUMP CR
;
\DEBUG-OFF


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
   'FPX-E @ ?FPV-NEGATIVE >R
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


MAX-REPRESENT-DIGITS  VALUE  PRECISION (S -- u) \ 12.6.2.2035 PRECISION
\G Return the number of significant digits currently used by F., FE., or FS. as u.

: SET-PRECISION (S u -- ) \ 12.6.2.2200 SET-PRECISION
   \G Set the number of significant digits currently used by F., FE., or FS. to u.
   0 MAX MAX-REPRESENT-DIGITS MIN TO PRECISION
;


: FALIGNED (S addr -- f-addr) \ 12.6.1.1483 FALIGNED
   \G f-addr is the first float-aligned address greater than or equal to addr.
;

: FALIGN (S -- ) \ 12.6.1.1479 FALIGN
   \G If the data-space pointer is not float aligned, reserve enough data space to make it so.
   DP @ FALIGNED DP !
;


: F+! \ (S addr -- ) (F r -- )
   \G Add float r to float at addr
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   DUP >R F@ F+ R> F!
;

VALUE-METHOD FVALUE!  F!
VALUE-METHOD FVALUE+! F+!

CREATE FVALUE-VT
   ' FVALUE! , ' FVALUE+! ,

: FVALUE  (F r -- ) ( "<spaces>name" -- ) \ 12.6.2.1628 FVALUE
   \G Skip leading space delimiters. Parse name delimited by a space. Create a
   \G definition for name with the execution semantics defined below, with an
   \G initial value equal to r.
   \G
   \G name is referred to as a "f-value".
   \G
   \G name Execution: ( F: -- r )
   \G Place r on the floating point stack. The value of r is that given when
   \G name was created, until the phrase "r TO name" is executed, causing a new
   \G value of r to be assigned to name.
   \G
   \G TO name Run-time: ( F: r -- )
   \G Assign the value r to name.
   CREATE
   FVALUE-VT ,
   FALIGN HERE 1 FLOATS ALLOT F!
   DOES> FALIGNED VALUE>DATA F@
;


ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !

\EOF

-1. d>f
1. d>f
F+
CR F.DUMP
FDROP

123. d>f
12. d>f
F+
CR F.DUMP
FDROP

123. d>f
12. d>f
F-
CR F.DUMP
FDROP

44443333222211110000. d>f
44443333222211110001. d>f
F-
CR F.DUMP
FDROP

HEX FEDCBA987654321. DECIMAL d>f
HEX 123456789ABCDEF. DECIMAL d>f
F-
CR F.DUMP
FDROP

HEX 123456789ABCDEF. DECIMAL d>f
HEX FEDCBA987654321. DECIMAL d>f
F-
CR F.DUMP
FDROP

-1. d>f
1. d>f
CR F.DUMP
F*
CR F.DUMP
FDROP

-255. d>f
256. d>f
CR F.DUMP
F*
CR F.DUMP
FDROP

-255. d>f
1000. d>f
CR F.DUMP
F*
CR F.DUMP
-255000. D>F
F- F0= CR .

-2. d>f
2. d>f
CR F.DUMP
F/
CR F.DUMP
-1. D>F
F-
CR F.DUMP
F0= CR .

1. D>F
CR F.DUMP
F>D
CR .S
1. D=
CR .

1. D>F
10. D>F
F/
CR F.DUMP
F>D
CR .S
0. D=
CR .

-1. D>F
CR F.DUMP
F>D
CR .S
-1. D=
CR .

bye
