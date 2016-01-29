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
                 FILE-LINE MAX-FILE-LINE-LENGTH SOURCE-ID READ-LINE THROW SWAP #FILE-LINE ! 0 >IN ! EXIT
               THEN
  DEFERRED REFILL
; IS REFILL

: EVALUATE
  INPUT>R RESET-INPUT -1 SOURCE-ID!
  #EVAL ! EVAL ! ['] INTERPRET CATCH R>INPUT THROW
;

: QUERY
  REFILL DROP
;

REPORT-NEW-NAME !
