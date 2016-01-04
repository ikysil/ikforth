\
\  fetchstore-ext.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading FETCHSTORE-EXT definitions )

CREATE-REPORT @
CREATE-REPORT ON

BASE @

HEX

: W>S-S DUP 8000 AND 0<> IF FFFF0000 ELSE 0 THEN OR ;

: U@16B DUP C@ SWAP 1+ C@ SWAP 8 LSHIFT OR ;

: U@16L DUP C@ SWAP 1+ C@ 8 LSHIFT OR ;

: @16B U@16B W>S-S ;

: @16L U@16L W>S-S ;

BASE !

CREATE-REPORT !
