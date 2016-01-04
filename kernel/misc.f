\
\  misc.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading MISC definitions )

CREATE-REPORT @
CREATE-REPORT OFF

BASE @

VoidDLLEntry MS KERNEL32.DLL Sleep

: RDEPTH RP0 RP@ - 4 / 1- ;

: BASE? BASE @ DUP DECIMAL . BASE ! ;

: BFLIP WORD-SPLIT SWAP WORD-JOIN ;

: FLIP DWORD-SPLIT SWAP DWORD-JOIN ;

: .ID COUNT TYPE ;

: H.S BASE @ >R HEX .S R> BASE ! ;

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

: S">ASCIIZ (S c-addr u -- asciiz-addr )
  DUP CHAR+ ALLOCATE THROW DUP >R SWAP 2DUP + >R CMOVE 0 R> C! R> ;

: C">ASCIIZ (S c-addr -- asciiz-addr )
  COUNT S">ASCIIZ ;

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
  (.ENV-INFO-NUM) STACK-CELLS        8 U.R ."  cells/data stack"      CR
  (.ENV-INFO-NUM) RETURN-STACK-CELLS 8 U.R ."  cells/return stack"    CR
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
  VEF-USUAL (HEADER,) ;

USER PAD
S" /PAD" ENVIRONMENT? INVERT
  [IF] 10240 DUP
    <ENV
      CONSTANT /PAD
    ENV>
  [THEN] USER-ALLOC 

\ ?EXIT "question-exit"
\ ( true -- ) ( I: ra ip -- ra )
\ ( false -- ) ( I: ra ip -- ra ip )
\ If the value at the stack top is non-zero, perform EXIT.
: ?EXIT POSTPONE IF POSTPONE EXIT POSTPONE THEN ; IMMEDIATE/COMPILE-ONLY

CREATE-REPORT !
