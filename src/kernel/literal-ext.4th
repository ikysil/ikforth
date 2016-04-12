\
\  literal-ext.f
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
    BL WORD COUNT INTERPRET-LITERAL
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

: INTERPRET-LITERAL-IN-BASE (S c-addr u n -- flag )
  BASE DUP @ >R !
  INTERPRET-LITERAL
  R> BASE !
;

DECIMAL

:NONAME (S c-addr u -- )
  STRIP-PREFIX-CHAR
  IF
    DROP C@ DO-LIT
    EXIT
  THEN
  STRIP-PREFIX-BINARY
  IF
    2 INTERPRET-LITERAL-IN-BASE
    IF EXIT THEN
  THEN
  STRIP-PREFIX-OCTAL
  IF
    8 INTERPRET-LITERAL-IN-BASE
    IF EXIT THEN
  THEN
  STRIP-PREFIX-DECIMAL
  IF
    10 INTERPRET-LITERAL-IN-BASE
    IF EXIT THEN
  THEN
  STRIP-PREFIX-HEX
  IF
    16 INTERPRET-LITERAL-IN-BASE
    IF EXIT THEN
  THEN
  DEFERRED INTERPRET-WORD-NOT-FOUND
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
