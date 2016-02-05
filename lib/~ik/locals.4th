\ ------------------------------------------------------------------------------
\  locals.4th
\
\  Copyright (C) 2016 Illya Kysil
\ ------------------------------------------------------------------------------

CR .( Loading LOCALS definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS

VOCABULARY LOCALS-HIDDEN

ALSO LOCALS-HIDDEN DEFINITIONS

\ align to cell
1 CELLS USER-SIZE-VAR @ OVER 1- AND - USER-ALLOC

USER LP 1 CELLS USER-ALLOC \ locals stack pointer

DS-SIZE CELLS USER-ALLOC
USER LP0 \ initial locals stack pointer

: LP@ (S -- addr ) \ addr is locals stack pointer
  LP @
;

: LP! (S addr -- ) \ addr is locals stack pointer
  LP !
;

:NONAME
  LP0 LP!
;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

: L@: (S n "name" -- n ) \ define word name to fetch the value of local with index n
  CREATE DUP CELLS ,
  DOES> (S -- x ) \ x is the value of local
  @ LP@ + @
;

: L!: (S n "name" -- n ) \ define word name to store the value of local with index n
  CREATE DUP CELLS ,
  DOES> (S x -- ) \ x is the new value of local
  @ LP@ + !
;

: L@-N: (S n "name"*n -- )
  BEGIN  DUP 0>  WHILE  1- L@:  REPEAT
  DROP
;

: L!-N: (S n "name"*n -- )
  BEGIN  DUP 0>  WHILE  1- L!:  REPEAT
  DROP
;

: LOCALS-RESTORE
  EXC> LP!
;

:NONAME
  DEFERRED EXC-FRAME-PUSH
  LP@ >EXC
  ['] LOCALS-RESTORE >EXC
; IS EXC-FRAME-PUSH

ONLY FORTH DEFINITIONS ALSO LOCALS-HIDDEN

16 L@-N: L15@ L14@ L13@ L12@ L11@ L10@ L9@ L8@ L7@ L6@ L5@ L4@ L3@ L2@ L1@ L0@
16 L!-N: L15! L14! L13! L12! L11! L10! L9! L8! L7! L6! L5! L4! L3! L2! L1! L0!

DEFER (L IMMEDIATE ' ( IS (L

: LDEPTH (S -- +n ) \ +n is current locals stack depth
  LP0 LP@ - [ 1 CELLS ] LITERAL /
;

: >L (S x -- ) (L -- x ) \ move item from data stack to locals stack
  LP@ CELL-
  SWAP OVER !
  LP!
;

: L> (S -- x ) (L x -- ) \ move item from locals stack to data stack
  LP@ DUP @ SWAP
  CELL+ LP0 MIN
  LP!
;

: L@ (S -- x ) (L x -- x ) \ copy item from locals stack to data stack
  LP@ @
;

: LDROP (S -- ) (L x -- ) \ drop top item from locals stack
  LP@
  CELL+ LP0 MIN
  LP!
;

: LSWAP (S -- ) (L x1 x2 -- x2 x1 ) \ swap two items on locals stack
  L> L> SWAP >L >L
;

: LOCALS-ALLOC (S n -- ) \ allocate locals frame for n cells
  LP@ OVER CELLS - LP!
  >EXC
;

: LOCALS-DEALLOC (S -- ) \ deallocate locals frame
  EXC>
  CELLS LP@ + LP0 MIN LP!
;

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
