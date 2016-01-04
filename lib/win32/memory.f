\
\  memory.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading MEMORY definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: ALLOCATE (S size -- addr ior )
  GPTR GlobalAlloc GetLastError ;

: FREE (S addr -- ior )
  GlobalFree DROP GetLastError ;

: RESIZE (S newsize addr -- addr ior )
  0 -ROT SWAP GlobalReAlloc GetLastError ;

CREATE-REPORT !
