\
\  winconsole.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading WINCONSOLE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

0 VALUE STDIN
0 VALUE STDOUT
0 VALUE STDERR

:NONAME STD_INPUT_HANDLE  GetStdHandle TO STDIN
        STD_OUTPUT_HANDLE GetStdHandle TO STDOUT
        STD_ERROR_HANDLE  GetStdHandle TO STDERR ;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

:NONAME (S y x -- )
  16 LSHIFT OR STDOUT SetConsoleCursorPosition DROP
; IS AT-XY

USER NumberOfConsoleInputEvents 1 CELLS USER-ALLOC

\ 10.6.2.1307 EKEY? ( -- flag )
\ If a keyboard event is available, return true. Otherwise return false.
\ The event shall be returned by the next execution of EKEY. 
\
\ After EKEY? returns with a value of true, subsequent executions of EKEY?
\ prior to the execution of KEY, KEY? or EKEY also return true, referring to the same event. 
: WIN-CONSOLE-EKEY? ( -- flag )
  NumberOfConsoleInputEvents STDIN GetNumberOfConsoleInputEvents DROP
  NumberOfConsoleInputEvents @ 0<>
;

USER INPUT_RECORD 20 ( /INPUT_RECORD) USER-ALLOC

\ Return control keys state from last keyboard event 
: CONTROL-STATE (S -- u )
  INPUT_RECORD ( Event dwControlKeyState ) 16 + @
;

\ Return implementation specific key scan code and pressed/released state.
\ Flag is true if key is pressed.
: EKEY>SCAN (S u -- scan flag )
  DUP 0x10 RSHIFT 0x000000FF AND
  SWAP 0xFF000000 AND 0<>
;

USER NumberOfRecordsRead 1 CELLS USER-ALLOC

\ 10.6.2.1305 EKEY ( -- u )
\ Receive one keyboard event u.
\ The encoding of keyboard events is implementation defined. 
\ In this implementation
\ byte  value
\    0  AsciiChar
\    2  ScanCod
\    3  KeyDownFlag
: WIN-CONSOLE-EKEY ( -- u ) \ 93 FACILITY EXT
  NumberOfRecordsRead 1 INPUT_RECORD STDIN ReadConsoleInput DROP INPUT_RECORD
  DUP  ( EventType ) W@ KEY_EVENT <> IF DROP 0 EXIT THEN
  DUP  ( Event AsciiChar       ) 14 + W@
  OVER ( Event wVirtualScanCode) 12 + W@  16 LSHIFT OR
  OVER ( Event bKeyDown        ) 04 + C@  24 LSHIFT OR
  NIP
;

\ 10.6.2.1306 EKEY>CHAR ( u -- u false | char true )
\ If the keyboard event u corresponds to a character in the implementation-defined
\ character set, return that character and true. Otherwise return u and false. 
: WIN-CONSOLE-EKEY>CHAR ( u -- u false | char true )
  DUP 0xFF000000 AND 0=  IF FALSE    EXIT THEN
  DUP 0x000000FF AND DUP IF NIP TRUE EXIT THEN DROP
  FALSE
;

VARIABLE PENDING-CHAR

\ 10.6.1.1755 KEY? ( -- flag )
\ If a character is available, return true. Otherwise, return false.
\ If non-character keyboard events are available before the first valid character,
\ they are discarded and are subsequently unavailable.
\ The character shall be returned by the next execution of KEY. 
\
\ After KEY? returns with a value of true, subsequent executions of KEY?
\ prior to the execution of KEY or EKEY also return true, without discarding keyboard events. 
: WIN-CONSOLE-KEY? ( -- flag )
  PENDING-CHAR @ 0 > IF TRUE EXIT THEN
  BEGIN
    EKEY?
  WHILE
    EKEY EKEY>CHAR
    IF PENDING-CHAR ! TRUE EXIT THEN
    DROP
  REPEAT FALSE
;

\ 6.1.1750 KEY ( -- char )
\ Receive one character char, a member of the implementation-defined character set.
\ Keyboard events that do not correspond to such characters are discarded until a valid
\ character is received, and those events are subsequently unavailable. 
\ All standard characters can be received. Characters received by KEY are not displayed. 
\ Any standard character returned by KEY has the numeric value specified in 
\ 3.1.2.1 Graphic characters. Programs that require the ability to receive control
\ characters have an environmental dependency. 
: WIN-CONSOLE-KEY ( -- char )
  PENDING-CHAR @ 0 >
  IF PENDING-CHAR @ -1 PENDING-CHAR ! EXIT THEN
  BEGIN
    EKEY EKEY>CHAR 0=
  WHILE
    DROP
  REPEAT
;

: WIN-ERASE-CHAR
  8 EMIT BL EMIT 8 EMIT
;

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
: WIN-ACCEPT (S c-addr +n1 -- +n2 )
  DUP 0=
  OVER 0< OR
  OVER 32767 > OR
  IF EXC-INVALID-NUM-ARGUMENT THROW THEN
  >R 0
  BEGIN
    KEY DUP                \ c-addr n key key
    CASE
      32 127 <OF<          \ graphics characters
        OVER R@ <
        IF
          DUP EMIT
          ROT C!+ SWAP 1+
        THEN
        FALSE
      ENDOF
      8 OF                 \ backspace
        DROP DUP
        0>
        IF
          WIN-ERASE-CHAR
          1- SWAP [ 1 CHARS ] LITERAL - SWAP
        THEN
        FALSE
      ENDOF
      13 OF                \ enter
        DROP
        TRUE
      ENDOF
      FALSE SWAP
    ENDCASE
  UNTIL
  SWAP R> 2DROP
;

' WIN-CONSOLE-EKEY?     IS EKEY?
' WIN-CONSOLE-EKEY      IS EKEY
' WIN-CONSOLE-EKEY>CHAR IS EKEY>CHAR
' WIN-CONSOLE-KEY?      IS KEY?
' WIN-CONSOLE-KEY       IS KEY
' WIN-ACCEPT            IS ACCEPT

REPORT-NEW-NAME !
