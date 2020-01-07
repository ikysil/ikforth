\
\  search-order.4th
\
\  Unlicense since 1999 by Illya Kysil
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

: SEARCH-ORDER \ (S c-addr u -- 0 | xt 1 | xt -1 )
   0 #ORDER @ 0 ?DO              \ S: c-addr u 0
      DROP 2DUP
      I CELLS CONTEXT + @        \ S: c-addr u c-addr u wid
      SEARCH-WORDLIST            \ S: c-addr u [ 0 | xt 1 | xt -1 ]
      DUP 0<> IF                 \ found S: c-addr u xt [ 1 | -1 ]
         2SWAP 2DROP             \ S: xt [ 1 | -1 ]
         LEAVE
      THEN
   LOOP
   \ found, EXIT
   ?DUP IF   EXIT   THEN
   \ not found S: c-addr u
   \ try to search FORTH-WORDLIST
   DEFERRED SEARCH-NAME
;

' SEARCH-ORDER IS SEARCH-NAME

: GET-ORDER
  #ORDER @ 0
  ?DO
    #ORDER @ I - 1- CELLS CONTEXT + @
  LOOP
  #ORDER @
;

: SET-ORDER
  DUP MAX-ORDER-COUNT >
  IF   EXC-SEARCH-ORDER-OVERFLOW  THROW   THEN
  DUP -1 <
  IF   EXC-SEARCH-ORDER-UNDERFLOW THROW   THEN
  DUP 0<
  IF   DROP FORTH-WORDLIST 1 THEN
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

\  WORDLIST structure
\  Offset (CELLS)   Value
\  +0               last word in wordlist (modified by header creation words)
\  +1               wordlist name, HEAD (if any, 0 otherwise)
\  +2               previous WORDLIST
\  +3               WORDLIST-VT
\
\  WORDLIST-VT structure
\  Offset (CELLS)   Value
\  +0               SEARCH XT, stack effect ( c-addr u wid -- 0 | xt 1 | xt -1 )

: WORDLIST
  HERE DUP 0 DUP , , LAST-WORDLIST DUP >R @ , WORDLIST-VT , R> !
;

: WL>VOC (S wordlist-id -- voc-xt-addr )
  CELL+
;

: WL>PREV-WL (S wordlist-id -- prev-wordlist-id-addr )
  [ 2 CELLS ] LITERAL +
;

: ONLY
  -1 SET-ORDER
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
  \ S: wid "name" --
  CREATE DUP , WL>VOC LATEST-HEAD@ SWAP ! DOES>-VOCABULARY
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

: SCAN-WORDLIST (S addr wid -- c-addr u TRUE | FALSE )
  \ Find element of word list wid which follows addr.
  \ Return file name c-addr u and flag TRUE if found.
  \ Return FALSE if not found.
  WL>LATEST @
  BEGIN
    DUP DUP 0<> \ S: addr h-id1 h-id1 flag
    IF
      H>NEXT>H
      DUP 0<>   \ S: addr h-id1 h-id2 flag
    THEN
  WHILE
    2 PICK <
    IF   NIP H>#NAME TRUE EXIT   THEN
    H>NEXT>H
  REPEAT
  2DROP DROP FALSE
;

FORTH-WORDLIST (VOCABULARY) FORTH

REPORT-NEW-NAME !
