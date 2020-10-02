PURPOSE: PRIMITIVES definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
FALSE REPORT-NEW-NAME !

\ -----------------------------------------------------------------------------
\  [ ] ; :
\ -----------------------------------------------------------------------------

\ [
(DO-:) &IMMEDIATE/COMPILE-ONLY PARSE-CHECK-HEADER, [ DROP
   TRUE STATE ! \ entering compilation state
   FALSE STATE ! (;)
[

\ ]
(DO-:) &USUAL PARSE-CHECK-HEADER, ] DROP
   TRUE STATE ! \ entering compilation state
   TRUE STATE ! (;)
[

\ ;
(DO-:) &IMMEDIATE/COMPILE-ONLY PARSE-CHECK-HEADER, ; DROP
]
   POSTPONE (;) &HIDDEN RESET-HFLAGS! 0 RECURSE-XT ! POSTPONE [ (;)
[

\ :
(DO-:) &HIDDEN PARSE-CHECK-HEADER, : DROP
]
   (DO-:) &HIDDEN PARSE-CHECK-HEADER, RECURSE-XT ! ]
;

\ -----------------------------------------------------------------------------
\  IMMEDIATE IMMEDIATE? COMPILE-ONLY IMMEDIATE/COMPILE-ONLY
\ -----------------------------------------------------------------------------

: IMMEDIATE
   &IMMEDIATE SET-HFLAGS!
;

: IMMEDIATE?
   \ (S xt -- flag )
   \ (G Check if word identified by xt is an immediate word. )
   CODE>NAME HFLAGS@ &IMMEDIATE AND 0<>
;

: COMPILE-ONLY
   &COMPILE-ONLY SET-HFLAGS!
;

: COMPILE-ONLY?
   \ (S xt -- flag )
   \ (G Check if word identified by xt is a compile-only word. )
   CODE>NAME HFLAGS@ &COMPILE-ONLY AND 0<>
;

: IMMEDIATE/COMPILE-ONLY
   &IMMEDIATE/COMPILE-ONLY SET-HFLAGS!
;

\ -----------------------------------------------------------------------------
\  HIDE REVEAL
\ -----------------------------------------------------------------------------

: HIDE
   &HIDDEN SET-HFLAGS!
;

: REVEAL
   &HIDDEN RESET-HFLAGS!
;

\ -----------------------------------------------------------------------------
\  $NEXT
\ -----------------------------------------------------------------------------

: $NEXT
   \ Compile $NEXT primitive of inner interpreter at HERE
   HERE $NEXT-CODE-SIZE ALLOT $NEXT!
;

\ -----------------------------------------------------------------------------
\  CONSTANT VARIABLE USER USER-ALLOC CODE END-CODE ;CODE :NONAME
\  (DO-CREATE) CREATE (DO-DOES>) DOES>
\ -----------------------------------------------------------------------------

\ 6.1.0950 CONSTANT
: CONSTANT
   (DO-CONSTANT) &USUAL PARSE-CHECK-HEADER, DROP ,
;

: VARIABLE
   (DO-VARIABLE) &USUAL PARSE-CHECK-HEADER, DROP 0 ,
;

: USER       \ "name" --
   (DO-USER) &USUAL PARSE-CHECK-HEADER, DROP USER-SIZE-VAR @ ,
;

: USER-ALLOC \ user-size --
   USER-SIZE-VAR SWAP OVER @ + SWAP !
;

: CODE \ (S "name" -- )
   0 &USUAL PARSE-CHECK-HEADER, DROP
;

: END-CODE
; IMMEDIATE \ do nothing

: (;CODE)
   R> LATEST-HEAD@ NAME>CODE CFA!
;

: ;CODE
   &HIDDEN RESET-HFLAGS! POSTPONE (;CODE) POSTPONE [
; IMMEDIATE/COMPILE-ONLY

: :NONAME
   (DO-:) 0 0 &HIDDEN HEADER, DUP RECURSE-XT ! ]
;

: CREATE
   (DO-CREATE) &USUAL PARSE-CHECK-HEADER, DROP
;

: (DOES)
   R> LATEST-HEAD@ NAME>CODE CFA!
;

: DOES>
   0 RECURSE-XT !
   POSTPONE (DOES)
   (DO-DOES>) CALL,
; IMMEDIATE/COMPILE-ONLY

REPORT-NEW-NAME !
