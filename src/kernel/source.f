\
\  source.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading SOURCE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ String address for EVALUATE
USER EVAL 1 CELLS USER-ALLOC
\ String length for EVALUATE
USER #EVAL 1 CELLS USER-ALLOC

\ 6.1.2216 SOURCE
\ c-addr is the address of, and u is the number of characters in
\ the input buffer.
\ D: -- c-addr u
:NONAME
  SOURCE-ID 0< IF
                 EVAL @ #EVAL @ EXIT
               THEN
  SOURCE-ID 0> IF
                 FILE-LINE #FILE-LINE @ EXIT
               THEN
  DEFERRED SOURCE
; IS SOURCE

\ 6.2.2125 REFILL
\ D: -- flag
:NONAME
  SOURCE-ID 0< IF
                 FALSE EXIT
               THEN
  SOURCE-ID 0> IF
                 FILE-LINE MAX-FILE-LINE-LENGTH SOURCE-ID READ-LINE THROW SWAP #FILE-LINE ! 0 >IN !
                 REPORT-SOURCE!
                 \DEBUG CR ." REFILL: " REPORT-SOURCE
                 EXIT
               THEN
  DEFERRED REFILL
; IS REFILL

(G EVALUATE
   Save the current input source specification.
   Store minus-one [-1] in SOURCE-ID if it is present.
   Make the string described by c-addr and u both the input source
   and input buffer, set >IN to zero, and interpret.
   When the parse area is empty, restore the prior input source specification.
   Other stack effects are due to the words EVALUATEd. )
: EVALUATE (S i*x c-addr u -- j*x )
   INPUT>R RESET-INPUT -1 SOURCE-ID!
   #EVAL ! EVAL ! ['] INTERPRET CATCH
   R>INPUT THROW
;

:NONAME
   0 DUP
   #EVAL ! EVAL !
   DEFERRED (RESET-INPUT)
; IS (RESET-INPUT)

: RESTORE-INPUT-EVALUATE
   >R #EVAL ! EVAL ! R> 3 - SWAP EXECUTE
;

: SAVE-INPUT-EVALUATE
  DEFERRED (SAVE-INPUT)
  >R EVAL @ #EVAL @ ['] RESTORE-INPUT-EVALUATE R> 3 +
;

' SAVE-INPUT-EVALUATE IS (SAVE-INPUT)

: QUERY
  REFILL DROP
;

REPORT-NEW-NAME !
