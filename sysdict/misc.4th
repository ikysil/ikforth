PURPOSE: MISC definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @

DEFER MS (S msecs -- )

: RDEPTH
   RP0 RP@ - 4 / 1-
;

: BASE?
   BASE @ DUP DECIMAL . BASE !
;

: BFLIP
   WORD-SPLIT SWAP WORD-JOIN
;

: FLIP
   DWORD-SPLIT SWAP DWORD-JOIN
;

: BODY> (S PFA -- CFA )
   CFA-SIZE -
;

: R-DROP
   R> R> DROP >R
; COMPILE-ONLY

: R-SWAP
   R> R> R> SWAP >R >R >R
; COMPILE-ONLY

: R-DUP
   R> R@ >R >R
; COMPILE-ONLY

: R-OVER
   R> 1 R-PICK >R >R
; COMPILE-ONLY

DEFER TIME&DATE (S -- +n1 +n2 +n3 +n4 +n5 +n6 )

: FILL (S c-addr u char -- )
   (G If u is greater than zero, store char in each of u consecutive characters of memory beginning at c-addr.)
   >R BEGIN
      DUP 0<>
   WHILE
      OVER R@ SWAP C!
      1 /STRING
   REPEAT
   2DROP
   R> DROP
;

: ERASE (S c-addr u -- )
   0 FILL
;

: BLANK (S c-addr u -- )
   BL FILL
;

DECIMAL

     1024 CONSTANT 1KB
1KB DUP * CONSTANT 1MB
1KB 1MB * CONSTANT 1GB

: UNUSED (S -- u )
   DATA-AREA-SIZE @ HERE DATA-AREA-BASE - -
;

: (.ENV-INFO-NUM)
   BL PARSE ENVIRONMENT? DROP POSTPONE LITERAL
; IMMEDIATE/COMPILE-ONLY

: .HOST-CODE-THREADING
   HOST-ITC? IF ." Host code: ITC (Indirect Threaded Code)" THEN
   HOST-DTC? IF ." Host code: DTC (Direct Threaded Code)"   THEN
;

: .UNUSED
   UNUSED 0 2DUP
   [ 1MB 10 * ] LITERAL S>D D> IF
      1MB UM/MOD
      8 U.R
      ."  MiB free/data area"
      DROP
   ELSE
      1KB UM/MOD
      8 U.R
      ."  KiB free/data area"
      DROP
   THEN
;

: .ENV-INFO
   CR ." Environment information:"
   CR .UNUSED
   CR (.ENV-INFO-NUM) STACK-CELLS           8 U.R ."  cells/data stack"
   CR (.ENV-INFO-NUM) RETURN-STACK-CELLS    8 U.R ."  cells/return stack"
   CR (.ENV-INFO-NUM) EXCEPTION-STACK-CELLS 8 U.R ."  cells/exception stack"
   CR CR .HOST-CODE-THREADING
   CR
;

: MONTH>STR
   DUP 1 13 WITHIN INVERT IF EXC-INVALID-NUM-ARGUMENT THROW THEN
   1- 3 *
   S" JanFebMarAprMayJunJulAugSepOctNovDec"
   DROP + 3
;

BASE !

\  Parse name and compile header without CFA
: HEADER        \  D: "name" --
   PARSE-NAME CHECK-NAME REPORT-NAME &USUAL (HEADER,)
;

USER PAD PAD-SIZE USER-ALLOC

\ ?EXIT "question-exit"
\ ( true -- ) ( I: ra ip -- ra )
\ ( false -- ) ( I: ra ip -- ra ip )
\ If the value at the stack top is non-zero, perform EXIT.
: ?EXIT
   POSTPONE IF POSTPONE EXIT POSTPONE THEN
; IMMEDIATE/COMPILE-ONLY

: CASE? (S x x -- true )
        (S x y -- x false )
   OVER = DUP IF NIP THEN
;

\ LCSHIFT
\ D: a b -- a RCL b
: LCSHIFT
   OVER OVER 32 SWAP - RSHIFT -ROT LSHIFT OR
;

\ RCSHIFT
\ D: a b -- a RCR b
: RCSHIFT
   OVER OVER 32 SWAP - LSHIFT -ROT RSHIFT OR
;

\ counts '1' bits in a
: POPULATION (S a -- population a)
   H# 55555555 OVER  1 RSHIFT OVER 2>R AND 2R> AND +
   H# 33333333 OVER  2 RSHIFT OVER 2>R AND 2R> AND +
   H# 0F0F0F0F OVER  4 RSHIFT OVER 2>R AND 2R> AND +
   H# 00FF00FF OVER  8 RSHIFT OVER 2>R AND 2R> AND +
   H# 0000FFFF OVER 16 RSHIFT OVER 2>R AND 2R> AND +
;

: @EXECUTE
   @ EXECUTE
;

: #! (S -- )
   \G Skip the line - support for scripting.
   POSTPONE \
;

REPORT-NEW-NAME !
