\
\  platform.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading PLATFORM definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: PLATFORM? (S -- c-addr count ) \ return string identifying platform
  S" PLATFORM" ENVIRONMENT? INVERT IF S" unknown" THEN
;

REPORT-NEW-NAME !
