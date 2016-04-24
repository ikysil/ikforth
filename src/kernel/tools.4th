\
\  tools.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  TOOLS and TOOLS-EXT wordsets
\

REQUIRES" src/kernel/console.4th"

CR .( Loading TOOLS definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

:  .S [']  .R N.S ;

: U.S ['] U.R N.S ;

: >PRINTABLE (S c -- printable_c )
  DUP BL 127 WITHIN INVERT
  IF   DROP '.'   THEN
;

VARIABLE DUMP/LINE

8 DUMP/LINE !

: #DUMP-HEX (S addr len -- )
  OVER + 1-
  DO BL HOLD I C@ 0 # # 2DROP -1 +LOOP
;

: #DUMP-CHAR (S addr len -- )
  OVER + 1-
  DO I C@ >PRINTABLE HOLD -1 +LOOP
;

: DUMP (S addr len -- )
  BASE @ HEX
  DUMP/LINE  @ 4 MAX 16 MIN
  2SWAP \ addr len base dump/line -- base dump/line addr len
  OVER + SWAP
  DO <#
    I OVER 2DUP
    S"  |" HOLDS
    #DUMP-CHAR
    S" | " HOLDS
    #DUMP-HEX
    I BL HOLD BL HOLD 0 # # # # # # # # #> TYPE CR
  DUP +LOOP
  DROP
  BASE !
;

: ?
  @ .
;

: WORD-ATTR (S h-id -- )
  HFLAGS@
  DUP &IMMEDIATE    AND IF ." IMMEDIATE "    THEN
  DUP &HIDDEN       AND IF ." HIDDEN "       THEN
  DUP &COMPILE-ONLY AND IF ." COMPILE-ONLY " THEN
      &LOCATE       AND IF ." LOCATE "       THEN
;

: ?UPCASE
  CASE-SENSITIVE @ 0=
  IF
    DUP [CHAR] a [CHAR] z WITHIN
    IF
      [ CHAR a CHAR A - ] LITERAL -
    THEN
  THEN
;

: ?WORDS ?UPCASE GET-CURRENT (GET-ORDER) ?DUP 0>
         IF OVER SET-CURRENT NDROP
            0 LATEST-HEAD@
            BEGIN ?DUP 0<> WHILE
              DUP HEAD>NAME DUP COUNT DUP
              IF
                OVER C@ ?UPCASE 7 PICK =
                IF TYPE SPACE SWAP WORD-ATTR CR
                   SWAP 1+
                   DUP 20 MOD 0=
                   IF DUP . ." word(s), press Q to exit, any other key to continue"
                      KEY DUP [CHAR] Q = SWAP [CHAR] q = OR
                      IF 2DROP SET-CURRENT EXIT THEN CR
                   THEN
                   SWAP
                ELSE
                  2DROP NIP
                THEN
              ELSE
                2DROP NIP
              THEN
              NAME> >LINK @
            REPEAT
            . ." word(s) total" CR
         THEN
         SET-CURRENT DROP
;

: WORDLIST-WORDS (S wid -- )
  DUP ." Wordlist: " .WORDLIST-NAME CR CR
  WL>LATEST @
  0 SWAP
  BEGIN
    ?DUP 0<>
  WHILE
    DUP H>#NAME DUP 0<>
    IF
      TYPE SPACE DUP WORD-ATTR CR
      SWAP 1+
      DUP 20 MOD 0=
      IF
        DUP . ." word(s), press Q to exit, any other key to continue"
        KEY DUP [CHAR] Q = SWAP [CHAR] q = OR
        IF 2DROP EXIT THEN
        CR
      THEN
      SWAP
    ELSE
      2DROP
    THEN
    H>NEXT>H
  REPEAT
  . ." word(s) total" CR
;

: WORDS
  (GET-ORDER) ?DUP 0>
  IF OVER >R NDROP R> WORDLIST-WORDS THEN
;

: .INCLUDED-LIST (S -- )
  INCLUDED-WORDLIST WORDLIST-WORDS
;

: (WORDS-COUNT) (S wid -- word count in wordlist )
  WL>LATEST @
  0 SWAP
  BEGIN
    DUP 0<>
  WHILE
    DUP H>#NAME NIP 0<> \ check for :NONAME, don't count them
    IF SWAP 1+ SWAP THEN
    H>NEXT>H
  REPEAT
  DROP ;

: WORDS-COUNT (S -- word count in first wordlist )
  (GET-ORDER) ?DUP 0>
  IF OVER >R NDROP R> (WORDS-COUNT) ELSE 0 THEN
;

: AHEAD
  POSTPONE BRANCH >MARK IF-PAIRS
; IMMEDIATE/COMPILE-ONLY

VOCABULARY ASSEMBLER

VOCABULARY EDITOR

: [ELSE]
  1 BEGIN
    BEGIN
      BL WORD COUNT DUP
    WHILE
      2DUP S" [IF]" COMPARE 0=
      IF
        2DROP 1+
      ELSE
        2DUP S" [ELSE]" COMPARE 0=
        IF
          2DROP 1- DUP IF 1+ THEN
        ELSE
          S" [THEN]" COMPARE 0=
          IF 1- THEN
        THEN
      THEN
      ?DUP 0= IF EXIT THEN
    REPEAT 2DROP
    REFILL 0=
  UNTIL DROP
; IMMEDIATE

: [IF]
  0= IF POSTPONE [ELSE] THEN
; IMMEDIATE

: [THEN] ; IMMEDIATE

DEFER CS-PICK
' 2PICK IS CS-PICK

DEFER CS-ROLL
' 2ROLL IS CS-ROLL

\ -----------------------------------------------------------------------------
\  ALIAS SYNONYM
\ -----------------------------------------------------------------------------
: ALIAS
  \ (S xt "<spaces>name" -- )
  \ (S ... -- ... )  \ executing
  \ (G Create a name with an execution semantics of xt. )
  CREATE ,
  DOES> @ EXECUTE
;

: SYNONYM
  \ (S "<spaces>newname" "<spaces>oldname" -- )
  \ (G Create a new definition which redirects to an existing one. )
  CREATE IMMEDIATE
    HIDE ' , REVEAL
  DOES>
    @ STATE @ 0= OVER IMMEDIATE? OR
    IF EXECUTE ELSE COMPILE, THEN
;

\ -----------------------------------------------------------------------------
\   NAME>STRING NAME>COMPILE
\ -----------------------------------------------------------------------------

\  15.6.2.1909.40 NAME>STRING
\  ( nt -- c-addr u )
: NAME>STRING
   (S nt -- c-addr u )
   (G NAME>STRING returns the name of the word nt in the character string c-addr u.
      The case of the characters in the string is implementation-dependent.
      The buffer containing c-addr u may be transient and valid until the next invocation of NAME>STRING.
      A program shall not write into the buffer containing the resulting string. )
   H>#NAME
;

\  15.6.2.1909.10 NAME>COMPILE
\  ( nt -- x xt )
: NAME>COMPILE
   (S nt -- x xt )
   (G x xt represents the compilation semantics of the word nt.
      The returned xt has the stack effect [ i * x x -- j * x ].
      Executing xt consumes x and performs the compilation semantics of the word represented by nt. )
   HEAD> DUP IMMEDIATE? IF  ['] EXECUTE  ELSE  ['] COMPILE,  THEN
;

REPORT-NEW-NAME !
