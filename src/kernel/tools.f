\
\  tools.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  TOOLS and TOOLS-EXT wordsets
\

CR .( Loading TOOLS definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

USER .S-PRINT-XT 1 CELLS USER-ALLOC

: PN.S (S print-xt depth -- )
  SWAP .S-PRINT-XT !
  DEPTH 1- MIN
  DUP . ." item" DUP 1 <> IF ." s" THEN ."  on stack" DUP 0>
  IF 0
    DO I 4 MOD 0= IF CR THEN I PICK 14 .S-PRINT-XT @ EXECUTE LOOP
  ELSE
    DROP
  THEN
;

: N.S (S print-xt -- )
  DEPTH 1- PN.S
;

:  .S [']  .R N.S ;

: U.S ['] U.R N.S ;

: H.S BASE @ >R HEX U.S R> BASE ! ;

: >PRINTABLE (S c -- printable_c )
  DUP BL < IF DROP [CHAR] . THEN
;

: DUMP
  OVER BASE @ HEX 2SWAP + ROT
  DO I <#
    0 15 DO DUP I + C@ >PRINTABLE HOLD -1 +LOOP
    0 15 DO BL HOLD DUP I + @ 0 # # 2DROP -1 +LOOP
    BL HOLD BL HOLD 0 # # # # # # # # #> TYPE CR
  16 +LOOP
  BASE !
;

: ?
  @ .
;

: WORD-ATTR (S h-id -- )
  HFLAGS@
  DUP &IMMEDIATE    AND IF ." IMMEDIATE "    THEN
  DUP &HIDDEN       AND IF ." HIDDEN "       THEN
      &COMPILE-ONLY AND IF ." COMPILE-ONLY " THEN
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
  POSTPONE BRANCH >MARK 2
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

DEFER CS-PICK ' PICK IS CS-PICK

DEFER CS-ROLL ' ROLL IS CS-ROLL

REPORT-NEW-NAME !
