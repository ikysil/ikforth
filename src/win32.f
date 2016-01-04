\
\  win32.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  Win32 specific definitions
\

<ENV

: PLATFORM S" Win32" ;

ENV>

S" src\win32\dllintf.f"         INCLUDED
S" src\win32\wincon.f"          INCLUDED
S" src\win32\kernel32.f"        INCLUDED
S" src\win32\winexception.f"    INCLUDED
S" src\win32\winconsole.f"      INCLUDED
S" src\win32\winfile.f"         INCLUDED
S" src\win32\winmisc.f"         INCLUDED
