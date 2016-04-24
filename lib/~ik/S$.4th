\
\  S$.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading S$ definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ Match delimiters for string
: (S-DELIM) ( c1 -- c2)
  CASE
    [CHAR] < OF [CHAR] > ENDOF
    [CHAR] { OF [CHAR] } ENDOF
    [CHAR] [ OF [CHAR] ] ENDOF
    [CHAR] ( OF [CHAR] ) ENDOF
    DUP                    \ use same character for all others
  ENDCASE
;

\ run-time routine for string parsing
: PARSE-S$ ( <char1>ccc<char2> -- addr u)
  >IN @
  CHAR
  SWAP >IN !
  DUP PARSE 2DROP
  (S-DELIM)                \ determine second delimiter
  PARSE                    \ parse to  second delimiter
;

\ run-time routine for string parsing
: PARSE-S\$ ( <char1>ccc<char2> -- addr u)
  >IN @
  CHAR
  SWAP >IN !
  DUP PARSE 2DROP
  (S-DELIM)                \ determine second delimiter
  PARSE\                   \ parse to  second delimiter
;

\ parse string; if compiling, compile it as a literal.
:NONAME PARSE-S$ ;
:NONAME PARSE-S$ POSTPONE SLITERAL ;
INT/COMP: S$

\ parse string; if compiling, compile it as a literal.
:NONAME PARSE-S\$ ;
:NONAME PARSE-S\$ POSTPONE SLITERAL ;
INT/COMP: S\$

\ parse string and print it
: .$ ( <char1>ccc<char2> -- )
  PARSE-S$ TYPE
; IMMEDIATE

\ parse string and print it
: .\$ ( <char1>ccc<char2> -- )
  PARSE-S\$ TYPE
; IMMEDIATE

REPORT-NEW-NAME !
