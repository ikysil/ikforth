\
\  literal-ext.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading LITERAL-EXT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ Extended literal support
\ Binary literals:      B# <literal>, %<literal>, \b<literal>, \B<literal>
\ Octal literals:       O# <literal>, @<literal>, \o<literal>, \O<literal>
\ Decimal literals:     D# <literal>, #<literal>, &<literal>
\ Hexadecimal literals: H# <literal>, $<literal>, 0x<literal>, 0X<literal>,
\                       \x<literal>, \X<literal>, \u<literal>, \U<literal>

: INTERPRET-LITERAL (S c-addr u -- d true | x true | false )
   REC:NUM DUP R:FAIL <>
   IF
      STATE @ IF  R>COMP  ELSE  R>INT  THEN
      EXECUTE TRUE
   ELSE
      DROP FALSE
   THEN
;

\ -----------------------------------------------------------------------------
\  B# O# D# H#
\ -----------------------------------------------------------------------------

: PARSE-IN-BASE
  (G Define a word with semantics to parse the next word )
  (G as literal in specified BASE )
  CREATE
  (S base -- )
    IMMEDIATE
    ,
    LATEST-HEAD@
    ,
  DOES>
  (S "literal" -- )
    DUP CELL+ @ >R @ \ S: base R: head
    BASE DUP @ >R !
    PARSE-NAME INTERPRET-LITERAL
    R> BASE !
    INVERT IF EXC-INVALID-LITERAL R> (COMP-THROW) ELSE R> DROP THEN
;

DECIMAL

 2 PARSE-IN-BASE B#

 8 PARSE-IN-BASE O#

10 PARSE-IN-BASE D#

16 PARSE-IN-BASE H#

: STRIP-PREFIX-BINARY (S c-addr u -- c-addr u flag )
\ check for 1 char prefixes
  2DUP 1 > INVERT IF DROP FALSE EXIT THEN
  C@ >R
  R@ [CHAR] % =
  R> DROP
  ?DUP
  IF
    >R SWAP CHAR+ SWAP 1 - R>
    EXIT
  THEN
\ check for 2 chars prefixes
  2DUP 2 > INVERT IF DROP FALSE EXIT THEN
\ check for \b, \B prefixes
  C@+
  >R
  R@ [CHAR] \ =
  R> DROP
  SWAP C@
  >R
  R@ [CHAR] b =
  R@ [CHAR] B = OR
  R> DROP
  AND
  ?DUP
  IF
    >R SWAP [ 2 CHARS ] LITERAL + SWAP 2 - R>
    EXIT
  THEN
  FALSE
;

: STRIP-PREFIX-OCTAL (S c-addr u -- c-addr u flag )
\ check for 1 char prefixes
  2DUP 1 > INVERT IF DROP FALSE EXIT THEN
  C@ >R
  R@ [CHAR] @ =
  R> DROP
  ?DUP
  IF
    >R SWAP CHAR+ SWAP 1 - R>
    EXIT
  THEN
\ check for 2 chars prefixes
  2DUP 2 > INVERT IF DROP FALSE EXIT THEN
\ check for \o, \O prefixes
  C@+
  >R
  R@ [CHAR] \ =
  R> DROP
  SWAP C@
  >R
  R@ [CHAR] o =
  R@ [CHAR] O = OR
  R> DROP
  AND
  ?DUP
  IF
    >R SWAP [ 2 CHARS ] LITERAL + SWAP 2 - R>
    EXIT
  THEN
  FALSE
;

: STRIP-PREFIX-DECIMAL (S c-addr u -- c-addr u flag )
\ check for 1 char prefixes
  2DUP 1 > INVERT IF DROP FALSE EXIT THEN
  C@ >R
  R@ [CHAR] # =
  R@ [CHAR] & = OR
  R> DROP
  ?DUP
  IF
    >R SWAP CHAR+ SWAP 1 - R>
    EXIT
  THEN
  FALSE
;

: STRIP-PREFIX-HEX (S c-addr u -- c-addr u flag )
\ check for 1 char prefixes
  2DUP 1 > INVERT IF DROP FALSE EXIT THEN
  C@ >R
  R@ [CHAR] $ =
  R> DROP
  ?DUP
  IF
    >R SWAP CHAR+ SWAP 1 - R>
    EXIT
  THEN
\ check for 2 chars prefixes
  2DUP 2 > INVERT IF DROP FALSE EXIT THEN
\ check for 0x, 0X, \x, \X, \u, \U prefixes
  C@+
  >R
  R@ [CHAR] 0 =
  R@ [CHAR] \ = OR
  R> DROP
  SWAP C@
  >R
  R@ [CHAR] x =
  R@ [CHAR] X = OR
  R@ [CHAR] u = OR
  R@ [CHAR] U = OR
  R> DROP
  AND
  ?DUP
  IF
    >R SWAP [ 2 CHARS ] LITERAL + SWAP 2 - R>
    EXIT
  THEN
  FALSE
;

: STRIP-PREFIX-CHAR (S c-addr u -- c-addr u flag )
\ <cnum>:='<char>'
  2DUP 3 <> IF DROP FALSE EXIT THEN
  DUP 2 CHARS +
  C@ [CHAR] ' =
  SWAP
  C@ [CHAR] ' =
  AND
  IF
    DROP CHAR+ 1 TRUE
  ELSE
    FALSE
  THEN
;

: INTERPRET-LITERAL-IN-BASE (S c-addr u n -- d true | x true | false )
   BASE DUP @ >R !
   INTERPRET-LITERAL
   R> BASE !
;

DECIMAL

: DO-LIT
   (S n -- n ) \ INTERPRET
   (S n -- )   \ COMPILE
   STATE @ IF  POSTPONE LITERAL  THEN
;

: INTERPRET-PREFIXED-LITERAL (S c-addr u n xt -- c-addr u false | x*j true )
   (G xt - word to check prefix, n - conversion base )
   2SWAP 2>R \ S: n xt
   2R@ ROT   \ S: n c-addr u xt
   EXECUTE
   IF
      \ S: n c-addr' u' R: c-addr u
      ROT INTERPRET-LITERAL-IN-BASE
      \ S: d true | x true | false R: c-addr u
      DUP IF  2R> 2DROP  ELSE  2R> ROT  THEN
   ELSE
      \ S: n c-addr u R: c-addr u
      DROP 2DROP 2R> FALSE
   THEN
;

:NONAME (S c-addr u -- )
   STRIP-PREFIX-CHAR
   IF  DROP C@ DO-LIT EXIT  THEN

   2  ['] STRIP-PREFIX-BINARY
   INTERPRET-PREFIXED-LITERAL IF  EXIT  THEN

   8  ['] STRIP-PREFIX-OCTAL
   INTERPRET-PREFIXED-LITERAL IF  EXIT  THEN

   10 ['] STRIP-PREFIX-DECIMAL
   INTERPRET-PREFIXED-LITERAL IF  EXIT  THEN

   16 ['] STRIP-PREFIX-HEX
   INTERPRET-PREFIXED-LITERAL IF  EXIT  THEN

   DEFERRED INTERPRET-WORD-NOT-FOUND
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
