\
\  locals-ext.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REQUIRES" sysdict/locals.4th"

CR .( Loading LOCALS-EXT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\  LOCAL (S x "<spaces>name -- )
\  Parse name and create a local initialized with x.
: LOCAL
   PARSE-NAME (LOCAL)
; IMMEDIATE/COMPILE-ONLY

REPORT-NEW-NAME !
