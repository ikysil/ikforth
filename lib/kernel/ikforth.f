\
\  ikforth.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CREATE-REPORT @
\ TRUE CREATE-REPORT !

\ -----------------------------------------------------------------------------
\  [ ] ; :
\ -----------------------------------------------------------------------------

\ [
(DO-:) &IMMEDIATE/COMPILE-ONLY PARSE-CHECK-HEADER, [ DROP
   TRUE STATE ! \ entering compilation state
  FALSE STATE ! (;) [

\ ]
(DO-:) &USUAL PARSE-CHECK-HEADER, ] DROP
   TRUE STATE ! \ entering compilation state
   TRUE STATE ! (;) [

\ ;
(DO-:) &IMMEDIATE/COMPILE-ONLY PARSE-CHECK-HEADER, ; DROP ]
  POSTPONE (;) &HIDDEN RESET-HFLAGS! POSTPONE [ (;)
[

\ :
(DO-:) &HIDDEN PARSE-CHECK-HEADER, : DROP ]
  (DO-:) &HIDDEN PARSE-CHECK-HEADER, DROP ] ;

\ -----------------------------------------------------------------------------
\  IMMEDIATE COMPILE-ONLY IMMEDIATE/COMPILE-ONLY
\ -----------------------------------------------------------------------------

: IMMEDIATE &IMMEDIATE SET-HFLAGS! ;

: COMPILE-ONLY &COMPILE-ONLY SET-HFLAGS! ;

: IMMEDIATE/COMPILE-ONLY &IMMEDIATE/COMPILE-ONLY SET-HFLAGS! ;

\ -----------------------------------------------------------------------------
\  CHAR [CHAR] .(
\ -----------------------------------------------------------------------------

: CHAR BL WORD COUNT DROP C@ ;

: [CHAR] CHAR POSTPONE LITERAL ; IMMEDIATE/COMPILE-ONLY

: PARSE)
  [CHAR] ) PARSE
;

: .(
  PARSE) TYPE
; IMMEDIATE

.( Loading IKForth definitions )

\ -----------------------------------------------------------------------------
\  HIDE REVEAL
\ -----------------------------------------------------------------------------

: HIDE   &HIDDEN SET-HFLAGS! ;

: REVEAL &HIDDEN RESET-HFLAGS! ;

\ -----------------------------------------------------------------------------
\  +! @+ !+ C+! C@+ C!+
\ -----------------------------------------------------------------------------

: +! \ (S x addr -- )
  SWAP OVER @ + SWAP ! ;

: @+ \ (S addr1 -- addr2 x )
  DUP CELL+ SWAP @
;

: !+ \ (S x addr1 -- addr2 )
  DUP >R ! R> CELL+
;

: C+! \ (S x addr -- )
  SWAP OVER C@ + SWAP C! ;

: C@+ \ (S addr1 -- addr2 x )
  DUP CHAR+ SWAP @
;

: C!+ \ (S x addr1 -- addr2 )
  DUP >R ! R> CHAR+
;

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

\ -----------------------------------------------------------------------------
\  CHARS ALIGN ALIGNED
\ -----------------------------------------------------------------------------

: CHARS ;

: ALIGN ;

: ALIGNED ;

\ -----------------------------------------------------------------------------
\  VARIABLE USER USER-ALLOC ;CODE :NONAME CREATE DOES>
\ -----------------------------------------------------------------------------

: VARIABLE
  (DO-VARIABLE) &USUAL PARSE-CHECK-HEADER, DROP 0 , ;

: USER       \ "name" -- 
  (DO-USER) &USUAL PARSE-CHECK-HEADER, DROP USER-SIZE-VAR @ , ;

: USER-ALLOC \ user-size --
  USER-SIZE-VAR +! ;

: (;CODE) R> LATEST-HEAD@ HEAD> ! ;

: ;CODE &HIDDEN RESET-HFLAGS! POSTPONE (;CODE) POSTPONE [ ; IMMEDIATE/COMPILE-ONLY

HEX

: $NEXT
  AD C,           \ LODSD
  8B C, 18 C,     \ MOV   EBX,[DWORD PTR EAX]
  FF C, E3 C, ;   \ JMP   [DWORD PTR EBX]

: :NONAME
  (DO-:) 0 0 &HIDDEN HEADER, ] ;

: CREATE
  (DO-CREATE) &USUAL PARSE-CHECK-HEADER, DROP ;

: (DOES)
  R> LATEST-HEAD@ HEAD> ! ;

: DOES>
  POSTPONE (DOES)
  E8 C,                         \ CALL rel
  (DO-DOES>) HERE - 4 - ,
; IMMEDIATE/COMPILE-ONLY

DECIMAL

\ -----------------------------------------------------------------------------

CREATE CR-STR 2 C, 13 C, 10 C,

: CR CR-STR COUNT TYPE ;

\ -----------------------------------------------------------------------------
\  PARSE" (C") ,C" C" ,S" SLITERAL
\ -----------------------------------------------------------------------------

: PARSE" \ (S string" -- c-addr count )
  [CHAR] " PARSE
;

: (C") R> DUP COUNT + ALIGNED >R ;

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

: */ >R M* R> SM/REM SWAP DROP ;

: */MOD >R M* R> SM/REM ;

: / >R S>D R> SM/REM SWAP DROP ;

: /MOD >R S>D R> SM/REM ;

: MOD >R S>D R> SM/REM DROP ;

: WITHIN OVER - >R - R> U< ;

\ -----------------------------------------------------------------------------

: DEPTH SP0 SP@ - [ 1 CELLS ] LITERAL / 1- ;

\ -----------------------------------------------------------------------------
\  INT/COMP:
\ -----------------------------------------------------------------------------

: INT/COMP:
  (DO-INT/COMP) &IMMEDIATE PARSE-CHECK-HEADER, DROP SWAP , , ;

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

: THEN 2 ?PAIRS >RESOLVE ; IMMEDIATE/COMPILE-ONLY

: ELSE 2 ?PAIRS POSTPONE BRANCH >MARK SWAP >RESOLVE 2 ; IMMEDIATE/COMPILE-ONLY

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

: (COMP-THROW) \ (S exc-id throw-word -- )
  R@ [ 1 CELLS ] LITERAL - THROW-ADDRESS ! THROW-WORD ! ?DUP
  IF (THROW) ELSE 0 DUP THROW-ADDRESS ! THROW-WORD ! THEN ;

\ :NONAME 0 DUP THROW-ADDRESS ! THROW-WORD ! THROW ;
' THROW
:NONAME LATEST-HEAD@ HEAD>NAME POSTPONE LITERAL POSTPONE (COMP-THROW) ;
INT/COMP: THROW

: ABORT -1 THROW ;

USER ABORT"-MESSAGE 2 CELLS USER-ALLOC

: (ABORT") ABORT"-MESSAGE 2! IF EXC-ABORT" THROW THEN ;
: ABORT" POSTPONE S" POSTPONE (ABORT") ; IMMEDIATE/COMPILE-ONLY

\ -----------------------------------------------------------------------------
\  DEFER IS DEFER@
\ -----------------------------------------------------------------------------

:NONAME TRUE ABORT" un-initialized DEFER" ; CONSTANT (DEFUALT-DEFER)
: DEFER (DO-DEFER) &USUAL PARSE-CHECK-HEADER, DROP (DEFUALT-DEFER) COMPILE, ;

:NONAME ' >BODY ! ;
:NONAME ' >BODY POSTPONE LITERAL POSTPONE ! ;
INT/COMP: IS

:NONAME ' >BODY @ ;
:NONAME ' >BODY POSTPONE LITERAL POSTPONE @ ;
INT/COMP: DEFER@

:NONAME - IF EXC-CONTROL-MISMATCH THROW THEN ; IS ?PAIRS

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

: FM/MOD 2DUP XOR 0<
         IF
           >R R@ SM/REM OVER
           IF
             1- SWAP R> + SWAP
           ELSE
             R> DROP
           THEN
         ELSE
           SM/REM
         THEN ;

: MAX 2DUP < IF SWAP THEN DROP ;

: MIN 2DUP > IF SWAP THEN DROP ;

: CONVERT COUNT >NUMBER DROP ;

\ -----------------------------------------------------------------------------

: ( SOURCE-ID 0>
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

: EVALUATE
  INPUT>R 0 >IN ! 0 BLK ! -1 SOURCE-ID!
  #EVAL ! EVAL ! ['] INTERPRET CATCH INPUT<R THROW
;

: SAVE-INPUT SOURCE-ID BLK @ >IN @ CURRENT-FILE-POSITION 2@ 5 ;

: RESTORE-INPUT
    5 = IF CURRENT-FILE-POSITION 2! >IN ! BLK ! DUP SOURCE-ID!
           0> IF CURRENT-FILE-POSITION 2@ SOURCE-ID REPOSITION-FILE 0<>
                 REFILL DROP
              ELSE
                 FALSE
              THEN
        ELSE
           TRUE
        THEN ;

: QUERY
  REFILL DROP
;

\ -----------------------------------------------------------------------------

: NDROP \ (S xn ... x1 n -- ) 
\ Take n off the data stack. Remove n items from the data stack.
\ If n is zero, just remove n.
  DUP 0>
  IF
    DEPTH 1 - MIN 0 ?DO DROP LOOP
  ELSE
    EXC-INVALID-NUM-ARGUMENT THROW
  THEN
;

\ -----------------------------------------------------------------------------
\  (S (R (C
\ -----------------------------------------------------------------------------

DEFER (S ' ( IS (S IMMEDIATE

DEFER (R ' ( IS (R IMMEDIATE

DEFER (C ' ( IS (C IMMEDIATE

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
\  $ & B# D# O# H#
\ -----------------------------------------------------------------------------

: &  \ parse word and interpret as octal number
  BASE @ >R
  OCTAL BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: $  \ parse word and interpret as hexadecimal number
  BASE @ >R
  HEX BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: B# \ parse word and interpret as binary number
  BASE @ >R
  BINARY BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: D# \ parse word and interpret as decimal number
  BASE @ >R DECIMAL
  BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: O# \ parse word and interpret as octal number
  BASE @ >R
  OCTAL BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: H# \ parse word and interpret as hexadecimal number
  BASE @ >R
  HEX BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

\ -----------------------------------------------------------------------------

: <= > INVERT ;

: >= < INVERT ;

: WORD-SPLIT DUP $ FF AND SWAP $ FF00 AND 8 RSHIFT ;

: WORD-JOIN $ FF AND 8 LSHIFT SWAP $ FF AND OR ;

: DWORD-SPLIT DUP $ FFFF AND SWAP $ FFFF0000 AND 16 RSHIFT ;

: DWORD-JOIN $ FFFF AND 16 LSHIFT SWAP $ FFFF AND OR ;

: W, WORD-SPLIT SWAP C, C, ;

: W@ @ $ FFFF AND ;

: W! SWAP WORD-SPLIT -ROT OVER C! C! ;

\ -----------------------------------------------------------------------------

DEFER KEY
DEFER KEY?
DEFER EKEY
DEFER EKEY?
DEFER EKEY>CHAR
\ DEFER ACCEPT

USER SPAN 1 CELLS USER-ALLOC

: EXPECT ACCEPT SPAN ! ;

CREATE-REPORT !
