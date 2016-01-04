\
\  wincon.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  An interface to WINCON.DLL
\

CR .( Loading WINCON definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

0 CONSTANT NIL

USER CONST-VALUE 1 CELLS USER-ALLOC

DLLImport WINCON.DLL "wincon.dll"

Int32DLLEntry FindWin32Constant WINCON.DLL FindWin32Constant

: GetWindowsConstant ( c-addr count -- value 1 | 0 )
  SWAP 2>R CONST-VALUE 2R> FindWin32Constant
  DUP IF CONST-VALUE @ SWAP THEN ;

:NONAME (S c-addr u -- )
  2DUP GetWindowsConstant
  IF
    NIP NIP DO-LIT
  ELSE
    DEFER@-EXECUTE INTERPRET-WORD-NOT-FOUND
  THEN
; IS INTERPRET-WORD-NOT-FOUND

REPORT-NEW-NAME !
