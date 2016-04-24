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
  DP @ TUCK ! 1+ DP !
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
\  (DO-CREATE) CREATE (DO-DOES>) DOES> EXIT
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

\ 6.1.1380 EXIT
CODE EXIT
\ 0 &COMPILE-ONLY PARSE-CHECK-HEADER, EXIT HERE SWAP !
  8B B, 75 B, 00 B,        \ MOV     ESI,[DWORD PTR EBP]
  83 B, C5 B, 1 CELLS B,   \ ADD     EBP,CELL_SIZE
  $NEXT
END-CODE COMPILE-ONLY

BASE !

\ -----------------------------------------------------------------------------
\  IS-INT/COMP? INT/COMP>INT INT/COMP>COMP INT/COMP:
\ -----------------------------------------------------------------------------

: IS-INT/COMP?
   \ S: xt -- flag
   CFA@ (DO-INT/COMP) =
;

: INT/COMP>INT
   \ S: xt -- xt-int
   \ Return xt of interpretation semantics of INT/COMP: word
   >BODY @
;

: INT/COMP>COMP
   \ S: xt -- xt-comp
   \ Return xt of compilation semantics of INT/COMP: word
   >BODY CELL+ @
;

: INT/COMP:
   \ S: xt-int xt-comp "<spaces>name" --
   \ Skip leading space delimiters. Parse name delimited by a space. Create a definition for name with the execution semantics defined below.
   \ name Execution
   \ S: i*x -- j*y
   \ Execute xt-int if in interpretation state.
   \ Execute xt-comp if in compilation state. name is an immediate word.
   (DO-INT/COMP) &IMMEDIATE PARSE-CHECK-HEADER, DROP SWAP , ,
;

\ -----------------------------------------------------------------------------
\  LEAVE I J I' (DO)
\ -----------------------------------------------------------------------------

BASE @
16 BASE !

\ 6.1.1760 LEAVE
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- ) ( R: loop-sys -- )
\ Discard the current loop control parameters. An ambiguous condition exists if they are unavailable.
\ Continue execution immediately following the innermost syntactically enclosing DO ... LOOP or DO ... +LOOP.
CODE LEAVE
  83 B, C5 B, 2 CELLS B,   \ ADD     EBP,CELL_SIZE*2
  8B B, 75 B, 00 B,        \ MOV     ESI,[DWORD PTR EBP]
  83 B, C5 B, 1 CELLS B,   \ ADD     EBP,CELL_SIZE
  $NEXT
END-CODE COMPILE-ONLY

\ 6.1.1680 I
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- n|u ) ( R:  loop-sys -- loop-sys )
\ n|u is a copy of the current (innermost) loop index.
\ An ambiguous condition exists if the loop control parameters are unavailable.
CODE I
  8B B, 45 B, 00 B,        \ MOV     EAX,[DWORD PTR EBP]
  50 B,                    \ PUSH    EAX
  $NEXT
END-CODE COMPILE-ONLY

\ 6.1.1730 J
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- n|u ) ( R: loop-sys1 loop-sys2 -- loop-sys1 loop-sys2 )
\ n|u is a copy of the next-outer loop index.
\ An ambiguous condition exists if the loop control parameters of the next-outer loop, loop-sys1, are unavailable.
CODE J
  8B B, 45 B, 3 CELLS B,   \ MOV     EAX,[DWORD PTR EBP + 3 * CELL_SIZE]
  50 B,                    \ PUSH    EAX
  $NEXT
END-CODE COMPILE-ONLY

\ I'
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- n|u ) ( R:  loop-sys -- loop-sys )
\ n|u is a copy of the current (innermost) loop limit.
\ An ambiguous condition exists if the loop control parameters are unavailable.
CODE I'
  8B B, 45 B, 1 CELLS B,   \ MOV     EAX,[DWORD PTR EBP + 1 * CELL_SIZE]
  50 B,                    \ PUSH    EAX
  $NEXT
END-CODE COMPILE-ONLY

\ (DO)
\ Run-time: ( n1|u1 n2|u2 -- ) ( R: -- loop-sys )
\ Set up loop control parameters with index n2|u2 and limit n1|u1.
\ An ambiguous condition exists if n1|u1 and n2|u2 are not both the same type.
\ Anything already on the return stack becomes unavailable until the loop-control parameters are discarded.
\ loop-sys: leave-addr limit index
CODE (DO)
  AD B,                    \ LODSD
  83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
  89 B, 45 B, 00 B,        \ MOV     [DWORD PTR EBP],EAX
  58 B,                    \ POP     EAX
  5B B,                    \ POP     EBX
  83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
  89 B, 5D B, 00 B,        \ MOV     [DWORD PTR EBP],EBX
  83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
  89 B, 45 B, 00 B,        \ MOV     [DWORD PTR EBP],EAX
  $NEXT
END-CODE

BASE !

REPORT-NEW-NAME !
