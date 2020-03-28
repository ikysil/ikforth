\
\  wincon.4th
\
\  Unlicense since 1999 by Illya Kysil
\
\  An interface to WINCON.DLL
\

REQUIRES" sysdict/dynlib.4th"

CR .( Loading WINCON definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

0 CONSTANT NIL

USER CONST-VALUE 1 CELLS USER-ALLOC

S" lib/win32/wincon.dll" DYNLIB WINCON.DLL

WINCON.DLL S" FindWin32Constant" DYNLIB-SYMBOL STDCALL-C1 FindWin32Constant

: GetWindowsConstant ( c-addr count -- value 1 | 0 )
   SWAP 2>R CONST-VALUE 2R> FindWin32Constant
   DUP IF CONST-VALUE @ SWAP THEN
;

:NONAME (S c-addr u -- )
   2DUP GetWindowsConstant
   IF
      NIP NIP DO-LIT
   ELSE
      DEFERRED INTERPRET-WORD-NOT-FOUND
   THEN
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
