\
\  console.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

CR .( Loading CONSOLE definitions )

\ -----------------------------------------------------------------------------

DEFER KEY
DEFER KEY?
DEFER EKEY
DEFER EKEY?
DEFER EKEY>CHAR

\ 6.1.0695 ACCEPT 
\ (S c-addr +n1 -- +n2 )
\ Receive a string of at most +n1 characters.
\ An ambiguous condition exists if +n1 is zero or greater than 32,767.
\ Display graphic characters as they are received.
\ A program that depends on the presence or absence of non-graphic characters in the string
\ has an environmental dependency.
\ The editing functions, if any, that the system performs in order to construct the string are implementation-defined. 
\
\ Input terminates when an implementation-defined line terminator is received.
\ When input terminates, nothing is appended to the string, and the display is maintained in an implementation-defined way. 
\
\ +n2 is the length of the string stored at c-addr. 
DEFER ACCEPT

1024 CONSTANT MAX-TIB-LENGTH

USER TIB MAX-TIB-LENGTH 1+ CHARS USER-ALLOC
USER #TIB 1 CELLS USER-ALLOC

USER SPAN 1 CELLS USER-ALLOC

: EXPECT ACCEPT SPAN ! ;

\ 6.1.2216 SOURCE
\ c-addr is the address of, and u is the number of characters in
\ the input buffer. 
\ D: -- c-addr u
:NONAME
  SOURCE-ID 0=
  IF
    TIB #TIB @
  ELSE
    DEFER@-EXECUTE SOURCE
  THEN
; IS SOURCE

\ 6.2.2125 REFILL
\ D: -- flag
:NONAME
  SOURCE-ID 0=
  IF
    TIB MAX-TIB-LENGTH ACCEPT #TIB ! 0 >IN ! TRUE
  ELSE
    DEFER@-EXECUTE REFILL
  THEN
; IS REFILL

REPORT-NEW-NAME !
