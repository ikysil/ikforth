\
\  float.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  Definitions needed to load Brad Eckert's float.f under IKForth
\

CR .( Loading FLOAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

<ENV
             TRUE  CONSTANT FLOATING
             TRUE  CONSTANT FLOATING-EXT
ENV>

S" lib\~be\float.f"           INCLUDED

REPORT-NEW-NAME !
