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
   2DUP CR TYPE SPACE
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

TRACE-END

: HT@ (S n -- x )
   CELLS LAST-HT + @
;

: HT! (S x n -- )
   CELLS LAST-HT + !
;

TRACE-BEGIN

: ?HT-FREE (S addr -- true | false )
   \G Check if hashtable bucket at addr is free.
   HT@ 0=
;

: HT-STEP (S k s -- k')
   \G Perform double hashing step.
   + CONSTDICT-ENTRIES UMOD
;

: HT-INSERT (S n addr -- )
   \G Insert reference to CONSTDICT CONSTANT structure at addr to index n.
   >R
   DUP STEP-HASH SWAP KEY-HASH
   DUP >R
   BEGIN
      \ S: sh' kh'    R: kh addr
      2DUP HT-STEP R@ <>
   WHILE
      ." ."
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

TRACE-END

: HT-CONSTDICT (S addr -- )
   \G Populate hash table at LAST-HT.
   \G addr is the address of last CONSTDICT CONSTANT structure.
   BEGIN
      DUP 0<>
   WHILE
      \DEBUG DUP CR 64 DUMP CR
      DUP C>NAME COUNT NAME-HASH
      OVER HT-INSERT
      C>LINK @
   REPEAT
   DROP
;

ONLY FORTH DEFINITIONS ALSO CONSTDICT-PRIVATE ALSO CONSTDICT-DEF

\ public definitions go here
\ private definitions are available for use

: BEGIN-CONST (S -- )
   \G Begin constant dictionary definitions.
   0 TO LAST-CONST
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
   CREATE DUP , CONSTDICT-ENTRIES ,
   HERE DUP TO LAST-HT
   CONSTDICT-ENTRIES CELLS
   DUP ALLOT ERASE
   HT-CONSTDICT
   0 TO LAST-HT
;

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
