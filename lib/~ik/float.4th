\
\  float.4th
\
\  Copyright (C) 2017 Illya Kysil
\

CR .( Loading FLOAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY FLOAT-PRIVATE

\ ALSO FLOAT-PRIVATE DEFINITIONS

\ private definitions go here

<ENV
             TRUE  CONSTANT FLOATING
             TRUE  CONSTANT FLOATING-EXT
ENV>

DECIMAL

6 CONSTANT /FPSTACK
3 CELLS CONSTANT B/FLOAT

\ floating point representation
\ +1   least significant cell
\ +2   most significant cell
\ unsigned mantissa is stored as double value, aligned to the right
\ +3   exponent and flags cell

HEX
00000000 CONSTANT FPV-POSITIVE
80000000 CONSTANT FPV-NEGATIVE
80000000 CONSTANT FPV-SIGN
00000FFF CONSTANT FPV-EXP-MASK
00000800 CONSTANT FPV-EXP-SIGN
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

: 'FPX-M (S -- addr )
   (G Return address of the mantissa cell of the top item on floating-point stack)
   FP@
;

: 'FPX-E (S -- addr )
   (G Return address of the exponent cell of the top item on floating-point stack)
   'FPX-M FPV-EXP-OFFS +
;

: 'FPY-M (S -- addr )
   (G Return address of the mantissa cell of the second item on floating-point stack)
   FP@ B/FLOAT +
;

: 'FPY-E (S -- addr )
   (G Return address of the exponent cell of the second item on floating-point stack)
   'FPY-M FPV-EXP-OFFS +
;

: FP>EXP (S n1 -- n2 )
   (G Extract exponent value from n)
   FPV-EXP-MASK AND
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

\ ONLY FORTH DEFINITIONS ALSO FLOAT-PRIVATE

\ public definitions go here
\ private definitions are available for use

SYNONYM (F (F

SYNONYM FDEPTH FDEPTH

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
   >FP
;

: FNEGATE (F r1 -- r2 ) \ 12.6.1.1567 FNEGATE
   (G r2 is the negation of r1.)
   1 ?FPSTACK-UNDERFLOW
   'FPX-E @
   FPV-SIGN XOR
   'FPX-E !
;

: F0< (S -- flag ) (F r -- ) \ 12.6.1.1440 F0<
   (G flag is true if and only if r is less than zero.)
   FP> FPV-SIGN AND FPV-NEGATIVE =
   >R OR 0<> R> AND
;

: F0= (S -- flag ) (F r -- ) \ 12.6.1.1450 F0=
   (G flag is true if and only if r is equal to zero.)
   FP> DROP OR 0=
;

: F+ (F r1 r2 -- r3 ) \ 12.6.1.1420 F+
   (G Add r1 to r2 giving the sum r3.)
   2 ?FPSTACK-UNDERFLOW

;

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
