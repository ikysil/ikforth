PURPOSE: TOOLS definitions - TOOLS and TOOLS-EXT wordsets
LICENSE: Unlicense since 1999 by Illya Kysil

REQUIRES" sysdict/console.4th"

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

: ?WORDS
   ?UPCASE GET-CURRENT (GET-ORDER) ?DUP 0>
   IF OVER SET-CURRENT NDROP
      0 LATEST-HEAD@
      BEGIN ?DUP 0<> WHILE
         DUP DUP NAME>STRING DUP
         IF
            OVER C@ ?UPCASE 7 PICK =
            IF
               TYPE SPACE SWAP WORD-ATTR CR
               SWAP 1+
               DUP 20 MOD 0=
               IF DUP . ." word(s), press Q to exit, any other key to continue"
                  KEY DUP [CHAR] Q = SWAP [CHAR] q = OR
                  IF
                     DROP 2DROP SET-CURRENT
                     EXIT
                  THEN CR
               THEN
               SWAP
            ELSE
               2DROP NIP
            THEN
         ELSE
            2DROP NIP
         THEN
         NAME>NEXT
      REPEAT
      . ." word(s) total" CR
   THEN
   SET-CURRENT DROP
;

: .WL-WORD (S count nt -- count true | count false )
   DUP NAME>STRING DUP 0<>
   IF
      CR TYPE SPACE WORD-ATTR
      1+ DUP 20 MOD 0=
      IF
         DUP
         CR . ." word(s), press Q to exit, any other key to continue"
         KEY DUP [CHAR] Q = SWAP [CHAR] q = OR
         IF  FALSE EXIT  THEN
      THEN
   ELSE
      2DROP DROP
   THEN
   TRUE
;

: WORDLIST-WORDS (S wid -- )
   DUP ." Wordlist: " .WORDLIST-NAME CR
   0 ['] .WL-WORD ROT TRAVERSE-WORDLIST
   CR . ." word(s) total"
;

: WORDS (S -- )
   (GET-ORDER) ?DUP 0>
   IF OVER >R NDROP R> WORDLIST-WORDS THEN
;

: .INCLUDED-LIST (S -- )
   INCLUDED-WORDLIST WORDLIST-WORDS
;

: .WL-COUNT (S count nt -- count true | count false )
   NAME>STRING 0<> \ check for :NONAME, don't count them
   NIP IF  1+  THEN
   TRUE
;

: WORDS-COUNT (S -- word count in first wordlist )
   (GET-ORDER) ?DUP 0>
   IF
      OVER >R NDROP R>
      0 ['] .WL-COUNT ROT TRAVERSE-WORDLIST
   ELSE
      0
   THEN
;

: AHEAD
   POSTPONE BRANCH >MARK IF-PAIRS
; IMMEDIATE/COMPILE-ONLY

VOCABULARY ASSEMBLER

VOCABULARY EDITOR

: [DEFINED] (S "name" -- flag )
   ['] ' CATCH ?DUP
   IF
      DUP EXC-UNDEFINED = IF   DROP FALSE   ELSE   THROW   THEN
   ELSE
      DROP TRUE
   THEN
; IMMEDIATE

: [UNDEFINED] (S "name" -- flag )
   ['] ' CATCH ?DUP
   IF
      DUP EXC-UNDEFINED = IF   DROP TRUE   ELSE   THROW   THEN
   ELSE
      DROP FALSE
   THEN
; IMMEDIATE

: [VOID] (S -- FALSE )
   FALSE
; IMMEDIATE

\ -----------------------------------------------------------------------------
\   [IF] [ELSE] [THEN]
\ -----------------------------------------------------------------------------
WORDLIST DUP CONSTANT BRACKET-FLOW-WL GET-CURRENT SWAP SET-CURRENT

: [IF]   ( level1 -- level2 ) 1+ ;
: [ELSE] ( level1 -- level2 ) DUP 1 = IF   1-   THEN ;
: [THEN] ( level1 -- level2 ) 1- ;
SET-CURRENT

: [ELSE] ( -- )
   1 BEGIN BEGIN PARSE-NAME DUP WHILE
      BRACKET-FLOW-WL SEARCH-WORDLIST IF
         EXECUTE DUP 0= IF   DROP EXIT   THEN
      THEN
   REPEAT 2DROP REFILL 0= UNTIL DROP
; IMMEDIATE

: [THEN] ( -- ) ; IMMEDIATE

: [IF] ( flag -- ) 0= IF   POSTPONE [ELSE]   THEN ; IMMEDIATE

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
\   NAME>COMPILE NAME>INTERPRET
\ -----------------------------------------------------------------------------

\  15.6.2.1909.10 NAME>COMPILE
\  ( nt -- x xt )
: NAME>COMPILE
   (S nt -- x xt )
   (G x xt represents the compilation semantics of the word nt.
      The returned xt has the stack effect [ i * x x -- j * x ].
      Executing xt consumes x and performs the compilation semantics of the word represented by nt. )
   NAME>CODE DUP IMMEDIATE? IF  ['] EXECUTE  ELSE  ['] COMPILE,  THEN
;

\  15.6.2.1909.20 NAME>INTERPRET
\  ( nt -- xt | 0 )
: NAME>INTERPRET
   (S nt -- xt | 0 )
   (G xt represents the interpretation semantics of the word nt.
      If nt has no interpretation semantics, NAME>INTERPRET returns 0.)
   NAME>CODE DUP COMPILE-ONLY? IF  DROP 0  THEN
;

REPORT-NEW-NAME !
