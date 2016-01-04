\
\  memory.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading MEMORY definitions )

CREATE-REPORT @
CREATE-REPORT OFF

<ENV
             TRUE  CONSTANT MEMORY-ALLOC
             TRUE  CONSTANT MEMORY-ALLOC-EXT
ENV>

: ALLOCATE (S size -- addr ior )
  GPTR GlobalAlloc GetLastError ;

: FREE (S addr -- ior )
  GlobalFree DROP GetLastError ;

: RESIZE (S addr -- addr ior )
  0 -ROT SWAP GlobalReAlloc GetLastError ;

CREATE-REPORT !
