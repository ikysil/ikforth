\
\  constdict.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading CONSTDICT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

VOCABULARY CONSTDICT-PRIVATE

ALSO CONSTDICT-PRIVATE DEFINITIONS

\ private definitions go here

\  CONSTDICT CONSTANT structure:
\   +0   addr    link to previous constant, absolute address, 0 for first
\   +4   value   constant value
\   +8   n       constant name length
\  +12   name    constant name

\  CONSTDICT structure:
\   +0   addr       link to last CONSTDICT CONSTANT structure
\   +4   x          CONSTDICT-specific data

\  CONSTDICT structure based on hashtable:
\   +0   addr       link to last CONSTDICT CONSTANT structure
\   +4   buckets    number of buckets in hashtable
\   +8   hastable   hashtable data, buckets CELLS, absolute address of the CONSTDICT CONSTANT structure, 0 if empty

0 VALUE LAST-CONST
\G Address of the previous defined constant

: C>LINK (S addr -- addr')
   \G CONSTDICT CONSTANT structure address to link address.
;

: C>VALUE (S addr -- addr')
   \G CONSTDICT CONSTANT structure address to value address.
   [ 1 CELLS ] LITERAL +
;

: C>NAME (S addr -- addr')
   \G CONSTDICT CONSTANT structure address to name address as counted string.
   [ 2 CELLS ] LITERAL +
;

VOCABULARY CONSTDICT-DEF

ALSO CONSTDICT-DEF DEFINITIONS

: CONSTANT (S n "name" -- )
   (G Parse name and add CONSTDICT CONSTANT structure to the data space. )
   HERE SWAP
   LAST-CONST ,   \ link
   ,              \ value
   PARSE-NAME ,C" \ name
   TO LAST-CONST
;

PREVIOUS DEFINITIONS

0 VALUE LAST-HT

DECIMAL

64 1KB * CONSTANT CONSTDICT-ENTRIES
\G Maximum number of entries in CONSTDICT

65521 CONSTANT STEP-HASH-MODULO

17 CONSTANT NAME-HASH-MULT

TRACE-BEGIN

: NAME-HASH (S c-addr n -- hash)
   \ calculate hash based on input string
   0 >R
   BEGIN
      DUP 0>
   WHILE
      1- SWAP C@+    \ n' c-addr' c
      R> NAME-HASH-MULT * + >R
      SWAP
   REPEAT
   2DROP
   R>
;

: KEY-HASH (S n -- n' )
   \G Calculate key hash in a double hashing scheme.
   CONSTDICT-ENTRIES UMOD
;

: STEP-HASH (S n -- n' )
   \G Calculate step hash in a double hashing scheme.
   STEP-HASH-MODULO UMOD 1 OR
;

: HT@ (S n -- x )
   CELLS LAST-HT + @
;

: HT! (S x n -- )
   CELLS LAST-HT + !
;

: ?HT-FREE (S addr -- true | false )
   \G Check if hashtable bucket at addr is free.
   HT@ 0=
;

: HT-STEP (S k s -- k')
   \G Perform double hashing step.
   + CONSTDICT-ENTRIES UMOD
;

\G Flag to control the output of the hashing process.
0 VALUE ?CONSTDICT-REPORT-NAME

: HT-INSERT (S n addr -- )
   \G Insert reference to CONSTDICT CONSTANT structure at addr to index n.
   >R
   DUP STEP-HASH SWAP KEY-HASH
   DUP >R
   BEGIN
      \ S: sh' kh'    R: kh addr
      2DUP HT-STEP R@ <>
   WHILE
      ?CONSTDICT-REPORT-NAME IF   ." ."   THEN
      DUP ?HT-FREE
      IF
         R> DROP R>
         \ S: sh' kh' addr
         SWAP HT!
         DROP
         EXIT
      THEN
      OVER HT-STEP
   REPEAT
   EXC-CONSTDICT-OVERFLOW THROW
;

: HT-CONSTDICT (S addr -- )
   \G Populate hash table at LAST-HT.
   \G addr is the address of last CONSTDICT CONSTANT structure.
   BEGIN
      DUP 0<>
   WHILE
      \DEBUG DUP CR 64 DUMP CR
      DUP C>NAME COUNT
      ?CONSTDICT-REPORT-NAME IF
         2DUP CR TYPE SPACE
      THEN
      NAME-HASH
      OVER HT-INSERT
      C>LINK @
   REPEAT
   DROP
;

: CONSTDICT-HASH-UNPACK (S cdid -- ct-addr ht-addr n )
   \G Unpack CONSTDICT-HASH cdid into the address if hastable and number of buckets.
   \G ct-addr is address of the last constant.
   \G ht-addr is address of the hastable.
   \G n is number of buckets.
   @+ SWAP @+
;

: HT>CONST (S ht-addr n -- x)
   CELLS + @
;

: SEARCH-CONSTDICT-HASH (S c-addr u cdid -- false | x true )
   \G Search hashtable-based constdict and return constant value and true if found, false otherwise.
   \G x is the value of the constant.
   >R
   2DUP NAME-HASH                \ S: c-addr u nh        R: cdid
   DUP STEP-HASH SWAP KEY-HASH   \ S: c-addr u sh kh     R: cdid
   LOCAL kh                      \ key hash
   LOCAL sh                      \ step hash
   R>
   CONSTDICT-HASH-UNPACK
   DROP
   LOCAL ht-addr                 \ hashtable address
   DROP
   0 LOCAL const-addr            \ constant address
   BEGIN
      \ S: c-addr u
      ht-addr kh HT>CONST DUP TO const-addr
      0<>
      sh kh HT-STEP kh <>
      AND
   WHILE
      const-addr C>NAME COUNT
      2OVER COMPARE 0=
      IF
         2DROP
         const-addr C>VALUE @
         TRUE EXIT
      THEN
      sh kh HT-STEP TO kh
   REPEAT
   2DROP FALSE
;

ONLY FORTH DEFINITIONS ALSO CONSTDICT-PRIVATE ALSO CONSTDICT-DEF

\ public definitions go here
\ private definitions are available for use

: CONSTDICT-REPORT-NAME-ON
   \G Enable CONSTDICT name reporting.
   1 TO ?CONSTDICT-REPORT-NAME
;

: CONSTDICT-REPORT-NAME-OFF
   \G Disable CONSTDICT name reporting.
   0 TO ?CONSTDICT-REPORT-NAME
;

: BEGIN-CONST (S -- )
   \G Begin constant dictionary definitions.
   0 TO LAST-CONST
   CONSTDICT-REPORT-NAME-OFF
   ALSO CONSTDICT-DEF
;

: END-CONST (S -- addr )
   \G Finalise constant dictionary definitions.
   \G Returns address of the last CONSTDICT CONSTANT structure.
   LAST-CONST  DUP 0=  IF   EXC-INVALID-CONSTDICT THROW   THEN
   0 TO LAST-CONST
   PREVIOUS
;

: CONSTDICT-HASH (S addr "name" -- )
   \G Create hashtable based CONSTDICT.
   \G addr is the address of the last constant.
   LAST-HT 0<> IF   EXC-INVALID-CONSTDICT THROW   THEN
   CREATE IMMEDIATE DUP , CONSTDICT-ENTRIES ,
   HERE DUP TO LAST-HT
   CONSTDICT-ENTRIES CELLS
   DUP ALLOT ERASE
   HT-CONSTDICT
   0 TO LAST-HT
;

(S c-addr u cdid -- false | x true)
\G Search hashtable-based constdict and return constant value and true if found, false otherwise.
\G x is the value of the constant.
SYNONYM SEARCH-CONSTDICT-HASH SEARCH-CONSTDICT-HASH

: DOES>SEARCH-CONSTDICT-HASH:
   \G Runtime semantics of words defined with SEARCH-CONSTDICT-HASH:.
   \G Parse next word, search it in CONSTDICT, use result with semantics of LITERAL.
   DOES>
   @
   PARSE-NAME
   2DUP S">POCKET DROP     \ for diagnostics
   ROT SEARCH-CONSTDICT-HASH
   IF
      STATE @ IF   POSTPONE LITERAL   THEN
   ELSE
      EXC-UNDEFINED THROW
   THEN
;

: SEARCH-CONSTDICT-HASH: (S cdid "name" -- )
   \G Parse name and create a word with following runtime semantics:
   \G Parse next word, search it in CONSTDICT, use result with semantics of LITERAL.
   \G cdid is the CONSTDICT ID.
   CREATE , IMMEDIATE
   DOES>SEARCH-CONSTDICT-HASH:
;

: CDH{: (S cdid "name"*i ":}" -- x )
   \G Parse names until :} is found, resolve them in provided constdict, join values with OR,
   \G use result with semantics of LITERAL.
   >R
   0 PARSE-NAME
   BEGIN
      2DUP S" :}" MATCH-OR-END? 0= WHILE
      2DUP R@ SEARCH-CONSTDICT-HASH INVERT IF   S">POCKET EXC-UNDEFINED THROW   THEN
      >R 2DROP R> OR
      PARSE-NAME
   AGAIN THEN
   R> DROP 2DROP
   STATE @ IF   POSTPONE LITERAL   THEN
; IMMEDIATE

TRACE-END

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
