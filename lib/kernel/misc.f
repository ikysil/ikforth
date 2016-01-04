\
\  misc.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading MISC definitions )

CREATE-REPORT @
CREATE-REPORT OFF

BASE @

: MS Sleep ;

: RDEPTH RP0 RP@ - 4 / 1- ;

: BASE? BASE @ DUP DECIMAL . BASE ! ;

: BFLIP WORD-SPLIT SWAP WORD-JOIN ;

: FLIP DWORD-SPLIT SWAP DWORD-JOIN ;

: BODY> [ 1 CELLS ] LITERAL - ;

: R-DROP
  R> R> DROP >R ; COMPILE-ONLY

: R-SWAP
  R> R> R> SWAP >R >R >R ; COMPILE-ONLY

: R-DUP
  R> R@ >R >R ; COMPILE-ONLY

: R-OVER
  R> 1 R-PICK >R >R ; COMPILE-ONLY

USER TIME&DATE-STRUC 16 USER-ALLOC

: TIME&DATE (S -- +n1 +n2 +n3 +n4 +n5 +n6 )
  TIME&DATE-STRUC
  DUP GetLocalTime
  DUP 6 WORDS+ W@ SWAP
  DUP 5 WORDS+ W@ SWAP
  DUP 4 WORDS+ W@ SWAP
  DUP 3 WORDS+ W@ SWAP
  DUP 1 WORDS+ W@ SWAP
  DUP 0 WORDS+ W@ SWAP
  DROP ;

: FILL (S c-addr u char -- )
  SWAP ROT FillMemory ;

: ERASE (S c-addr u -- )
  SWAP ZeroMemory ;

: BLANK (S c-addr u -- )
  BL FILL ;

DECIMAL

     1024 CONSTANT 1KB
1KB DUP * CONSTANT 1MB
1KB 1MB * CONSTANT 1GB

DEFER EMIT?
' TRUE IS EMIT?

: UNUSED (S -- u )
  DATA-AREA-SIZE @ HERE DATA-AREA-BASE - - ;

: (.ENV-INFO-NUM) 
  BL PARSE ENVIRONMENT? DROP POSTPONE LITERAL ; IMMEDIATE/COMPILE-ONLY

: .ENV-INFO
  ." Environment information:" CR
  UNUSED 1KB /                       8 U.R ." KBytes free/data area" CR
  (.ENV-INFO-NUM) STACK-CELLS        8 U.R ."  cells/data stack"     CR
  (.ENV-INFO-NUM) RETURN-STACK-CELLS 8 U.R ."  cells/return stack"   CR
  ;

2VARIABLE CMD-LINE

: MONTH>STR
  DUP 1 13 WITHIN INVERT IF EXC-INVALID-NUM-ARGUMENT THROW THEN
  1- 3 *
  S" JanFebMarAprMayJunJulAugSepOctNovDec"
  DROP + 3 ;

BASE !

\  Parse name and compile header without CFA
: HEADER        \  D: "name" --
  BL WORD COUNT
  CHECK-NAME REPORT-NAME CHECK-DUPLICATE-NAME
  &USUAL (HEADER,) ;

USER PAD PAD-SIZE USER-ALLOC 

\ ?EXIT "question-exit"
\ ( true -- ) ( I: ra ip -- ra )
\ ( false -- ) ( I: ra ip -- ra ip )
\ If the value at the stack top is non-zero, perform EXIT.
: ?EXIT POSTPONE IF POSTPONE EXIT POSTPONE THEN ; IMMEDIATE/COMPILE-ONLY

: CASE? (S x x -- true )
        (S x y -- x false )
  OVER = DUP IF NIP THEN ;

CREATE-REPORT !
