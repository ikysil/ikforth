\
\  zchar.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
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

: Z\"
  PARSE\"
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

REPORT-NEW-NAME !
