\
\  linux.4th
\
\  Copyright (C) 2016 Illya Kysil
\
\  Linux specific definitions
\

REQUIRES" lib/win32/dllintf.f"

CR .( Probing for Linux host )

S" libc.so.6" (LoadLibrary) [IF]

<ENV

: PLATFORM S" Linux" ;

ENV>

REQUIRES" lib/linux/libc.4th"
REQUIRES" lib/linux/libreadline.4th"

:NONAME
   S" ANSITERM-INIT"
; IS TERMINIT-DEFAULT

[THEN]
