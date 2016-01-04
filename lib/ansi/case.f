\
\  case.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading CASE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ -----------------------------------------------------------------------------
\ CASE
\ -----------------------------------------------------------------------------

: CASE
  0
; IMMEDIATE/COMPILE-ONLY

: (ENDCASE)
  DROP
;
: ENDCASE
  POSTPONE (ENDCASE)
  BEGIN
    ?DUP
  WHILE
    5 ?PAIRS >RESOLVE
  REPEAT
; IMMEDIATE/COMPILE-ONLY

: (ENDOF)
  R> @ >R
;
: ENDOF
  4 ?PAIRS POSTPONE (ENDOF) >MARK SWAP >RESOLVE 5
; IMMEDIATE/COMPILE-ONLY

: (OF)
  OVER = IF DROP R> CELL+ ELSE R> @ THEN >R
;
: OF
  POSTPONE (OF) >MARK 4
; IMMEDIATE/COMPILE-ONLY

: (<OF)
  OVER > IF DROP R> CELL+ ELSE R> @ THEN >R
;
: <OF
  POSTPONE (<OF) >MARK 4
; IMMEDIATE/COMPILE-ONLY

: (>OF)
  OVER < IF DROP R> CELL+ ELSE R> @ THEN >R
;
: >OF
  POSTPONE (>OF) >MARK 4
; IMMEDIATE/COMPILE-ONLY

: (<OF<)
  1+ 2 PICK ROT ROT WITHIN IF DROP R> CELL+ ELSE R> @ THEN >R
;
: <OF<
  POSTPONE (<OF<) >MARK 4
; IMMEDIATE/COMPILE-ONLY

REPORT-NEW-NAME !
