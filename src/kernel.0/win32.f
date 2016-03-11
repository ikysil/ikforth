\
\  win32.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  Win32 specific definitions
\

REQUIRES" lib/win32/dllintf.f"

CR .( Probing for Win32 host )

S" kernel32.dll" (LoadLibrary) [IF]

<ENV

: PLATFORM S" Win32" ;

ENV>

REQUIRES" lib/win32/kernel32.f"
REQUIRES" lib/win32/wincon.f"
REQUIRES" lib/win32/winexception.f"
REQUIRES" lib/term/winconsole.4th"
REQUIRES" lib/win32/winfile.f"
REQUIRES" lib/win32/winmisc.f"

:NONAME
   S" WINCONSOLE-INIT"
; IS TERMINIT-DEFAULT

[THEN]
