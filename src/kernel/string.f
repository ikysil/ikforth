\
\  string.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  STRING words
\

CR .( Loading STRING definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ 17.6.1.0935 COMPARE 
\ STRING 
\ (S c-addr1 u1 c-addr2 u2 -- n )
\ Compare the string specified by c-addr1 u1 to the string specified by c-addr2 u2.
\ The strings are compared, beginning at the given addresses, character by character,
\ up to the length of the shorter string or until a difference is found.
\ If the two strings are identical, n is zero. If the two strings are identical up to
\ the length of the shorter string, n is minus-one (-1) if u1 is less than u2 and one (1) otherwise.
\ If the two strings are not identical up to the length of the shorter string,
\ n is minus-one (-1) if the first non-matching character in the string specified by c-addr1 u1
\ has a lesser numeric value than the corresponding character in the string specified by c-addr2 u2 and one (1) otherwise.
: COMPARE (S c-addr1 u1 c-addr2 u2 -- n )
  ROT SWAP 2DUP - SGN >R
  MIN 0          \ S: c-addr1 c-addr2 min-u1-u2 flag(0)
  2SWAP >R >R    \ S: min-u1-u2 flag
  BEGIN
    OVER 0<>
  WHILE
    DROP
    R> C@+ SWAP  \ S: min-u1-u2 char1 c-addr1
    R> C@+ SWAP  \ S: min-u1-u2 char1 c-addr1 char2 c-addr2
    >R SWAP >R   \ S: min-u1-u2 char1 char2
    -            \ S: min-u1-u2 flag1
    ?DUP
    IF 
      NIP 0 SWAP \ S: 0 flag
    ELSE
      1- 0       \ S: len-1 0
    THEN
  REPEAT         \ S: 0 flag
  2R> 2DROP
  R> SWAP DUP 0<> IF NIP ELSE DROP THEN SGN NIP
;

: -TRAILING
  BEGIN
    2DUP CHAR- + @ BL = OVER 0> AND
  WHILE
    CHAR-
  REPEAT
;

: /STRING
  2DUP < IF DROP DUP THEN ROT OVER + -ROT -
;

: SEARCH
  2 PICK OVER U< IF 2DROP FALSE EXIT THEN
  2SWAP 2DUP 2>R DUP 3 PICK - 1+ 0
  DO
    3 PICK 3 PICK 3 PICK OVER COMPARE 0=
    IF 2SWAP 2DROP UNLOOP 2R> 2DROP TRUE EXIT THEN
    1- SWAP CHAR+ SWAP
  LOOP
  2DROP 2DROP
  2R> FALSE
;

: SCAN (S c-addr1 count1 char -- c-addr2 count2 )
\ c-addr2 count2 is string c-addr1 count1 from first instance, if any, of char.
  >R
  BEGIN
    DUP
  WHILE
    OVER C@ R@ <>
      WHILE
    1 /STRING
  REPEAT
      THEN
  R> DROP
;

: SKIP (S c-addr1 count1 char -- c-addr2 count2 )
\ c-addr2 count2 is string c-addr1 count1 beyond any leading instances of char.
  >R
  BEGIN
    DUP
  WHILE
    OVER C@ R@ =
      WHILE
    1 /STRING
  REPEAT
      THEN
  R> DROP
;

: LTRIM (S c-addr1 count1 -- c-addr2 count2 )
\ skip leading spaces
  BL SKIP
;

REPORT-NEW-NAME !
