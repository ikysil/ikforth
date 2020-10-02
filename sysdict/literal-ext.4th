PURPOSE: LITERAL-EXT definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ Extended literal support
\ Binary literals:      B# <literal>, %<literal>, \b<literal>, \B<literal>
\ Octal literals:       O# <literal>, @<literal>, \o<literal>, \O<literal>
\ Decimal literals:     D# <literal>, #<literal>, &<literal>
\ Hexadecimal literals: H# <literal>, $<literal>, 0x<literal>, 0X<literal>,
\                       \x<literal>, \X<literal>, \u<literal>, \U<literal>

: CONSUME-LITERAL
   (S c-addr u -- d true | x true | false ) \ interpretation
   (S c-addr u -- true | false )            \ compilation
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
      LATEST-NAME@
      ,
   DOES>
   (S "literal" -- )
      DUP CELL+ @ >R @ \ S: base R: head
      ['] CONSUME-LITERAL SWAP PARSE-NAME 2SWAP BASE-EXECUTE
      INVERT IF  EXC-INVALID-LITERAL R> (COMP-THROW)  ELSE  R> DROP  THEN
;

DECIMAL

 2 PARSE-IN-BASE B#

 8 PARSE-IN-BASE O#

10 PARSE-IN-BASE D#

16 PARSE-IN-BASE H#

\ -----------------------------------------------------------------------------
\  Literal prefixes:
\    Binary:  % \b \B 0b 0B
\    Octal:   @ \o \O 0o 0O
\    Decimal: # &
\    Hex:     $ 0x 0X \x \X \u \U
\ -----------------------------------------------------------------------------

: ?BASE-PREFIX ( c-addr u -- false | c-addr' u' base true )
   DUP 2 < IF  2DROP FALSE EXIT  THEN
   OVER C@
   DUP [CHAR] % = IF  DROP 1 /STRING  2 TRUE EXIT  THEN
   DUP [CHAR] @ = IF  DROP 1 /STRING  8 TRUE EXIT  THEN
   DUP [CHAR] # = IF  DROP 1 /STRING 10 TRUE EXIT  THEN
   DUP [CHAR] & = IF  DROP 1 /STRING 10 TRUE EXIT  THEN
   DUP [CHAR] $ = IF  DROP 1 /STRING 16 TRUE EXIT  THEN
   DUP [CHAR] \ = OVER [CHAR] 0 = OR IF
      DROP
      1 /STRING
      DUP 2 < IF  2DROP FALSE EXIT  THEN
      OVER C@
      DUP [CHAR] b = OVER [CHAR] B = OR IF  DROP 1 /STRING  2 TRUE EXIT  THEN
      DUP [CHAR] o = OVER [CHAR] O = OR IF  DROP 1 /STRING  8 TRUE EXIT  THEN
      DUP [CHAR] u = OVER [CHAR] U = OR IF  DROP 1 /STRING 16 TRUE EXIT  THEN
      DUP [CHAR] x = OVER [CHAR] X = OR IF  DROP 1 /STRING 16 TRUE EXIT  THEN
      DROP 2DROP FALSE EXIT
   THEN
   DROP 2DROP FALSE
;

: ?CHAR-LITERAL (S c-addr u -- c-addr u flag )
\ <cnum>:='<char>'
   2DUP 3 CHARS <> IF  DROP FALSE EXIT  THEN
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

: DO-LIT
   (S n -- n ) \ INTERPRET
   (S n -- )   \ COMPILE
   STATE @ IF  POSTPONE LITERAL  THEN
;

:NONAME (S c-addr u -- )
   ?CHAR-LITERAL IF  DROP C@ DO-LIT EXIT  THEN

   2DUP 2>R
   ?BASE-PREFIX
   IF
      ['] CONSUME-LITERAL SWAP BASE-EXECUTE
      IF  2R> 2DROP EXIT  THEN
   THEN
   2R>

   DEFERRED INTERPRET-WORD-NOT-FOUND
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
