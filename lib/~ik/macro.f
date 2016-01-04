\
\  macro.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading MACRO definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: MACRO (S "name <char> ccc<char>" -- )
  : CHAR PARSE POSTPONE SLITERAL POSTPONE EVALUATE POSTPONE ; IMMEDIATE
;

CREATE-REPORT !
