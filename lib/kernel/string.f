\
\  string.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  STRING words
\

CR .( Loading STRING definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: -TRAILING
  BEGIN
    2DUP CHAR- + @ BL = OVER 0> AND
  WHILE
    CHAR-
  REPEAT ;

: /STRING
  2DUP < IF DROP DUP THEN ROT OVER + -ROT - ;

: SEARCH
  2 PICK OVER U< IF 2DROP FALSE EXIT THEN
  2SWAP 2DUP 2>R DUP 3 PICK - 1+ 0
  DO
    3 PICK 3 PICK 3 PICK OVER COMPARE 0=
    IF 2SWAP 2DROP UNLOOP 2R> 2DROP TRUE EXIT THEN
    1- SWAP CHAR+ SWAP
  LOOP
  2DROP 2DROP
  2R> FALSE ;

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

CREATE-REPORT !
