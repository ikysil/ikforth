\
\  zchar.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading ZCHAR definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: ZSTRLEN (S z-addr -- count )
  DUP
  BEGIN
    DUP C@ 0<>
  WHILE
    CHAR+
  REPEAT 
  SWAP -
;

: ZCOUNT (S z-addr -- z-addr count )
  DUP ZSTRLEN
;

: ZMOVE (S z-addr1 z-addr2 -- )
  OVER ZSTRLEN CHAR+ CMOVE
;

: ZPLACE (S c-addr u z-addr -- )
  2DUP + >R
  SWAP CMOVE
  0 R> C!
;

: Z+PLACE (S c-addr u z-addr -- )
  ZCOUNT + ZPLACE
;

: (Z") R> DUP ZCOUNT + CHAR+ ALIGNED >R ;

\ compile zstring
: ,Z" (S c-addr count -- )
  HERE
  OVER CHAR+ ALLOT \ c-addr count here
  2DUP +           \ c-addr count here here+count
  >R
  SWAP CMOVE
  0 R> C!
;

\ compile zstring separated by "
: Z"
  PARSE"
  POSTPONE (Z") ,Z"
; IMMEDIATE/COMPILE-ONLY

: S">Z" (S c-addr u -- z-addr ) 
\ z-addr FREE THROW
  DUP CHAR+ ALLOCATE THROW DUP >R SWAP 2DUP + >R CMOVE 0 R> C! R>
;

: C">Z" (S c-addr -- z-addr )
\ z-addr FREE THROW
  COUNT S">Z"
;

USER UNESCAPE-BUFFER /S"BUFFER CHARS USER-ALLOC

DEFER UNESCAPE-BACKSLASH-CHAR (S c-addr u -- c-addr1 u1 char TRUE | c-addr1 u1 FALSE )

\  \a    hex 07
\  \b    hex 08
\  \t    hex 09
\  \n    hex 0A
\  \v    hex 0B
\  \f    hex 0C
\  \r    hex 0D
\  \\    hex 5C \
\  \q    hex 22 "
\  \e    hex 1B
\  \NNN  OCT nnn
\  \xNN  hex NN
: UNESCAPE-BACKSLASH-STRING (S c-addr u -- c-addr u )
;

: PARSE"-UNESCAPE
  PARSE" UNESCAPE-BACKSLASH-STRING
;

: Z\"
  PARSE"-UNESCAPE
  POSTPONE (Z") ,Z"
; IMMEDIATE/COMPILE-ONLY

: C\"
  PARSE"-UNESCAPE
  POSTPONE (C") ,C"
; IMMEDIATE/COMPILE-ONLY

:NONAME
  PARSE"-UNESCAPE
  >S"BUFFER
;
:NONAME
  PARSE"-UNESCAPE
  POSTPONE (S") ,S"
;
INT/COMP: S\"

REPORT-NEW-NAME !
