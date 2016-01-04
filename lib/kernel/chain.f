\
\  chain.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading CHAIN definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: CHAIN (S chain-element-value "name" -- )
  CREATE , 0 , ;

: CHAIN-NONAME (S chain-element-value -- chain-element )
  HERE >R , 0 , R> ;

: CHAIN.VALUE (S chain-element -- chain-element-value )
  @ ;

: CHAIN.NEXT (S chain-element -- next-chain-element )
  CELL+ @ ;

: CHAIN.GETLAST (S chain -- last-chain-element )
  DUP 0= IF EXIT THEN
  BEGIN
    DUP CHAIN.NEXT DUP
  WHILE
    NIP
  REPEAT DROP ;

: CHAIN.LINK (S new-last-chain-element chain -- )
  CHAIN.GETLAST CELL+ ! ;

: CHAIN.ADD (S chain-element-value chain -- )
  HERE ROT , 0 , SWAP CHAIN.LINK ;

\ Executes XT for each element of a chain from head to tail
\ XT execution stack effect: (S chain-element-value -- continue-flag )
\                            flag is TRUE to continue chain traverse
: CHAIN.FOR-EACH> (S chain xt -- )
  >R
  BEGIN
    DUP
  WHILE
    DUP CHAIN.VALUE R@ ROT >R EXECUTE R> SWAP IF CHAIN.NEXT ELSE DROP 0 THEN
  REPEAT DROP R> DROP ;

\ Executes XT for each element of a chain from tail to head
\ XT execution stack effect: (S chain-element-value -- continue-flag )
\                            flag is TRUE to continue chain traverse
\ : CHAIN.FOR-EACH< (S chain xt -- )
(
  SWAP
  0 >R
  BEGIN
    DUP
  WHILE
    DUP CHAIN.VALUE >R CHAIN.NEXT
  REPEAT
  DROP
  BEGIN
    R> DUP              \ S: xt chain-value chain-value
  WHILE
    OVER                \ S: xt chain-value xt
    ROT >R              \ S: chain-value xt
    EXECUTE             \ S: flag
    R> SWAP             \ S: xt flag
    INVERT              \ S: xt inv-flag
    IF
      BEGIN
        R>
      WHILE
      REPEAT
      0 >R
    THEN
  REPEAT 2DROP ;
)

: CHAIN.FOR-EACH< (S chain xt -- )
  >R
  0 SWAP
  BEGIN
    DUP
  WHILE
    DUP CHAIN.VALUE SWAP CHAIN.NEXT ROT 1 + SWAP
  REPEAT
  DROP
  BEGIN
    DUP 0<> DUP IF SWAP 1 - -ROT ELSE 2DROP FALSE THEN
  WHILE
    R@ EXECUTE INVERT IF
                        BEGIN
                          DUP 0<> SWAP 1 - SWAP
                        WHILE
                          NIP
                        REPEAT
                        DROP 0
                      THEN
  REPEAT
  R> DROP ;

: (CHAIN.EXECUTE) (S chain-element xt -- TRUE )
  EXECUTE TRUE ;

\ Executes chain from head to tail
: CHAIN.EXECUTE> (S chain -- )
  ['] (CHAIN.EXECUTE) CHAIN.FOR-EACH> ;

\ Executes chain from tail to head
: CHAIN.EXECUTE< (S chain -- )
  ['] (CHAIN.EXECUTE) CHAIN.FOR-EACH< ;

CREATE-REPORT !
