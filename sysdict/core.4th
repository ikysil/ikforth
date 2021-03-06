PURPOSE: CORE definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
FALSE REPORT-NEW-NAME !

\ -----------------------------------------------------------------------------
\  CHAR [CHAR] PARSE) .(
\ -----------------------------------------------------------------------------

: CHAR PARSE-NAME DROP C@ ;

: [CHAR] CHAR POSTPONE LITERAL ; IMMEDIATE/COMPILE-ONLY

: PARSE)
   [CHAR] ) PARSE
;

: .(
   PARSE) TYPE
; IMMEDIATE

\ -----------------------------------------------------------------------------
\  +! @+ !+ C+! C@+ C!+
\ -----------------------------------------------------------------------------

: +! \ (S x addr -- )
   \ Add value on stack to value at addr
   SWAP OVER @ + SWAP !
;

: @+ \ (S addr1 -- addr2 x )
   DUP CELL+ SWAP @
;

: !+ \ (S x addr1 -- addr2 )
   DUP -ROT ! CELL+
;

: C+! \ (S x addr -- )
   SWAP OVER C@ + SWAP C!
;

: C@+ \ (S addr1 -- addr2 x )
   DUP CHAR+ SWAP C@
;

: C!+ \ (S x addr1 -- addr2 )
   DUP -ROT C! CHAR+
;

\ -----------------------------------------------------------------------------
\  ALIGN ALIGNED
\ -----------------------------------------------------------------------------

: ALIGN ;

: ALIGNED ;

\ -----------------------------------------------------------------------------
\  [COMPILE]
\ -----------------------------------------------------------------------------

: [COMPILE] \ (S "name" -- )
   POSTPONE POSTPONE
; IMMEDIATE

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
   HERE 0 COMPILE,
; COMPILE-ONLY

\ Patch forward reference created with >MARK
: >RESOLVE HERE SWAP ! ; COMPILE-ONLY

\ Mark an address for backward reference
: <MARK \ (S -- addr for <RESOLVE )
   HERE
; COMPILE-ONLY

\ Resolve backward reference to address marked by <MARK
: <RESOLVE COMPILE, ; COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  IF ELSE THEN
\ -----------------------------------------------------------------------------

VARIABLE IF-PAIRS

: IF POSTPONE ?BRANCH >MARK IF-PAIRS ; IMMEDIATE/COMPILE-ONLY

: ELSE IF-PAIRS ?PAIRS POSTPONE BRANCH >MARK SWAP >RESOLVE IF-PAIRS ; IMMEDIATE/COMPILE-ONLY

: THEN IF-PAIRS ?PAIRS >RESOLVE ; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  LOOPS
\ -----------------------------------------------------------------------------

VARIABLE BEGIN-PAIRS

: BEGIN <MARK BEGIN-PAIRS ; IMMEDIATE/COMPILE-ONLY

: UNTIL BEGIN-PAIRS ?PAIRS POSTPONE ?BRANCH <RESOLVE ; IMMEDIATE/COMPILE-ONLY

: WHILE POSTPONE ?BRANCH >MARK IF-PAIRS 2SWAP ; IMMEDIATE/COMPILE-ONLY

: REPEAT BEGIN-PAIRS ?PAIRS POSTPONE BRANCH <RESOLVE IF-PAIRS ?PAIRS >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: AGAIN BEGIN-PAIRS ?PAIRS POSTPONE BRANCH <RESOLVE ; IMMEDIATE/COMPILE-ONLY

VARIABLE DO-PAIRS

: DO POSTPONE (DO) >MARK DO-PAIRS ; IMMEDIATE/COMPILE-ONLY

: ?DO POSTPONE (?DO) >MARK DO-PAIRS ; IMMEDIATE/COMPILE-ONLY

: LOOP DO-PAIRS ?PAIRS POSTPONE (LOOP) DUP CELL+ <RESOLVE >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: +LOOP DO-PAIRS ?PAIRS POSTPONE (+LOOP) DUP CELL+ <RESOLVE >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: UNLOOP R> R> DROP R> DROP R> DROP >R ; COMPILE-ONLY

: LOOP>D R> R> SWAP R> SWAP R> SWAP >R ; COMPILE-ONLY

: D>LOOP R> SWAP >R SWAP >R SWAP >R >R ; COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  6.1.2120 RECURSE
\  Interpretation:
\  Interpretation semantics for this word are undefined.
\  Compilation: ( -- )
\  Append the execution semantics of the current definition to the current definition.
\  An ambiguous condition exists if RECURSE appears in a definition after DOES>.
: RECURSE
   RECURSE-XT @ ?DUP IF   COMPILE,   ELSE   EXC-INVALID-RECURSE THROW   THEN
; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  ' [']
\ -----------------------------------------------------------------------------

\ use VARIABLE since DEFER is not available here yet
VARIABLE REC:'

:NONAME
   \ ( addr len -- XT flags R:xxx | R:FAIL )
   \ Recognize word for ' (tick).
   REC:WORD
; REC:' !

: (')
   PARSE-NAME
   2DUP S">POCKET DROP     \ for diagnostics
   DUP 0= IF  EXC-EMPTY-NAME THROW  THEN
   REC:' @ EXECUTE
   R:FAIL = IF  EXC-UNDEFINED THROW  THEN
   DROP
;

: ' (') DUP IS-INT/COMP? IF  INT/COMP>INT  THEN ;

: ['] (') POSTPONE LITERAL ; IMMEDIATE COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  THROW ABORT ABORT"
\ -----------------------------------------------------------------------------

USER THROW-ADDRESS 1 CELLS USER-ALLOC
USER THROW-WORD    1 CELLS USER-ALLOC

: (COMP-THROW) \ (S exc-id throw-word -- )
   R@ [ 1 CELLS ] LITERAL - THROW-ADDRESS ! THROW-WORD ! ?DUP
   IF  (THROW)  ELSE  0 DUP THROW-ADDRESS ! THROW-WORD !  THEN
;

:NONAME 0 DUP THROW-ADDRESS ! THROW-WORD ! THROW ;
:NONAME LATEST-NAME@ POSTPONE LITERAL POSTPONE (COMP-THROW) ;
INT/COMP: THROW

: ABORT -1 THROW ;

USER ABORT"-MESSAGE 2 CELLS USER-ALLOC

: (ABORT") ABORT"-MESSAGE 2! IF EXC-ABORT" THROW THEN ;
: ABORT" POSTPONE S" POSTPONE (ABORT") ; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  DEFER DEFER! DEFER@ IS ACTION-OF [ACTION-OF] DEFERRED
\ -----------------------------------------------------------------------------

USER DEFER-NAME 2 CELLS USER-ALLOC

:NONAME
   DEFER-XT @ CODE>NAME NAME>STRING DEFER-NAME 2!
   EXC-UNINITIALIZED-DEFER THROW
; CONSTANT (DEFAULT-DEFER)

\ 6.2.1173
\ DEFER
: DEFER \ (S "name" -- )
   (DO-DEFER) &USUAL PARSE-CHECK-HEADER, DROP (DEFAULT-DEFER) COMPILE,
;

: ?DEFER \ (S xt -- )
   DUP
   CFA@ (DO-DEFER) <>
   IF
      CODE>NAME NAME>STRING
      DEFER-NAME 2!
      EXC-INVALID-DEFER THROW
   THEN
   DROP
;

\ 6.2.1175
\ DEFER!
: DEFER! \ (S xt2 xt1 -- )
   DUP ?DEFER
   >BODY !
;

\ 6.2.1177
\ DEFER@
: DEFER@ \ (S xt1 -- xt2 )
   >BODY @
;

\ 6.2.1725
\ IS
:NONAME ' DEFER! ;
:NONAME POSTPONE ['] POSTPONE DEFER! ;
INT/COMP: IS

\ 6.2.0698
\ ACTION-OF
:NONAME ' DEFER@ ;
:NONAME POSTPONE ['] POSTPONE DEFER@ ;
INT/COMP: ACTION-OF

: [ACTION-OF]
   \ (S "<spaces>name" -- ) \ compiling
   \ (S -- xt )             \ executing
   \ (G xt is the present execution token that name is set to execute. )
   \ (G I.e., this produces static binding as if name was not deferred. )
   ' DEFER@ POSTPONE LITERAL
; IMMEDIATE/COMPILE-ONLY

: DEFERRED
   \ (S "<spaces>name" -- ) \ compiling
   \ (S ... -- ... )        \ executing
   \ (G Compile the execution of the present execution token that name is set to execute. )
   \ (G I.e., this produces static binding as if name was not deferred. )
   POSTPONE [ACTION-OF] POSTPONE EXECUTE
; IMMEDIATE/COMPILE-ONLY

:NONAME - IF EXC-CONTROL-MISMATCH THROW THEN ; IS ?PAIRS

\ -----------------------------------------------------------------------------

\ -----------------------------------------------------------------------------

\  Return string for CR
DEFER CR-STR \ S: -- c-addr u

CREATE DEF-CR-STR 1 C, 10 C,

:NONAME  DEF-CR-STR COUNT
; IS CR-STR

DEFER CR

:NONAME  CR-STR TYPE
; IS CR

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
         >IN @ 1- SOURCE DROP + C@ [CHAR] ) = IF   EXIT   THEN
         REFILL INVERT
      UNTIL
   ELSE
      PARSE) 2DROP
   THEN
; IMMEDIATE

\ Ignore from this line until the end of stream
: \EOF  ( -- )
   SOURCE-ID 0>
   IF
      BEGIN REFILL INVERT UNTIL
   THEN
   POSTPONE \
;

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

: BUFFER: ( u "<name>" -- ; -- addr )
   CREATE ALLOT
;

\ -----------------------------------------------------------------------------

\ -----------------------------------------------------------------------------
\  (S (R (C (G \G
\ -----------------------------------------------------------------------------

DEFER (S IMMEDIATE ' ( IS (S

DEFER (R IMMEDIATE ' ( IS (R

DEFER (C IMMEDIATE ' ( IS (C

DEFER (G IMMEDIATE ' ( IS (G

DEFER \G IMMEDIATE ' \ IS \G

\ -----------------------------------------------------------------------------
\  \DEBUG-ON \DEBUG-OFF
\ -----------------------------------------------------------------------------

\ \DEBUG-ON makes \DEBUG an empty operation thus
\ all the code in the line after \DEBUG will be interpreted
: \DEBUG-ON  ['] EXIT IS \DEBUG ;

\ \DEBUG-OFF makes \DEBUG equivalent to \ thus
\ all the code in the line after \DEBUG will be ignored
: \DEBUG-OFF ['] \ IS \DEBUG ;

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

\ execute word while specified BASE is active
: BASE-EXECUTE (S i*x xt u -- j*x )
   BASE DUP @ >R !
   CATCH
   R> BASE !
   THROW
;

REPORT-NEW-NAME !
