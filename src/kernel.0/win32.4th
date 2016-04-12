\
\  win32.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\
\  Win32 specific definitions
\

REQUIRES" lib/~ik/dynlib.4th"

CR .( Probing for Win32 host )

S" kernel32.dll" (LoadLibrary) [IF]

<ENV

: PLATFORM S" Win32" ;

ENV>

REQUIRES" lib/win32/kernel32.4th"
REQUIRES" lib/win32/wincon.4th"
REQUIRES" lib/win32/winexception.4th"
REQUIRES" lib/term/winconsole.4th"
REQUIRES" lib/win32/winfile.4th"
REQUIRES" lib/win32/winmisc.4th"

:NONAME
   S" WINCONSOLE-INIT"
; IS TERMINIT-DEFAULT

[THEN]
