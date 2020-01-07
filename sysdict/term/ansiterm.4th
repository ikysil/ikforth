\
\  ansiterm.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REQUIRES" sysdict/console.4th"

CR .( Loading ANSITERM definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY ANSITERM-PRIVATE

ALSO ANSITERM-PRIVATE DEFINITIONS

\ private definitions go here

 27 CONSTANT CSI0
'[' CONSTANT CSI1

: CSI-HOLD '[' HOLD CSI0 HOLD
;

\ Execute #S with BASE set to decimal 10
: D#S (S d -- d )
  ['] #S 10 BASE-EXECUTE
;

: .ANSI-CUP (S x y -- )
  SWAP
  <#
  'H' HOLD
  1+ S>D D#S
  2DROP
  ';' HOLD
  1+ S>D D#S
  CSI-HOLD
  #> TYPE
;

0 CONSTANT ANSI-ED-EOS  \ from cursor to End Of Screen
1 CONSTANT ANSI-ED-BOS  \ from cursor to Beginning Of Screen
2 CONSTANT ANSI-ED-FULL \ Full screen

\ Clears part of the screen.
\ If n is 0 (or missing), clear from cursor to end of screen.
\ If n is 1, clear from cursor to beginning of the screen.
\ If n is 2, clear entire screen.
: .ANSI-ED (S n -- )
  <#
  'J' HOLD
  0 D#S
  CSI-HOLD
  #> TYPE
;

: ANSI-WAIT-CSI
  BEGIN   KEY CSI0 =   UNTIL
  BEGIN   KEY CSI1 =   UNTIL
;

: CSI-END? (S c -- flag )
  (G Check if c is the end of CSI )
  (G The final character of these sequences is in the range ASCII 64-126 [@ to ~]. )
  64 127 WITHIN
;

64 CONSTANT /DSR-PAD
USER DSR-PAD /DSR-PAD CHARS USER-ALLOC

: .ANSI-DSR
  <#
  S" 6n" HOLDS
  CSI-HOLD
  0.
  #> TYPE
;

(G Return cursor position )
: ANSI-AT-XY? (S -- x y )
  .ANSI-DSR
  DSR-PAD /DSR-PAD ERASE
  DSR-PAD
  ANSI-WAIT-CSI
  BEGIN
    KEY DUP
    CSI-END? INVERT
  WHILE
    \ replace <;> with <space> to facilitate usage of EVALUATE
    DUP ';' = IF DROP BL THEN
    OVER C! CHAR+
  REPEAT
  'R' =
  IF
    BL SWAP C!
    DSR-PAD /DSR-PAD ['] EVALUATE D# 10 BASE-EXECUTE
    1- SWAP 1-
  ELSE
    0 DUP
  THEN
;

: ANSI-PAGE
  ANSI-ED-FULL .ANSI-ED
  1 1 AT-XY
;

: ANSI-BACKSPACE
  ANSI-AT-XY? SWAP \ S: y x
  DUP 1 =
  IF
    DROP 1024 SWAP 1-
  ELSE
    1- SWAP
  THEN
  AT-XY
  ANSI-ED-EOS .ANSI-ED
;

ONLY FORTH DEFINITIONS ALSO ANSITERM-PRIVATE

\ public definitions go here
\ private definitions are available for use

: ANSITERM-INIT

  [DEFINED] WINCONSOLE-INIT [IF]
    WINCONSOLE-INIT
  [THEN]

  [DEFINED] LINCONSOLE-INIT [IF]
    LINCONSOLE-INIT
  [THEN]

  \DEBUG CR ." ANSITERM-INIT"
  CR
  ['] ANSI-BACKSPACE IS CONSOLE-BACKSPACE
  ['] .ANSI-CUP      IS AT-XY
  ['] ANSI-PAGE      IS PAGE
;

ONLY TERMINIT DEFINITIONS

SYNONYM ANSITERM-INIT ANSITERM-INIT

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
