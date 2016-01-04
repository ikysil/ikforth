\
\  value.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading VALUE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

\ -----------------------------------------------------------------------------
\ VALUE
\ -----------------------------------------------------------------------------

: VALUE CREATE , DOES> @ ;

: TO
  ' >BODY
  STATE @
  IF
    POSTPONE LITERAL POSTPONE !
  ELSE
    !
  THEN ; IMMEDIATE

: +TO
  ' >BODY
  STATE @
  IF
    POSTPONE LITERAL POSTPONE +!
  ELSE
    +!
  THEN ; IMMEDIATE

CREATE-REPORT !
