\
\  lincon.4th
\
\  Unlicense since 1999 by Illya Kysil
\
\  An interface to liblincon.so
\

REQUIRES" sysdict/dynlib.4th"

CR .( Loading lincon definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

0 CONSTANT NIL

USER CONST-VALUE 1 CELLS USER-ALLOC

S" lib/linux/liblincon.so" DYNLIB LINCON.SO

LINCON.SO S" FindConstant" DYNLIB-SYMBOL 3 CDECL-C1 FindConstant

: GetLinuxConstant ( c-addr count -- value 1 | 0 )
   SWAP 2>R CONST-VALUE 2R> FindConstant
   DUP IF CONST-VALUE @ SWAP THEN
;

:NONAME (S c-addr u -- )
   2DUP GetLinuxConstant
   IF
      NIP NIP DO-LIT
   ELSE
      DEFERRED INTERPRET-WORD-NOT-FOUND
   THEN
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
