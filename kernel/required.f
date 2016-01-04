\
\  required.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading REQUIRED definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: REQUIRED? (S c-addr count -- c-addr count flag )
  TRUE ;

: REQUIRED (S x*i c-addr count -- y*j )
  REQUIRED? IF INCLUDED ELSE 2DROP THEN ;

CREATE-REPORT !
