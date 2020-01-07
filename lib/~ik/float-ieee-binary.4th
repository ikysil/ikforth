\
\  float-ieee-binary.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REQUIRES" sysdict/x86/486asm.4th"
REQUIRES" lib/~ik/triple.4th"
REQUIRES" lib/~ik/quadruple.4th"

CR .( Loading FLOAT-IEEE-BINARY definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS

VOCABULARY FLOAT-IEEE-BINARY-PRIVATE

ALSO FLOAT-IEEE-BINARY-PRIVATE DEFINITIONS

\ private definitions go here

DECIMAL

32       CONSTANT  /FPSTACK
3 CELLS  CONSTANT  B/FLOAT
63       CONSTANT  D>F-EXPONENT
19       CONSTANT  MAX-REPRESENT-DIGITS

<ENV
                   TRUE  CONSTANT  FLOATING
                   TRUE  CONSTANT  FLOATING-EXT
               /FPSTACK  CONSTANT  FLOATING-STACK
   MAX-REPRESENT-DIGITS  CONSTANT  MAX-FLOAT-DIGITS
ENV>

\ floating point representation
\ +0   exponent and flags cell
\ +1   most  significant cell
\ +2   least significant cell
\ unsigned mantissa is stored as double value, aligned to the most significant bit

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

: FPM@ (S addr -- ud )
   \G Fetch mantissa from the float representation at addr.
   [ 1 CELLS ] LITERAL +
   2@
;

: FPM! (S ud addr -- )
   \G Store mantissa to the float representation at addr.
   [ 1 CELLS ] LITERAL +
   2!
;

: FPE@ (S addr -- un )
   \G Fetch exponent and flags from the float representation at addr.
   @
;

: FPE! (S un addr -- )
   \G Store exponent and flags to the float representation at addr.
   !
;

: 'FPX (S -- addr )
   \G Return address of the top item on floating-point stack)
   FP@
;

: 'FPY (S -- addr )
   (G Return address of the second item on floating-point stack)
   FP@ [ B/FLOAT ] LITERAL +
;

: 'FPZ (S -- addr )
   (G Return address of the third item on floating-point stack)
   FP@ [ 2 B/FLOAT * ] LITERAL +
;

: FPFLAGS>EXP (S n1 -- n2 )
   (G Extract exponent value from n with sign expansion)
   FPV-EXP-MASK AND
   DUP FPV-EXP-SIGN AND
   IF  FPV-EXP-MASK INVERT OR  THEN
;

: FP> (S -- ud n) (F r -- )
   (G Move float value from floating-point stack to data stack)
   1 ?FPSTACK-UNDERFLOW
   'FPX FPM@
   'FPX FPE@
   FP@ B/FLOAT + FP!
;

: >FP (S ud n -- ) (F -- r )
   (G Move float value from data stack to floating-point stack)
   1 ?FPSTACK-OVERFLOW
   FP@ B/FLOAT - FP!
   'FPX FPE!
   'FPX FPM!
;

: ?FPX0= (S -- flag ) (F r -- r)
   (G flag is true if and only if r is equal to zero.)
   'FPX FPM@ OR 0=
;

: ?FPY0= (S -- flag ) (F r1 r2 -- r1 r2)
   (G flag is true if and only if r1 is equal to zero.)
   'FPY FPM@ OR 0=
;


: ?FPX0< (S -- flag ) (F r -- r)
   \G flag is true if and only if sign of mantissa of r is negative
   'FPX FPE@ FPV-SIGN-MASK AND FPV-NEGATIVE =
;

: ?FPY0< (S -- flag ) (F r1 r2 -- r1 r2)
   \G flag is true if and only if sign of mantissa of r1 is negative
   'FPY FPE@ FPV-SIGN-MASK AND FPV-NEGATIVE =
;


: ?FPX-NAN (S -- flag ) (F r -- r)
   \G flag is true if and only if r is NAN
   'FPX FPE@ FPV-NAN-MASK AND 0<>
;

: ?FPY-NAN (S -- flag ) (F r1 r2 -- r1 r2)
   \G flag is true if and only if r1 is NAN
   'FPY FPE@ FPV-NAN-MASK AND 0<>
;


: ?FPX-INF (S -- flag ) (F r -- r)
   \G flag is true if and only if r is INFinity
   'FPX FPE@ FPV-INF-MASK AND 0<>
;

: ?FPY-INF (S -- flag ) (F r1 r2 -- r1 r2)
   \G flag is true if and only if r1 is INFinity
   'FPY FPE@ FPV-INF-MASK AND 0<>
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
   'FPX FPE!
   'FPX FPM!
;


: FINF (S sign -- ud n )
   \G Return signed INF representation.
   IF  FPV-NEGATIVE  ELSE  FPV-POSITIVE  THEN
   FPV-INF-MASK OR
   FPV-EXP-MAX  OR
   -1.
   ROT
;

: FPX-INF! (S -- ) (F r -- +/-inf )
   \G Set top of FP stack to INFinity with sign copied from r.
   ?FPX0< FINF
   'FPX FPE!
   'FPX FPM!
;


: FPX-NORMALIZE (F r -- r' )
   (G Normalize representation of r on the top of the stack)
   ?FPX0= IF
      \ reset exponent on zero mantissa but preserve sign
      'FPX FPE@
      FPV-EXP-MASK INVERT AND
      FPV-ZERO-MASK OR
      'FPX FPE!
      EXIT
   THEN
   'FPX FPE@ FPFLAGS>EXP >R
   'FPX FPM@
   BEGIN
      DUP FPV-MSBIT AND 0=
   WHILE
      D2*
      R> 1- >R
   REPEAT
   'FPX FPM!
   R> FPV-EXP-MASK AND 'FPX FPE@ FPV-EXP-MASK INVERT AND OR 'FPX FPE!
;

: FPX-DENORMALIZE (S +n -- ) (F r -- r')
   (G De-normalize representation of r on the top of the stack by n bits)
   ?FPX0=  IF  DROP EXIT  THEN
   DUP 0=  IF  DROP EXIT  THEN
   'FPX FPE@ FPFLAGS>EXP >R >R
   'FPX FPM@
   BEGIN
      R@ 0<>
   WHILE
      D2/ FPV-MSBIT INVERT AND
      R> 1- R> 1+ >R >R
   REPEAT
   2DUP OR 0=  IF  2DROP 1.  THEN
   'FPX FPM!
   R> DROP R> FPV-EXP-MASK AND 'FPX FPE@ FPV-EXP-MASK INVERT AND OR 'FPX FPE!
;

: F.DUMP
   (G Dump the content of the floating-point stack)
   FP@ DUP FP0 SWAP - CELL+ DUMP
;

: ?FPV-NEGATIVE (S n -- flag)
   \G flag is true if the sign flag in exponent cell n is set
   FPV-SIGN-MASK AND FPV-NEGATIVE =
;


: FPX2/ (F r1 -- r2)
   \G r2 is r1 divided by two.
   \ trick for speed - decrement exponent instead of dividing by two
   'FPX FPE@ DUP
   FPFLAGS>EXP 1- FPV-EXP-MASK AND
   SWAP FPV-EXP-MASK INVERT AND OR
   'FPX FPE!
;


: FP-RESULT (S ud exp sign -- ud nflags )
   \G Build result representation.
   \DEBUG S" FP-RESULT-INPUT: " CR TYPE CR H.S CR
   OVER FPV-EXP-MAX >  IF  >R DROP 2DROP R> FINF EXIT  THEN
   OVER FPV-EXP-MIN D>F-EXPONENT - 1+ <=  IF  2SWAP 2DROP NIP 0. ROT FPV-ZERO-MASK OR EXIT  THEN
   >R >R
   0
   BEGIN
      R@ FPV-EXP-MIN <=
   WHILE
      T2/
      R> 1+ >R
   REPEAT
   ABORT" MUST BE ZERO IN FP-RESULT!"
   R> R>
   2OVER D0=  IF  NIP FPV-ZERO-MASK OR EXIT  THEN
   OVER FPV-EXP-MIN <=  IF  NIP FPV-EXP-MIN OR EXIT  THEN
   SWAP
   FPV-EXP-MASK AND
   OR
;


: ?FPX-SUBN (S -- flag ) (F r -- r )
   \G Flag is true if and only if r is a subnormal value.
   'FPX FPE@ FPFLAGS>EXP FPV-EXP-MIN 1+ <=
;


: ?FPY-SUBN (S -- flag ) (F r1 r2 -- r1 r2 )
   \G Flag is true if and only if r1 is a subnormal value.
   'FPY FPE@ FPFLAGS>EXP FPV-EXP-MIN 1+ <=
;


ONLY FORTH DEFINITIONS ALSO FLOAT-IEEE-BINARY-PRIVATE

\ public definitions go here
\ private definitions are available for use

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


:NONAME
   ?FPX-NAN FDROP
; IS ?NAN


:NONAME
   ?FPX-INF FDROP
; IS ?INF


: FDUP (F r -- r r ) \ 12.6.1.1510 FDUP
   (G Duplicate r.)
   1 ?FPSTACK-UNDERFLOW
   'FPX FPM@
   'FPX FPE@
   >FP
;

: FSWAP (F r1 r2 -- r2 r1 ) \ 12.6.1.1620 FSWAP
   (G Exchange the top two floating-point stack items.)
   2 ?FPSTACK-UNDERFLOW
   'FPX FPM@
   'FPX FPE@
   'FPY FPM@
   'FPY FPE@
   'FPX FPE!
   'FPX FPM!
   'FPY FPE!
   'FPY FPM!
;

: FOVER (F r1 r2 -- r1 r2 r1 ) \ 12.6.1.1600 FOVER
   (G Place a copy of r1 on top of the floating-point stack.)
   2 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   'FPY FPM@
   'FPY FPE@
   >FP
;

: FROT (F r1 r2 r3 -- r2 r3 r1 ) \ 12.6.1.1610 FROT
   (G Rotate the top three floating-point stack entries.)
   FP> FSWAP >FP FSWAP
;

: FNIP (F r1 r2 -- r2 )
   (G Drop the first item below the top of stack.)
   2 ?FPSTACK-UNDERFLOW
   FP> FDROP >FP
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
   'FPX FPE@
   FPV-SIGN-MASK XOR
   'FPX FPE!
;


: FABS (F r1 -- r2 ) \ 12.6.2.1474 FABS
   \G r2 is the absolute value of r1.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   'FPX FPE@ FPV-SIGN-MASK INVERT AND 'FPX FPE!
;


: ?FP2OP-NAN (S -- flag ) (F r1 r2 -- r1 r2 | NAN )
   \G Flag is true only if either r1 or r2 is NAN.
   \G FP stack remains untouched if neither r1 nor r1 is NAN, the values are replaced with one NAN otherwise.
   2 ?FPSTACK-UNDERFLOW
   ?FPX-NAN ?FPY-NAN OR DUP
   IF  FDROP FPX-NAN!  THEN
;


: FPV-M>D (S umlo umhi flag -- mlo mhi sign)
   \G Adjust the value of mantissa - negate if flag is true
   DUP  IF  >R DNEGATE R>  THEN
;


\ DEBUG-ON
: FREXP (S -- exp flag ) (F r -- fr )
   \G Decompose given floating point value r into a normalized fraction and an integral power of two.
   \G flag is true if r is not a special value - NaN or infinity.
   1 ?FPSTACK-UNDERFLOW
   1 ?FPSTACK-OVERFLOW
   ?FPX-NAN ?FPX-INF OR  IF
      FPX-NAN! FALSE
      EXIT
   THEN
   FP>
   DUP FPFLAGS>EXP >R
   FPV-EXP-MASK INVERT AND
   >FP
   R> TRUE
;
\DEBUG-OFF


REQUIRES" lib/~ik/float-ieee-binary/f-compare-zero.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-plus-f-minus.4th"
REQUIRES" lib/~ik/float-ieee-binary/fused-mul-add.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-star.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-slash.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-compare.4th"


: F>D ( -- d ) (F r -- ) \ 12.6.1.1470 F>D
   (G d is the double-cell signed-integer equivalent of the integer portion of r.)
   (G The fractional portion of r is discarded.)
   (G An ambiguous condition exists if the integer portion of r cannot be represented as a double-cell signed integer.)
   (G Note: Rounding the floating-point value prior to calling F>D is advised, because F>D rounds towards zero.)
   1 ?FPSTACK-UNDERFLOW
   ?FPX-INF  IF  EXC-OUT-OF-RANGE THROW  THEN
   ?FPX-NAN  IF  EXC-INVALID-NUM-ARGUMENT THROW  THEN
   \DEBUG CR S" F>D-A: " TYPE CR F.DUMP CR
   D>F-EXPONENT 'FPX FPE@ FPFLAGS>EXP -
   DUP 0< IF  EXC-OUT-OF-RANGE THROW  THEN
   \DEBUG CR S" F>D-B: " TYPE CR H.S CR
   FPX-DENORMALIZE
   \DEBUG CR S" F>D-C: " TYPE CR F.DUMP CR
   'FPX FPM@
   \DEBUG CR S" F>D-D: " TYPE CR H.S CR
   'FPX FPE@ ?FPV-NEGATIVE FPV-M>D DROP
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

FONE FTWO F/ FCONSTANT FHALF


REQUIRES" lib/~ik/float-ieee-binary/to-float.4th"


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


: FLOOR-FR-MASK (S n -- ud)
   \G Compute mask for fractional part of mantissa given the exponent n.
   DUP 0<  IF  DROP -1. EXIT  THEN
   1+
   DOUBLE-BITS OVER U<  IF  DROP 0 S>D EXIT  THEN
   CELL-BITS   OVER U<  IF
      CELL-BITS SWAP -
      1 SWAP LSHIFT 1-
      0
   ELSE
      -1
      CELL-BITS ROT -
      1 SWAP LSHIFT 1-
   THEN
;

: FLOOR-FR-MASK-TEST
   66 -1  DO
      I FLOOR-FR-MASK
      CR I 3 .R SPACE H.8 H.8
   LOOP
;

\ FLOOR-FR-MASK-TEST CR ABORT

: FLOOR (F r1 -- r2 ) \ 12.6.1.1558 FLOOR
   \G Round r1 to an integral value using the "round toward negative infinity" rule, giving r2.
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN  IF  EXIT  THEN
   ?FPX-INF  IF  EXIT  THEN
   'FPX FPE@ FPFLAGS>EXP
   FLOOR-FR-MASK
   'FPX FPM@                                \ S: mlo mhi rlo rhi
   \DEBUG S" FLOOR-A: " CR TYPE CR H.S CR F.DUMP CR
   2OVER 2OVER DAND
   \DEBUG S" FLOOR-B: " CR TYPE CR H.S CR
   OR 0<> 'FPX FPE@ ?FPV-NEGATIVE AND
   \DEBUG S" FLOOR-B1: " CR TYPE CR H.S CR
   >R                                       \ S: mlo mhi rlo rhi    R: ?neg-with-fraction
   2SWAP DINVERT DAND
   \DEBUG S" FLOOR-C: " CR TYPE CR H.S CR
   'FPX FPM!
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
   ?FPX-INF  IF  EXIT  THEN
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
   ?FPX-INF  IF  EXIT  THEN
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


: FNEWTON (S +n xt -- ) (F r1 r2 -- r3 )
   \G Perform Newton iterations using over r1 given the initial approximation r2 and number of iterations +n.
   \G xt calculates next approximation with stack effect (F r1 r2 -- r3 ).
   1 ?FPSTACK-OVERFLOW
   SWAP
   0 ?DO
      FOVER FSWAP
      DUP EXECUTE
   LOOP
   DROP
   FNIP
   \DEBUG CR ." FNEWTON-RESULT: " CR FDUP F. CR
;


REQUIRES" lib/~ik/float-ieee-binary/f-exp.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-log.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-star-star.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-sqrt.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-isqrt.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-trig.4th"
REQUIRES" lib/~ik/float-ieee-binary/f-hyptrig.4th"
REQUIRES" lib/~ik/float-ieee-binary/represent.4th"


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


\ REQUIRES" lib/~ik/float-ieee-binary/f-slash-goldschmidt.4th"
\ REQUIRES" lib/~ik/float-ieee-binary/f-slash-newton-raphson.4th"

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
