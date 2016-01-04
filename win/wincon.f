\
\  wincon.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\
\  An interface to WINCON.DLL
\

CR .( Loading WINCON definitions )

CREATE-REPORT @
CREATE-REPORT OFF

USER CONST-VALUE 1 CELLS USER-ALLOC

DLLImport WINCON.DLL "wincon.dll"

Int32DLLEntry FindConstant WINCON.DLL FindConstant

: GetWindowsConstant ( c-addr count wid -- value 1 | 0 )
  DROP SWAP 2>R CONST-VALUE 2R> FindConstant 
  DUP IF CONST-VALUE @ SWAP THEN ;

CREATE-REPORT !

\  BOOL FindConstant(char *addr, int len, int *value)
