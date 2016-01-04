\
\  core.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

REPORT-NEW-NAME @
\ TRUE REPORT-NEW-NAME !

\ -----------------------------------------------------------------------------
\  CHAR [CHAR] PARSE) .(
\ -----------------------------------------------------------------------------

: CHAR BL WORD COUNT DROP C@ ;

: [CHAR] CHAR POSTPONE LITERAL ; IMMEDIATE/COMPILE-ONLY

: PARSE)
  [CHAR] ) PARSE
;

: .(
  PARSE) TYPE
; IMMEDIATE

.( Loading CORE definitions )

\ -----------------------------------------------------------------------------
\  +! @+ !+ C+! C@+ C!+
\ -----------------------------------------------------------------------------

: +! \ (S x addr -- )
  SWAP OVER @ + SWAP ! ;

: @+ \ (S addr1 -- addr2 x )
  DUP CELL+ SWAP @
;

: !+ \ (S x addr1 -- addr2 )
  DUP -ROT ! CELL+
;

: C+! \ (S x addr -- )
  SWAP OVER C@ + SWAP C! ;

: C@+ \ (S addr1 -- addr2 x )
  DUP CHAR+ SWAP C@
;

: C!+ \ (S x addr1 -- addr2 )
  DUP -ROT C! CHAR+
;

\ -----------------------------------------------------------------------------
\  CHARS ALIGN ALIGNED
\ -----------------------------------------------------------------------------

: CHARS ;

: ALIGN ;

: ALIGNED ;

\ -----------------------------------------------------------------------------
\  [COMPILE]
\ -----------------------------------------------------------------------------
                                                                               
: [COMPILE] \ (S "name" -- )
  COMP' DROP COMPILE,
; IMMEDIATE

\ -----------------------------------------------------------------------------

CREATE CR-STR 2 C, 13 C, 10 C,

: CR CR-STR COUNT TYPE ;

\ -----------------------------------------------------------------------------
\  PARSE" (C") ," ,C" C" ,S" SLITERAL
\ -----------------------------------------------------------------------------

: PARSE" \ (S string" -- c-addr count )
  [CHAR] " PARSE
;

: (C") R> DUP COUNT + ALIGNED >R ;

\ compile string
: ," \ (S c-addr count -- )
  HERE OVER ALLOT SWAP CMOVE
;

\ compile counted string
: ,C" \ (S c-addr count -- )
  HERE             \ c-addr count here
  OVER CHAR+ ALLOT \ c-addr count here
  OVER SWAP        \ c-addr count count here
  C!+              \ c-addr count here+char
  SWAP             \ 
  CMOVE
;

\ parse string separated by " and compile it as counted string
: C"
  PARSE"
  POSTPONE (C") ,C"
; IMMEDIATE/COMPILE-ONLY

\ compile string
: ,S" \ (S c-addr count -- )
  HERE             \ c-addr count here
  OVER CELL+ ALLOT \ c-addr count here
  OVER SWAP        \ c-addr count count here
  !+               \ c-addr count here+cell
  SWAP             \ 
  CMOVE
;

: SLITERAL
  POSTPONE (S") ,S"
; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------

: ."
  POSTPONE S"
  POSTPONE TYPE
; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  Primitives for execution control words
\ -----------------------------------------------------------------------------

\ ?PAIRS
(DO-DEFER) &USUAL PARSE-CHECK-HEADER, ?PAIRS DROP ]
  2DROP
[

\ Reserve space for forward reference
: >MARK \ (S -- addr for >RESOLVE )
  HERE 0 COMPILE, ; COMPILE-ONLY

\ Patch forward reference created with >MARK
: >RESOLVE HERE SWAP ! ; COMPILE-ONLY

\ Mark an address for backward reference
: <MARK \ (S -- addr for <RESOLVE )
  HERE ; COMPILE-ONLY

\ Resolve backward reference to address marked by <MARK
: <RESOLVE COMPILE, ; COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  IF ELSE THEN
\ -----------------------------------------------------------------------------

: IF POSTPONE ?BRANCH >MARK 2 ; IMMEDIATE/COMPILE-ONLY

: ELSE 2 ?PAIRS POSTPONE BRANCH >MARK SWAP >RESOLVE 2 ; IMMEDIATE/COMPILE-ONLY

: THEN 2 ?PAIRS >RESOLVE ; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  LOOPS
\ -----------------------------------------------------------------------------

: BEGIN <MARK 1 ; IMMEDIATE/COMPILE-ONLY

: UNTIL 1 ?PAIRS POSTPONE ?BRANCH <RESOLVE ; IMMEDIATE/COMPILE-ONLY

: WHILE POSTPONE ?BRANCH >MARK 2 2SWAP ; IMMEDIATE/COMPILE-ONLY

: REPEAT 1 ?PAIRS POSTPONE BRANCH <RESOLVE 2 ?PAIRS >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: AGAIN 1 ?PAIRS POSTPONE BRANCH <RESOLVE ; IMMEDIATE/COMPILE-ONLY

: DO POSTPONE (DO) >MARK 3 ; IMMEDIATE/COMPILE-ONLY

: ?DO POSTPONE (?DO) >MARK 3 ; IMMEDIATE/COMPILE-ONLY

: LOOP 3 ?PAIRS POSTPONE (LOOP) DUP CELL+ <RESOLVE >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: +LOOP 3 ?PAIRS POSTPONE (+LOOP) DUP CELL+ <RESOLVE >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: UNLOOP R> R> DROP R> DROP R> DROP >R ; COMPILE-ONLY

: LOOP>D R> R> SWAP R> SWAP R> SWAP >R ; COMPILE-ONLY

: D>LOOP R> SWAP >R SWAP >R SWAP >R >R ; COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  RECURSE
\ -----------------------------------------------------------------------------

: RECURSE LATEST-HEAD@ HEAD> COMPILE, ; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  ' [']
\ -----------------------------------------------------------------------------

: (') BL WORD DUP COUNT 0= IF EXC-EMPTY-NAME THROW THEN
         DROP DUP FIND  0= IF EXC-UNDEFINED  THROW ELSE NIP THEN ;

: ' (') DUP IS-INT/COMP? IF INT/COMP>INT THEN ;

' '
:NONAME ' POSTPONE LITERAL ;
INT/COMP: [']

\ -----------------------------------------------------------------------------
\  THROW ABORT ABORT"
\ -----------------------------------------------------------------------------

USER THROW-ADDRESS 1 CELLS USER-ALLOC
USER THROW-WORD    1 CELLS USER-ALLOC

: (COMP-THROW) \ (S exc-id throw-word -- )
  R@ [ 1 CELLS ] LITERAL - THROW-ADDRESS ! THROW-WORD ! ?DUP
  IF (THROW) ELSE 0 DUP THROW-ADDRESS ! THROW-WORD ! THEN ;

:NONAME 0 DUP THROW-ADDRESS ! THROW-WORD ! THROW ;
\ ' THROW
:NONAME LATEST-HEAD@ POSTPONE LITERAL POSTPONE (COMP-THROW) ;
INT/COMP: THROW

: ABORT -1 THROW ;

USER ABORT"-MESSAGE 2 CELLS USER-ALLOC

: (ABORT") ABORT"-MESSAGE 2! IF EXC-ABORT" THROW THEN ;
: ABORT" POSTPONE S" POSTPONE (ABORT") ; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  DEFER IS DEFER@ DEFER@-EXECUTE DEFER@-CATCH
\ -----------------------------------------------------------------------------

:NONAME TRUE ABORT" un-initialized DEFER" ; CONSTANT (DEFAULT-DEFER)
: DEFER (DO-DEFER) &USUAL PARSE-CHECK-HEADER, DROP (DEFAULT-DEFER) COMPILE, ;

:NONAME ' >BODY ! ;
:NONAME ' >BODY POSTPONE LITERAL POSTPONE ! ;
INT/COMP: IS

:NONAME ' >BODY @ ;
:NONAME ' >BODY POSTPONE LITERAL POSTPONE @ ;
INT/COMP: DEFER@

:NONAME ' >BODY @ EXECUTE ;
:NONAME ' >BODY @ POSTPONE LITERAL POSTPONE EXECUTE ;
INT/COMP: DEFER@-EXECUTE

:NONAME ' >BODY @ CATCH ;
:NONAME ' >BODY @ POSTPONE LITERAL POSTPONE CATCH ;
INT/COMP: DEFER@-CATCH

:NONAME - IF EXC-CONTROL-MISMATCH THROW THEN ; IS ?PAIRS

\ -----------------------------------------------------------------------------

\ -----------------------------------------------------------------------------

: */ >R M* R> SM/REM SWAP DROP ;

: */MOD >R M* R> SM/REM ;

: / >R S>D R> SM/REM SWAP DROP ;

: /MOD >R S>D R> SM/REM ;

: MOD >R S>D R> SM/REM DROP ;

: WITHIN OVER - >R - R> U< ;

: SIGN-FILL \ (S value -- sign)
  31 RSHIFT 0 SWAP -
;

\ 6.1.0690 ABS
\ D: a -- abs(a)
\ Assuming 2-complement binary representation
: ABS \ (S a -- abs(a))
  DUP SIGN-FILL TUCK + XOR
;

: FM/MOD
  2DUP XOR 0<
  IF
    >R R@ SM/REM OVER
    IF
      1- SWAP R> + SWAP
    ELSE
      R> DROP
    THEN
  ELSE
    SM/REM
  THEN
;

: MAX 2DUP < IF SWAP THEN DROP ;

: MIN 2DUP > IF SWAP THEN DROP ;

\ Assuming 2-complement binary representation
: SGN \ (S a -- sign a)
  DUP 31 RSHIFT NEGATE
  SWAP NEGATE 31 RSHIFT OR
;

: CONVERT COUNT >NUMBER DROP ;

\ -----------------------------------------------------------------------------

: <= > INVERT ;

: >= < INVERT ;

: 0<= 0> INVERT ;

: 0>= 0< INVERT ;

\ -----------------------------------------------------------------------------

: (
  SOURCE-ID 0>
  IF
    BEGIN
      PARSE) 2DROP
      >IN @ 1- SOURCE DROP + C@ [CHAR] ) = IF EXIT THEN
      REFILL INVERT
    UNTIL
  ELSE
    PARSE) 2DROP
  THEN
; IMMEDIATE

: SPACE BL EMIT ;

: SPACES BEGIN DUP 0> WHILE SPACE 1- REPEAT DROP ;

: ROLL DUP 0>
  IF
    DUP 1+ PICK >R
    DUP 1- BEGIN ROT >R 1- DUP 0< UNTIL DROP NIP
    BEGIN R> SWAP 1- DUP 0= UNTIL DROP R>
  ELSE
    DROP
  THEN
;

: MOVE
  >R 2DUP U<
  IF
    R> CMOVE>
  ELSE
    R> CMOVE
  THEN
;

\ -----------------------------------------------------------------------------

: DEPTH SP0 SP@ - [ 1 CELLS ] LITERAL / 1- ;

: NDROP \ (S xn ... x1 n -- ) 
\ Take n off the data stack. Remove n items from the data stack.
\ If n is zero, just remove n.
  DUP 0>=
  IF
    DEPTH 1 - MIN 0 ?DO DROP LOOP
  ELSE
    EXC-INVALID-NUM-ARGUMENT THROW
  THEN
;

\ -----------------------------------------------------------------------------

\ -----------------------------------------------------------------------------
\  (S (R (C
\ -----------------------------------------------------------------------------

DEFER (S IMMEDIATE ' ( IS (S

DEFER (R IMMEDIATE ' ( IS (R

DEFER (C IMMEDIATE ' ( IS (C

\ -----------------------------------------------------------------------------

: ON TRUE SWAP ! ;

: OFF FALSE SWAP ! ;

\ -----------------------------------------------------------------------------

: CELLS+ CELLS + ;

: CELLS- CELLS - ;

: CELL- 1 CELLS- ;

: CHARS+ CHARS + ;

: CHARS- CHARS - ;

: CHAR- 1 CHARS- ;

: BYTES ;

: BYTES+ BYTES + ;

: BYTES- BYTES - ;

: BYTE+ 1 BYTES+ ;

: BYTE- 1 BYTES- ;

: /WORDS 2* ;

: WORDS+ /WORDS + ;

: WORDS- /WORDS - ;

: WORD+ 1 WORDS+ ;

: WORD- 1 WORDS- ;

\ -----------------------------------------------------------------------------
\  BINARY OCTAL DECIMAL HEX [BINARY] [OCTAL] [DECIMAL] [HEX]
\ -----------------------------------------------------------------------------

: BINARY   2 BASE ! ;

: OCTAL    8 BASE ! ;

: DECIMAL 10 BASE ! ;

: HEX     16 BASE ! ;

: [BINARY]  BINARY  ; IMMEDIATE

: [OCTAL]   OCTAL   ; IMMEDIATE

: [DECIMAL] DECIMAL ; IMMEDIATE

: [HEX]     HEX     ; IMMEDIATE

REPORT-NEW-NAME !
