\
\  tools.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\
\  TOOLS and TOOLS-EXT wordsets
\

CR .( Loading TOOLS definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: N.S (S depth -- )
  DEPTH 1- MIN
  DUP . ." item" DUP 1 <> IF ." s" THEN ."  on stack" DUP 0>
  IF 0
    DO I 4 MOD 0= IF CR THEN I PICK 14 .R LOOP
  ELSE
    DROP
  THEN ;

: .S DEPTH N.S ;

: >PRINTABLE DUP BL < IF DROP [CHAR] . THEN ;

: DUMP OVER BASE @ HEX 2SWAP + ROT
  DO I <#
    0 15 DO DUP I + C@ >PRINTABLE HOLD -1 +LOOP
    0 15 DO BL HOLD DUP I + @ 0 # # 2DROP -1 +LOOP
    BL HOLD BL HOLD 0 # # # # # # # # #> TYPE CR
  16 +LOOP BASE ! ;

: ? @ . ;

: WORD-ATTR C@
            DUP VEF-IMMEDIATE    AND IF ." IMMEDIATE "    THEN
            DUP VEF-HIDDEN       AND IF ." HIDDEN "       THEN
                VEF-COMPILE-ONLY AND IF ." COMPILE-ONLY " THEN ;

: ?UPCASE CASE-SENSITIVE @ 0=
          IF DUP
             CASE
               [CHAR] a [CHAR] z <OF< [ CHAR a CHAR A - ] LITERAL - ENDOF
             ENDCASE
          THEN ;

: ?WORDS ?UPCASE GET-CURRENT (GET-ORDER) ?DUP 0>
         IF OVER SET-CURRENT DROPS
            0 LATEST@
            BEGIN ?DUP 0<> WHILE
              DUP LATEST>NAME DUP COUNT DUP
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
         SET-CURRENT DROP ;

: WORDS GET-CURRENT (GET-ORDER) ?DUP 0>
        IF OVER SET-CURRENT DROPS
           0 LATEST@
           BEGIN ?DUP 0<> WHILE
             DUP LATEST>NAME DUP COUNT DUP
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
             NAME> >LINK @
           REPEAT
           . ." word(s) total" CR
        THEN
        SET-CURRENT ;

: (WORDS-COUNT) (S wid -- count )
  GET-CURRENT 0 ROT SET-CURRENT
  LATEST@
  BEGIN
    DUP 0<>
  WHILE
    SWAP 1+ SWAP
    LATEST>CFA >LINK @
  REPEAT
  DROP SWAP SET-CURRENT ;

: WORDS-COUNT
  GET-ORDER ?DUP 0>
  IF OVER >R DROPS R> (WORDS-COUNT) ELSE 0 THEN ;

: AHEAD POSTPONE BRANCH >MARK 2 ; IMMEDIATE/COMPILE-ONLY

VOCABULARY ASSEMBLER

VOCABULARY EDITOR

: [ELSE] 1 BEGIN
           BEGIN BL WORD COUNT DUP WHILE
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
                 THEN ?DUP 0= IF EXIT THEN
           REPEAT 2DROP
           REFILL 0= UNTIL DROP ; IMMEDIATE

: [IF] 0= IF POSTPONE [ELSE] THEN ; IMMEDIATE

: [THEN] ; IMMEDIATE

DEFER CS-PICK ' PICK IS CS-PICK

DEFER CS-ROLL ' ROLL IS CS-ROLL

: BYE SHUTDOWN-CHAIN CHAIN.EXECUTE< (BYE) ;

CREATE-REPORT !
