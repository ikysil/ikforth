\
\  locals.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading LOCALS definitions )

CREATE-REPORT @
CREATE-REPORT OFF

<ENV
                8  CONSTANT #LOCALS
             TRUE  CONSTANT LOCALS
             TRUE  CONSTANT LOCALS-EXT
ENV>

: (LOCAL) ; COMPILE-ONLY

: LOCALS| ( "name...name |" -- )
  BEGIN
    BL WORD COUNT OVER C@
    [CHAR] | - OVER 1 - OR
  WHILE
    (LOCAL)
  REPEAT 2DROP 0 0 (LOCAL) ; IMMEDIATE

CREATE-REPORT !
