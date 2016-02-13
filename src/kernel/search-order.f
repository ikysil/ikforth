\
\  search-order.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  SEARCH-ORDER and SEARCH-ORDER-EXT wordsets
\

CR .( Loading SEARCH-ORDER definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

USER #ORDER 1 CELLS USER-ALLOC
:NONAME
  0 #ORDER !
; DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

16 CONSTANT MAX-ORDER-COUNT

USER CONTEXT MAX-ORDER-COUNT 1+ CELLS USER-ALLOC

:NONAME \ FIND-ORDER (S c-addr -- c-addr 0 | xt 1 | xt -1 )
  0 #ORDER @ 0 ?DO                              \ S: c-addr 0
                 OVER COUNT                     \ S: c-addr 0 c-addr1 count
                 I CELLS CONTEXT + @            \ S: c-addr 0 c-addr1 count wid
                 SEARCH-WORDLIST                \ S: c-addr 0 [ 0 | xt 1 | xt -1 ]
                 ?DUP IF                        \ found S: c-addr 0 xt [ 1 | -1 ]
                        2SWAP 2DROP             \ S: xt [ 1 | -1 ]
                        LEAVE                   
                      THEN
               LOOP
               ?DUP IF
                      EXIT                      \ found, EXIT
                    THEN
                                                \ not found S: c-addr
                                                \ try to search FORTH-WORDLIST
               DEFERRED FIND
; IS FIND

\ ' FIND-ORDER IS FIND

: GET-ORDER
  #ORDER @ 0
  ?DO
    #ORDER @ I - 1- CELLS CONTEXT + @
  LOOP
  #ORDER @
;

: SET-ORDER
  DUP MAX-ORDER-COUNT > IF EXC-SEARCH-ORDER-OVERFLOW  THROW THEN
  DUP 0<                IF EXC-SEARCH-ORDER-UNDERFLOW THROW THEN
  DUP #ORDER ! 0
  ?DO
    I CELLS CONTEXT + !
  LOOP
;

: GET-CURRENT
  CURRENT @
;

: SET-CURRENT
  CURRENT !
;

VARIABLE LAST-WORDLIST
FORTH-WORDLIST LAST-WORDLIST !

\  WORDLIST structure
\  Offset (CELLS)       Value
\  +0                   last word in wordlist (modified by header creation words)
\  +1                   VOCABULARY XT (if any, 0 otherwise)
\  +2                   previous WORDLIST
: WORDLIST
  HERE DUP 0 DUP , , LAST-WORDLIST DUP >R @ , R> !
;

: WL>LATEST (S wordlist-id -- latest-word-addr )
;

: WL>VOC (S wordlist-id -- voc-xt-addr )
  CELL+
;

: WL>PREV-WL (S wordlist-id -- prev-wordlist-id-addr )
  [ 2 CELLS ] LITERAL +
;

: ONLY
  0 SET-ORDER
;

: ALSO
  GET-ORDER ?DUP
  IF
    OVER SWAP 1+
  ELSE
    FORTH-WORDLIST 1
  THEN SET-ORDER
;

: PREVIOUS
  GET-ORDER ?DUP
  IF
    NIP 1- SET-ORDER
  THEN
;

: DEFINITIONS
  GET-ORDER ?DUP
  IF
    OVER SET-CURRENT NDROP
  ELSE
    FORTH-WORDLIST SET-CURRENT
  THEN
;

: DOES>-VOCABULARY
  DOES> @ >R GET-ORDER
        DUP 0= IF 1 THEN
        NIP R> SWAP SET-ORDER
;

: (VOCABULARY)
  HERE SWAP CREATE DUP , WL>VOC ! DOES>-VOCABULARY
;

: VOCABULARY
  WORDLIST (VOCABULARY)
;

: VOC>WL (S xt -- wid )
  \ Return wordlist id of the vocabulary identified by xt.
  >BODY @
;

:NONAME ' VOC>WL ;
:NONAME ' VOC>WL POSTPONE LITERAL ;
INT/COMP: WORDLIST-OF (S "vocabulary" -- wid )
\ Parse name of the vocabulary and return the wordlist ID.

: .WORDLIST-NAME (S wid -- )
  DUP ." H# " H.8 SPACE WL>VOC @ ?DUP
  IF
    H>#NAME TYPE
  ELSE
    ." (nonamed)"
  THEN
;

: (GET-ORDER)
  FORTH-WORDLIST GET-ORDER 1+
;  

: ORDER
  (GET-ORDER)
  DUP . ." wordlist" DUP 1 <> IF ." s" THEN ."  in search order"
  0 ?DO
      CR .WORDLIST-NAME
    LOOP
  CR ." Current: " CR CURRENT @ .WORDLIST-NAME
;

: WORDLISTS
  LAST-WORDLIST @
  BEGIN
    DUP
  WHILE
    DUP WL>PREV-WL @ SWAP
    .WORDLIST-NAME CR
  REPEAT DROP
;

FORTH-WORDLIST (VOCABULARY) FORTH

REPORT-NEW-NAME !
