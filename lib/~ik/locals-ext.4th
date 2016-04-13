\
\  locals-ext.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" lib/ansi/locals.4th"

CR .( Loading LOCALS-EXT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\  LOCAL (S x "<spaces>name -- )
\  Parse name and create a local initialized with x.
: LOCAL
   PARSE-NAME (LOCAL)
; IMMEDIATE/COMPILE-ONLY

REPORT-NEW-NAME !
