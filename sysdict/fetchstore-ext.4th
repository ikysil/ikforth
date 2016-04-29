\
\  fetchstore-ext.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading FETCHSTORE-EXT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @

DECIMAL

DEFER B@
' C@ IS B@

DEFER B!
' C! IS B!

: WORD-SPLIT DUP H# FF AND SWAP H# FF00 AND 8 RSHIFT ;

: WORD-JOIN H# FF AND 8 LSHIFT SWAP H# FF AND OR ;

: DWORD-SPLIT DUP H# FFFF AND SWAP H# FFFF0000 AND 16 RSHIFT ;

: DWORD-JOIN H# FFFF AND 16 LSHIFT SWAP H# FFFF AND OR ;

: W, WORD-SPLIT SWAP B, B, ;

: W@ @ H# FFFF AND ;

: W! SWAP WORD-SPLIT -ROT OVER B! B! ;

: SIGN-EXTEND-16 (S a -- ax )
  H# 00008000 TUCK XOR SWAP -
;

: COMBINE-16 (S a0 a1 -- a1 << 8 || a0 )
  H# FF AND 8 LSHIFT SWAP H# FF AND OR
;

: COMBINE-32 (S a0 a1 a2 a3 -- a3 << 24 || a2 << 16 || a1 << 8 || a0 )
  COMBINE-16 16 LSHIFT -ROT
  COMBINE-16 OR
;

: SPLIT-16 (S a -- a & FF  a >> 8 )
  DUP H# FF AND SWAP 8 RSHIFT H# FF AND
;

: SPLIT-32 (S a -- a & FF  a >> 8 & FF a >> 16 & FF  a >> 32 & FF )
  DUP           H# FF AND SWAP
  DUP 8  RSHIFT H# FF AND SWAP
  DUP 16 RSHIFT H# FF AND SWAP
      24 RSHIFT H# FF AND
;

: 32L>32B (S a0 a1 a2 a3 -- a3 a2 a1 a0 )
  SWAP 2SWAP SWAP
;

: B@+ \ (S addr1 -- addr2 x )
  DUP 1+ SWAP B@
;

: B!+ \ (S x addr1 -- addr2 )
  DUP -ROT B! 1+
;

\ The 16-bit quantity at addr is fetched with its MSB at the lower address.
\ It is zero-filled if the cell width is greater than 16 bits. 
: U@16B (S addr -- n )
  B@+ SWAP B@ SWAP COMBINE-16
;

\ The 16-bit quantity at addr is fetched with its LSB at the lower address.
\ It is zero-filled if the cell width is greater than 16 bits. 
: U@16L (S addr -- n )
  B@+ SWAP B@ COMBINE-16
;

\ The 16-bit quantity at addr is fetched with its MSB at the lower address.
\ It is sign-extended if the cell width is greater than 16 bits.
: @16B (S addr -- n )
  U@16B SIGN-EXTEND-16
;

\ The 16-bit quantity at addr is fetched with its LSB at the lower address.
\ It is sign-extended if the cell width is greater than 16 bits. 
: @16L (S addr -- n )
  U@16L SIGN-EXTEND-16
;

\ The 16-bit quantity is stored at addr with its MSB at the lower address.
\ The high-order bits are discarded if the cell width is greater than 16 bits. 
: !16B (S n addr -- )
  SWAP SPLIT-16 ROT B!+ B!
;

\ The 16-bit quantity is stored at addr with its LSB at the lower address.
\ The high-order bits are discarded if the cell width is greater than 16 bits. 
: !16L (S n addr -- )
  SWAP SPLIT-16 SWAP ROT B!+ B!
;

\ The 32-bit quantity at addr is fetched with its MSB at the lower address.
: @32B (S addr -- n )
  B@+ SWAP B@+ SWAP B@+ SWAP B@ 32L>32B COMBINE-32
;

\ The 32-bit quantity at addr is fetched with its LSB at the lower address. 
: @32L (S addr -- n )
  B@+ SWAP B@+ SWAP B@+ SWAP B@ COMBINE-32
;

\ The 32-bit quantity at addr is fetched with its MSB at the lower address. 
DEFER U@32B (S addr -- n )
' @32B IS U@32B

\ The 32-bit quantity at addr is fetched with its LSB at the lower address. 
DEFER U@32L (S addr -- n )
' @32L IS U@32L

\ The 32-bit quantity is stored at addr with its MSB at the lower address.
: !32B (S n addr -- )
  >R SPLIT-32 R> B!+ B!+ B!+ B!
;

\ The 32-bit quantity is stored at addr with its LSB at the lower address.
: !32L (S n addr -- )
  >R SPLIT-32 32L>32B R> B!+ B!+ B!+ B!
;

\ The 32-bit quantity at addr is fetched with its MSB at the lower address. 
: 2@32B (S addr -- d )
  DUP @32B SWAP 4 + @32B SWAP
;

\ The 32-bit quantity at addr is fetched with its LSB at the lower address.
: 2@32L (S addr -- d )
  DUP @32L SWAP 4 + @32L
;

\ The 32-bit quantity is stored at addr with its MSB at the lower address.
: 2!32B (S d addr -- )
  TUCK !32B 4 + !32B
;

\ The 32-bit quantity is stored at addr with its LSB at the lower address.
: 2!32L (S d addr -- )
  TUCK 2SWAP !32L 4 + !32L
;

BASE !

REPORT-NEW-NAME !
