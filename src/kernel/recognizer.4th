\
\  recognizer.4th
\
\  Copyright (C) 2016 Illya Kysil
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

REPORT-NEW-NAME !
