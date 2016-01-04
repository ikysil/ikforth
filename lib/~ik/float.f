\
\  float.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  Definitions needed to load Brad Eckert's float.f under IKForth
\

CR .( Loading FLOAT definitions )

CREATE-REPORT @
CREATE-REPORT OFF

<ENV
             TRUE  CONSTANT FLOATING
             TRUE  CONSTANT FLOATING-EXT
ENV>

S" lib\~be\float.f"           INCLUDED

CREATE-REPORT !
