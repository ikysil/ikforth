PURPOSE: CORE-TOOLS definitions - Debugging helpers
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
FALSE REPORT-NEW-NAME !

DECIMAL

USER .S-PRINT-XT 1 CELLS USER-ALLOC

: .PN.S (S n -- )
   14 .S-PRINT-XT @ EXECUTE
;

: PN.S (S print-xt depth -- )
   SWAP .S-PRINT-XT !
   DEPTH 1- MIN
   DUP >R
   0 ?DO
      DEPTH I - 1- PICK .PN.S
      \ 3 I OVER AND = IF  CR  THEN
   LOOP
   ."  <- TOS"
   R> .PN.S ."  cell" DUP 1 <> IF ." s" THEN
;

: N.S (S print-xt -- )
   DEPTH 1- PN.S
;

: H.S.R (S n u -- )
   8 - SPACES H.8
;

: H.S ['] H.S.R N.S ;

: #HEX-DIGIT (S d -- char d' )
   (G Extract least significant hex digit char from d
      and return remaining number as d' )
   16 0 UD/ 2SWAP DROP DIGITS + C@ -ROT
;

REPORT-NEW-NAME !
