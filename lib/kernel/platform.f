\
\  platform.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading PLATFORM definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: PLATFORM? (S -- c-addr count ) \ return string identifying platform
  S" PLATFORM" ENVIRONMENT? INVERT IF S" unknown" THEN
;

CREATE-REPORT !
