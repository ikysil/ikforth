\
\  primitives.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

REPORT-NEW-NAME @
FALSE REPORT-NEW-NAME !

10 EMIT S" Loading PRIMITIVES definitions " TYPE

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
  >HEAD HFLAGS@ &IMMEDIATE AND 0<>
;

: COMPILE-ONLY
  &COMPILE-ONLY SET-HFLAGS!
;

: COMPILE-ONLY?
   \ (S xt -- flag )
   \ (G Check if word identified by xt is a compile-only word. )
   >HEAD HFLAGS@ &COMPILE-ONLY AND 0<>
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

\ B,
\ Reserve one byte of data space and store x in the byte
\ Used to compile machine code
: B, \ (S x -- )
   DP @ TUCK C! 1+ DP !
;

\ -----------------------------------------------------------------------------
\  $NEXT
\ -----------------------------------------------------------------------------

BASE @
16 BASE !

: $NEXT
  \ Compile $NEXT primitive of inner interpreter at HERE
  HERE $NEXT-CODE-SIZE ALLOT $NEXT!
;

BASE !

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
  R> LATEST-HEAD@ HEAD> CFA!
;

: ;CODE
  &HIDDEN RESET-HFLAGS! POSTPONE (;CODE) POSTPONE [
; IMMEDIATE/COMPILE-ONLY

BASE @
16 BASE !

: :NONAME
  (DO-:) 0 0 &HIDDEN HEADER, DUP RECURSE-XT ! ]
;

HERE
  83 B, C0 B, CFA-SIZE B,  \ ADD     EAX,CFA-SIZE
  50 B,                    \ PUSH    EAX
  $NEXT
CONSTANT (DO-CREATE)

: CREATE
  (DO-CREATE) &USUAL PARSE-CHECK-HEADER, DROP
;

: (DOES)
  R> LATEST-HEAD@ HEAD> CFA!
;

: CALL, \ ( addr -- )  \ compile call
  E8 B,
  HERE - 4 - ,
;

\ Run-time semantics of DOES>
\ EAX contains xt of word
\ top of hardware stack contains address of DOES> part
HERE
  83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
  89 B, 75 B, 00 B,        \ MOV     [DWORD PTR EBP],ESI
  5E B,                    \ POP     ESI
  83 B, C0 B, CFA-SIZE B,  \ ADD     EAX,CFA-SIZE
  50 B,                    \ PUSH    EAX
  $NEXT
END-CODE
CONSTANT (DO-DOES>)

: DOES>
  0 RECURSE-XT !
  POSTPONE (DOES)
  (DO-DOES>) CALL,
; IMMEDIATE/COMPILE-ONLY

BASE !

REPORT-NEW-NAME !
