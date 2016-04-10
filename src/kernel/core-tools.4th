\
\  core-tools.4th
\
\  Copyright (C) 2016 Illya Kysil
\
\  Debugging helpers
\

REPORT-NEW-NAME @
FALSE REPORT-NEW-NAME !

USER .S-PRINT-XT 1 CELLS USER-ALLOC

: .PN.S (S n -- )
   14 .S-PRINT-XT @ EXECUTE
;

: PN.S (S print-xt depth -- )
   SWAP .S-PRINT-XT !
   DEPTH 1- MIN
   DUP .PN.S ."  item" DUP 1 <> IF ." s" THEN ."  on stack" DUP 0>
   IF
      0 DO
         I DUP 4 MOD 0= IF   CR   THEN
         PICK .PN.S
      LOOP
   ELSE
      DROP
   THEN
;

: N.S (S print-xt -- )
   DEPTH 1- PN.S
;

: H.S.R (S n u -- )
   8 - SPACES H.8
;

: H.S ['] H.S.R N.S ;

\ -----------------------------------------------------------------------------
\  TRACE-WORD
\ -----------------------------------------------------------------------------
: TRACE-WORD-NAME
   \ S: xt --
   \ Print the name of the word or (noname)
   CR ." TRACE-WORD: " R@ H.8 SPACE >HEAD H>#NAME
   ?DUP IF   TYPE   ELSE   DROP ." (noname)"   THEN
;

: TRACE-STACK
   CR H.S
;

: TRACE-WORD
   RECURSE-XT @ POSTPONE LITERAL
   POSTPONE TRACE-WORD-NAME
   POSTPONE TRACE-STACK
; IMMEDIATE

REPORT-NEW-NAME !
