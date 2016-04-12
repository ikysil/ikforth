\
\  value.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading VALUE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ Layout of PFA for VALUE-like words
\ +0    vt-addr     address of table of methods
\ +4    data
\
\ table of methods layout
\ +0    store-xt         STATE-sensitive word to perform/compile store operation (!, 2!)
\ +4    plus-store-xt    STATE-sensitive word to perform/compile plus-store operation (+!, 2+!)

: VALUE>DATA (S body-addr -- data-addr )
   CELL+
;

: VALUE-METHOD-DOES
   DOES> (S value-xt value-method-body -- ) \ runtime semantics
   @
   SWAP >BODY VALUE>DATA
   STATE @
   IF
      POSTPONE LITERAL
      COMPILE,
   ELSE
      SWAP EXECUTE
   THEN
;

: VALUE-METHOD
  CREATE ' , VALUE-METHOD-DOES
;

VALUE-METHOD VALUE!   !
VALUE-METHOD VALUE+!  +!
VALUE-METHOD 2VALUE!  2!
VALUE-METHOD 2VALUE+! 2+!

CREATE VALUE-VT
   ' VALUE! , ' VALUE+! ,

CREATE 2VALUE-VT
   ' 2VALUE! , ' 2VALUE+! ,

: VALUE>VT (S xt -- int-vt-addr )
   >BODY @
;

: VALUE!VT@ (S vt-addr -- store-xt )
   @
;

: VALUE+!VT@ (S vt-addr -- plus-store-xt )
   CELL+ @
;

\ -----------------------------------------------------------------------------
\ VALUE 2VALUE TO +TO
\ -----------------------------------------------------------------------------

: VALUE
   CREATE
   VALUE-VT ,
   ,
   DOES> VALUE>DATA @
;

: 2VALUE
   CREATE
   2VALUE-VT ,
   HERE 2 CELLS ALLOT 2!
   DOES> VALUE>DATA 2@
;

: TO
  ' DUP VALUE>VT VALUE!VT@  EXECUTE
; IMMEDIATE

: +TO
  ' DUP VALUE>VT VALUE+!VT@ EXECUTE
; IMMEDIATE

REPORT-NEW-NAME !
