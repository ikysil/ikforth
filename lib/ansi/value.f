\
\  value.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading VALUE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\ -----------------------------------------------------------------------------
\ VALUE TO +TO
\ -----------------------------------------------------------------------------

: VALUE CREATE , DOES> @ ;

:NONAME ' >BODY ! ;
:NONAME ' >BODY POSTPONE LITERAL POSTPONE ! ;
INT/COMP: TO IMMEDIATE

:NONAME ' >BODY +! ;
:NONAME ' >BODY POSTPONE LITERAL POSTPONE +! ;
INT/COMP: +TO IMMEDIATE

REPORT-NEW-NAME !
