\
\  format.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  Formatted output
\

CR .( Loading FORMAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

USER HLD 1 CELLS USER-ALLOC

HLD-SIZE USER-ALLOC USER HLD0

: <# HLD0 HLD ! ;

: HOLD (S char -- )
  HLD -1 OVER +! @
  HLD0 OVER - HLD-SIZE >= IF EXC-HLD-OVERFLOW THROW THEN
  C!
;

: # BASE @ 0 UD/ 2SWAP DROP DIGITS + C@ HOLD ;

: #> 2DROP HLD @ HLD0 OVER - ;

: SIGN 0< IF [CHAR] - HOLD THEN ;

: #S BEGIN # 2DUP D0= UNTIL ;

: (D.)
  2DUP DABS <# #S ROT SIGN #> TYPE DROP
;

: (D.R)
  \ 1-
  OVER 2SWAP DABS <# #S ROT SIGN #>
  ROT OVER - DUP 0> IF SPACES ELSE DROP THEN TYPE
;

: D.
  (D.)  [CHAR] . EMIT SPACE
;

: D.R
  (D.R) [CHAR] . EMIT
;

: (UD.)
  <# #S #> TYPE
;

: (UD.R)
   >R <# #S #> R> OVER - DUP 0> IF   SPACES   ELSE   DROP   THEN
   TYPE
;

: UD.
  (UD.)  [CHAR] . EMIT SPACE ;

: UD.R
  (UD.R) [CHAR] . EMIT ;

: . S>D (D.) SPACE ;

: .R SWAP S>D ROT (D.R) ;

: U. 0 (UD.) SPACE ;

: U.R SWAP 0 ROT (UD.R) ;

: H. BASE @ HEX SWAP U. BASE ! ;

: H.R BASE @ HEX ROT ROT U.R BASE ! ;

: H.N BASE @ >R HEX 0 TUCK <# ?DO # LOOP #> TYPE ( SPACE ) R> BASE ! ;

\ 6.2.1675 HOLDS
: HOLDS (S addr u -- )
  BEGIN DUP WHILE 1- 2DUP CHARS + C@ HOLD REPEAT 2DROP ;

REPORT-NEW-NAME !
