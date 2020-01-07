\
\  console.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

CR .( Loading CONSOLE definitions )

VOCABULARY TERMINIT

\ -----------------------------------------------------------------------------

DEFER KEY
DEFER KEY?
DEFER EKEY
DEFER EKEY?
DEFER EKEY>CHAR

\ 10.6.2.1306.40 EKEY>FKEY ( x -- u flag )
\ If the keyboard event x corresponds to a keypress in the implementation-defined
\ special key set, return that key's id u and true. Otherwise return x and false.
DEFER EKEY>FKEY

\ 10.6.2.1325 EMIT?
\ (S -- flag )
\ flag is true if the user output device is ready to accept data and the execution
\ of EMIT in place of EMIT? would not have suffered an indefinite delay.
\ If the device status is indeterminate, flag is true.
DEFER EMIT?

\ 10.6.1.0742 AT-XY
\ (S u1 u2 -- )
\ Perform implementation-dependent steps so that the next character displayed will
\ appear in column u1, row u2 of the user output device,
\ the upper left corner of which is column zero, row zero.
\ An ambiguous condition exists if the operation cannot be performed
\ on the user output device with the specified parameters.
DEFER AT-XY (S x y -- )

\ 10.6.1.2005 PAGE
\ (S -- )
\ Move to another page for output. Actual function depends on the output device.
\ On a terminal, PAGE clears the screen and resets the cursor position to the upper left corner.
\ On a printer, PAGE performs a form feed.
DEFER PAGE

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

\ Erase character before cursor position and move cursor there
DEFER CONSOLE-BACKSPACE

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
    DEFERRED SOURCE
  THEN
; IS SOURCE

\ 6.2.2125 REFILL
\ D: -- flag
:NONAME
  SOURCE-ID 0=
  IF
    TIB MAX-TIB-LENGTH ACCEPT #TIB ! 0 >IN ! TRUE
    REPORT-SOURCE!
    \DEBUG CR ." REFILL: " REPORT-REFILL
  ELSE
    DEFERRED REFILL
  THEN
; IS REFILL

DEFER TERMINIT-DEFAULT

: TERMINIT-ENV?
   (S -- c-addr count true | false )
   (G Seach host environment for IKFORTHTERMINIT variable )
   (G and return value as counted string )
   (G Return true if found, false otherwise )
   S" IKFORTHTERMINIT" ENVP?
;

REPORT-NEW-NAME !
