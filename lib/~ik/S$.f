\
\  S$.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading S$ definitions )

CREATE-REPORT @
CREATE-REPORT OFF

\ Match delimiters for string
: (S-DELIM) ( c1 -- c2)
  CASE
    [CHAR] < OF [CHAR] > ENDOF
    [CHAR] { OF [CHAR] } ENDOF
    [CHAR] [ OF [CHAR] ] ENDOF
    [CHAR] ( OF [CHAR] ) ENDOF
    DUP                         \ use same character for all others
  ENDCASE
;
\ run-time routine for string parsing
: PARSE-S$ ( <char1>ccc<char2> -- addr u)
  SOURCE >IN @ MIN +          \ address of 1st character
  C@ (S-DELIM)                \ determine second delimiter
    1 >IN +!                  \ bump past first  delimiter
  PARSE                       \ parse to  second delimiter
;

\ parse string; if compiling, compile it as a literal.
:NONAME PARSE-S$ ;
:NONAME PARSE-S$ POSTPONE SLITERAL ;
INT/COMP: S$

\ parse string and print it
: .$ ( <char1>ccc<char2> -- )
  PARSE-S$ TYPE
; IMMEDIATE

CREATE-REPORT !
