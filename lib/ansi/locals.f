\
\  locals.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading LOCALS definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

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

REPORT-NEW-NAME !
