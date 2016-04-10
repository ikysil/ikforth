\
\  required.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading REQUIRED definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

S" Stack changed on INCLUDE" EXCEPTION CONSTANT EXC-STACK-CHANGED

WORDLIST CONSTANT INCLUDED-WORDLIST

VARIABLE REPORT-INCLUDED
REPORT-INCLUDED OFF

VARIABLE TRACK-INCLUDED
TRACK-INCLUDED ON

: ?REPORT-INCLUDED (S c-addr count -- c-addr count )
  REPORT-INCLUDED @ IF CR ." Including " 2DUP TYPE SPACE THEN
;

HERE 3 'S' C, '"' C, BL C, 2CONSTANT S"-NAME

: DOES>INCLUDED
  DOES> @ >HEAD H>#NAME
  <# S"  INCLUDED" HOLDS '"' HOLD HOLDS S"-NAME HOLDS 0. #> TYPE
;

: INCLUDED, (S c-addr count -- xt | 0 )
  TRACK-INCLUDED @
  IF
    2>R
    GET-CURRENT GET-ORDER
    INCLUDED-WORDLIST SET-CURRENT
    0 2R> &USUAL HEADER, DUP , DOES>INCLUDED
    >R
    SET-ORDER SET-CURRENT
    R>
  ELSE
    2DROP 0
  THEN
;

: MARK-INCLUDE, \ S: -- addr
  \ Reserve a cell in data space for INCLUDE mark and return the value of previous INCLUDE mark
  HERE INCLUDE-MARK DUP @ -ROT ! 0 ,
;

: RESOLVE-INCLUDE \ S: xt addr --
  \ xt of the word whose name provides included file name
  \ addr if the value of the previous INCLUDE mark
  SWAP INCLUDE-MARK @ ! \ store xt at current INCLUDE mark
  INCLUDE-MARK !        \ restore previous INCLUDE mark
;

:NONAME (S c-addr count -- )
  ?REPORT-INCLUDED
  MARK-INCLUDE, >R
  2DUP S">Z" >R
  [ACTION-OF] INCLUDED CATCH
  R> OVER 0= IF   DUP ZCOUNT INCLUDED, R> RESOLVE-INCLUDE   ELSE   R> DROP   THEN
  FREE THROW THROW
; IS INCLUDED

: REQUIRED? (S c-addr count -- c-addr count flag )
  2DUP INCLUDED-WORDLIST SEARCH-WORDLIST DUP IF NIP THEN INVERT ;

: REQUIRED (S x*i c-addr count -- y*j )
  REQUIRED?
  IF
    SP@ [ 2 CELLS ] LITERAL + \ take account of INCLUDED arguments
    >R
    INCLUDED
    SP@ R> - 0<>
    IF EXC-STACK-CHANGED THROW THEN
  ELSE
    2DROP
  THEN
;

: (REQUIRES) (S x*i c-addr count -- y*j )
  ['] REQUIRED CATCH
  ?DUP IF
         -ROT 2DROP \ remove arguments on exception
         DUP EXC-STACK-CHANGED = IF
                                   ." Stack changed on REQUIRED" DROP
                                 ELSE THROW THEN
       THEN
;

:NONAME BL WORD COUNT (REQUIRES) ;
:NONAME BL WORD COUNT POSTPONE SLITERAL POSTPONE (REQUIRES) ;
INT/COMP: REQUIRES  (S x*i "name" -- y*j )

:NONAME PARSE" (REQUIRES) ;
:NONAME PARSE" POSTPONE SLITERAL POSTPONE (REQUIRES) ;
INT/COMP: REQUIRES" (S x*i "name" -- y*j )

: REQUIRE-NAME \ S: <name> <path> --
  \ Check if name is available using FIND, and include path if not
  BL WORD FIND NIP
  IF
    POSTPONE \
  ELSE
    BL WORD COUNT (REQUIRES)
  THEN
;

\  11.6.2.2144.10 REQUIRE
\  ( i * x "name" -- i * x )
\  Skip leading white space and parse name delimited by a white space character.
\  Push the address and length of the name on the stack and perform the function of REQUIRED.
: REQUIRE ( i*x "name" -- i*x )
   PARSE-NAME REQUIRED
;

\  11.6.2.1714 INCLUDE
\  ( i * x "name" -- j * x )
\  Skip leading white space and parse name delimited by a white space character.
\  Push the address and length of the name on the stack and perform the function of INCLUDED.
: INCLUDE ( i*x "name" -- j*x )
   PARSE-NAME INCLUDED
;

REPORT-NEW-NAME !
