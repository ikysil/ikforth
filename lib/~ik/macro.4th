\
\  macro.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading MACRO definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: MACRO (S "name <char> ccc<char>" -- )
  : CHAR PARSE POSTPONE SLITERAL POSTPONE EVALUATE POSTPONE ; IMMEDIATE
;

REPORT-NEW-NAME !