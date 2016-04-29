\
\  linterm-ekey.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" sysdict/console.4th"

CR .( Loading linterm-ekey definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: term-raw-event (S -- d )
   (G Read RAW keyboard event from terminal - up to 8 bytes.
      Least significant byte of d contains last byte read. )
   KEY S>D
   OVER H# 1B = IF
      BEGIN
         KEY?
      WHILE
         D<<8
         SWAP KEY OR SWAP
      REPEAT
   THEN
;

H# 10000000 CONSTANT K-SHIFT-MASK   
H# 20000000 CONSTANT K-CTRL-MASK   
H# 40000000 CONSTANT K-ALT-MASK   
H# 80000000 CONSTANT EKEY-FLAG-FKEY
H# 0FFFFFFF CONSTANT EKEY-EVENT-MASK
H# FFFFFFFF CONSTANT EKEY-FLAG-INVALID

H# 00000100 CONSTANT EKEY-FKEY-STEP

: FKEY: (S x "<ccc>name" -- x' )
   EKEY-FKEY-STEP + DUP CONSTANT
;

H# 00FF0000
FKEY: K-UP
FKEY: K-DOWN
FKEY: K-RIGHT
FKEY: K-LEFT
FKEY: K-INSERT
FKEY: K-DELETE
FKEY: K-HOME
FKEY: K-END
FKEY: K-PREVIOUS
FKEY: K-NEXT
FKEY: K-F1
FKEY: K-F2
FKEY: K-F3
FKEY: K-F4
FKEY: K-F5
FKEY: K-F6
FKEY: K-F7
FKEY: K-F8
FKEY: K-F9
FKEY: K-F10
FKEY: K-F11
FKEY: K-F12
DROP   

WORDLIST CONSTANT term-raw-event-wordlist
term-raw-event-wordlist (VOCABULARY) term-raw-event-voc

term-raw-event-voc ALSO DEFINITIONS

SYNONYM tre-00000000001B5B41  K-UP
SYNONYM tre-000000001B5B3141  K-UP

SYNONYM tre-00000000001B5B42  K-DOWN
SYNONYM tre-000000001B5B3142  K-DOWN

SYNONYM tre-00000000001B5B43  K-RIGHT
SYNONYM tre-000000001B5B3143  K-RIGHT

SYNONYM tre-00000000001B5B44  K-LEFT
SYNONYM tre-000000001B5B3144  K-LEFT

SYNONYM tre-000000001B5B317E  K-HOME

SYNONYM tre-000000001B5B327E  K-INSERT

SYNONYM tre-000000001B5B337E  K-DELETE

SYNONYM tre-000000001B5B347E  K-END

SYNONYM tre-000000001B5B357E  K-PREVIOUS

SYNONYM tre-000000001B5B367E  K-NEXT

SYNONYM tre-00000000001B4F50  K-F1
SYNONYM tre-000000001B5B3150  K-F1

SYNONYM tre-00000000001B4F51  K-F2
SYNONYM tre-000000001B5B3151  K-F2

SYNONYM tre-00000000001B4F52  K-F3
SYNONYM tre-000000001B5B3152  K-F3

SYNONYM tre-00000000001B4F53  K-F4
SYNONYM tre-000000001B5B3153  K-F4

SYNONYM tre-0000001B5B31357E  K-F5
SYNONYM tre-0000001B5B31377E  K-F6
SYNONYM tre-0000001B5B31387E  K-F7
SYNONYM tre-0000001B5B31397E  K-F8
SYNONYM tre-0000001B5B32307E  K-F9
SYNONYM tre-0000001B5B32317E  K-F10
SYNONYM tre-0000001B5B32337E  K-F11
SYNONYM tre-0000001B5B32347E  K-F12

ONLY FORTH DEFINITIONS

: term-raw-event>name (S d -- c-addr u )
   S" tre-" >S"BUFFER \ S: d c-addr u
   2>R
   D# 16 0 DO #HEX-DIGIT LOOP
   2DROP
   2R>
   D# 16 0 DO ROT S"+CHAR LOOP
;

: ?trivial-raw-event (S d -- flag )
   SWAP H# FFFFFF00 AND OR 0= \ TRUE if only one byte was received
;

';' CONSTANT xterm-param-sep

: extract-xterm-modifier (S d -- x )
   (G xterm encodes function key modifiers as parameters
      appended before the final character of the control sequence. )
   DROP D# 8 RSHIFT SPLIT-32 DROP
   xterm-param-sep = IF  COMBINE-16 EXIT  THEN
   xterm-param-sep = IF  EXIT  THEN
   DROP 0
;

: remove-xterm-modifier (S d -- d' )
   (G Remove xterm function key modifiers from raw event. )
   >R SPLIT-32 \ S: ls-d0 ls-d1 ls-d2 ls-d3
   DUP  xterm-param-sep = IF
      DROP 2DROP R> SPLIT-32 0 DUP DUP
      COMBINE-32 >R COMBINE-32 R>
      EXIT
   THEN
   OVER xterm-param-sep = IF
      NIP NIP R> SPLIT-32 0 DUP
      COMBINE-32 >R COMBINE-32 R>
      EXIT
   THEN
   COMBINE-32 R> 
;

: DOES>xterm-mask-map \ S: index addr
   DOES>
   SWAP DUP
   2 9 WITHIN IF
      CELLS + @
   ELSE
      2DROP 0
   THEN
;

CREATE xterm-mask-map
\     Code     Modifiers
\   ---------+---------------------------
\       2     | Shift
\       3     | Alt
\       4     | Shift + Alt
\       5     | Control
\       6     | Shift + Control
\       7     | Alt + Control
\       8     | Shift + Alt + Control
\       9     | Meta
\       10    | Meta + Shift
\       11    | Meta + Alt
\       12    | Meta + Alt + Shift
\       13    | Meta + Ctrl
\       14    | Meta + Ctrl + Shift
\       15    | Meta + Ctrl + Alt
\       16    | Meta + Ctrl + Alt + Shift
\   ---------+---------------------------
   0 ,
   0 ,
   K-SHIFT-MASK ,
   K-ALT-MASK ,
   K-SHIFT-MASK K-ALT-MASK OR ,
   K-CTRL-MASK ,
   K-CTRL-MASK K-SHIFT-MASK OR ,
   K-CTRL-MASK K-ALT-MASK OR ,
   K-CTRL-MASK K-SHIFT-MASK K-ALT-MASK OR OR ,
DOES>xterm-mask-map

: xterm-modifier>mask (S x1 -- x2 )
   (G Convert xterm modifiers into mask )
   SPLIT-16 SWAP '0' - SWAP
   0> IF  10 +  THEN
   xterm-mask-map
;

: term-raw-event>ekey (S d -- x )
   (G Convert RAW keyboard event as returned by term-raw-event 
      to the format suitable for EKEY result )
   2DUP ?trivial-raw-event IF  DROP EXIT  THEN
   2DUP extract-xterm-modifier xterm-modifier>mask -ROT remove-xterm-modifier
   2DUP term-raw-event>name
\DEBUG 2DUP CR TYPE '"' EMIT
   term-raw-event-wordlist SEARCH-WORDLIST
   IF  NIP NIP EXECUTE  ELSE  DROP  THEN
   \ S: modifier-mask key-event
   EKEY-EVENT-MASK AND OR
   EKEY-FLAG-FKEY OR
;

\ 10.6.2.1305 EKEY ( -- u )
\ Receive one keyboard event u.
\ The encoding of keyboard events is implementation defined.
: term-ekey ( -- x )
   term-raw-event term-raw-event>ekey
;

\ 10.6.2.1306 EKEY>CHAR ( u -- u false | char true )
\ If the keyboard event u corresponds to a character in the implementation-defined
\ character set, return that character and true. Otherwise return u and false.
: term-ekey>char ( x -- x false | char true )
   DUP 128 U<
;

\ 10.6.2.1306.40 EKEY>FKEY ( x -- u flag )
\ If the keyboard event x corresponds to a keypress in the implementation-defined
\ special key set, return that key's id u and true. Otherwise return x and false.
: term-ekey>fkey
   DUP EKEY-FLAG-FKEY AND 0<> 
;

REPORT-NEW-NAME !
