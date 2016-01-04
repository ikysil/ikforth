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

S" lib\win32\dllintf.f"         INCLUDED
S" lib\win32\wincon.f"          INCLUDED
S" lib\win32\kernel32.f"        INCLUDED
S" lib\win32\winexception.f"    INCLUDED
S" lib\win32\winconsole.f"      INCLUDED
S" lib\win32\winfile.f"         INCLUDED
S" lib\win32\winmisc.f"         INCLUDED
