\
\  recognizer.4th
\
\  Unlicense since 1999 by Illya Kysil
\  with contributions from http://amforth.sourceforge.net/pr/Recognizer-rfc-C.html
\

CR .( Loading RECOGNIZER definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ Patch FORTH-RECOGNIZER with VALUE VT
VALUE-VT ' FORTH-RECOGNIZER >BODY !

: RECOGNIZER ( size -- stack-id )
    1+ ( size ) CELLS HERE SWAP ALLOT
    0 OVER ! \ empty stack
;

: SET-RECOGNIZERS ( rec-n .. rec-1 n stack-id -- )
   2DUP ! >R
   BEGIN
      DUP
   WHILE
      DUP CELLS R@ +
      ROT SWAP ! 1-
   REPEAT R> 2DROP
;

: GET-RECOGNIZERS ( stack-id -- rec-n .. rec-1 n )
   DUP @ DUP >R SWAP
   BEGIN
      CELL+ OVER
   WHILE
      DUP @ ROT 1- ROT
   REPEAT 2DROP
   R>
;

\ create a simple 3 element structure
: RECOGNIZER: ( XT-INTERPRET XT-COMPILE XT-POSTPONE "<spaces>name" -- )
   CREATE SWAP ROT , , ,
;

: .RECOGNIZER-NAME (S rec-xt -- )
   DUP ." H# " H.8 SPACE >HEAD H>#NAME
   DUP 0= IF  2DROP S" (nonamed)"  THEN
   TYPE
;

: .RECOGNIZERS (S stack-id -- )
   (G Print names of recognizers configured in stack-id )
   GET-RECOGNIZERS 0 ?DO
      .RECOGNIZER-NAME CR
   LOOP
;

: .FORTH-RECOGNIZERS
   (G Print names of recognizers configured in FORTH-RECOGNIZER )
   FORTH-RECOGNIZER .RECOGNIZERS
;

REPORT-NEW-NAME !
