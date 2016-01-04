\
\  literal-ext.f
\
\  Copyright (C) 1999-2004 Illya Kysil
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

: B# \ parse word and interpret as binary number
  BASE @ >R BINARY
  BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: O# \ parse word and interpret as octal number
  BASE @ >R OCTAL
  BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: D# \ parse word and interpret as decimal number
  BASE @ >R DECIMAL
  BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

: H# \ parse word and interpret as hexadecimal number
  BASE @ >R HEX
  BL WORD INTERPRET-WORD
  R> BASE !
; IMMEDIATE

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

:NONAME (S c-addr u -- )
  STRIP-PREFIX-BINARY
  IF
    BASE @ >R BINARY
    INTERPRET-LITERAL
    R> BASE !
    IF EXIT THEN
  THEN
  STRIP-PREFIX-OCTAL
  IF
    BASE @ >R OCTAL
    INTERPRET-LITERAL
    R> BASE !
    IF EXIT THEN
  THEN
  STRIP-PREFIX-DECIMAL
  IF
    BASE @ >R DECIMAL
    INTERPRET-LITERAL
    R> BASE !
    IF EXIT THEN
  THEN
  STRIP-PREFIX-HEX 
  IF
    BASE @ >R HEX
    INTERPRET-LITERAL
    R> BASE !
    IF EXIT THEN
  THEN
  DEFER@-EXECUTE INTERPRET-WORD-NOT-FOUND
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
