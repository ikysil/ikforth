\
\  words.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

S" lib\kernel\consts.f"       INCLUDED
S" lib\kernel\ikforth.f"      INCLUDED
\ S" lib\kernel\source.f"       INCLUDED
S" lib\kernel\chain.f"        INCLUDED

:NONAME INIT-USER ;
CHAIN STARTUP-CHAIN

:NONAME ;
CHAIN SHUTDOWN-CHAIN

S" lib\kernel\double.f"       INCLUDED
S" lib\kernel\format.f"       INCLUDED
S" lib\kernel\exception.f"    INCLUDED
S" lib\kernel\search-order.f" INCLUDED
S" lib\kernel\string.f"       INCLUDED
S" lib\kernel\zchar.f"        INCLUDED
S" lib\kernel\required.f"     INCLUDED

required-report off

S" lib\kernel\environment.f"  INCLUDED
S" lib\kernel\platform.f"     INCLUDED
S" lib\kernel\quit.f"         INCLUDED
S" lib\kernel\block.f"        INCLUDED
S" lib\kernel\case.f"         INCLUDED
S" lib\ansi\value.f"          INCLUDED

S" lib\kernel\tools.f"        INCLUDED

: WIN32 TRUE ;

[DEFINED] WIN32 [IF]

<ENV

: PLATFORM S" Win32" ;

ENV>

S" lib\win32\dllintf.f"       INCLUDED
\ S" lib\win32\wincon.f"        INCLUDED
S" lib\win32\consts.f"        INCLUDED
S" lib\win32\kernel32.f"      INCLUDED
S" lib\win32\winerror.f"      INCLUDED
S" lib\win32\winconsole.f"    INCLUDED

[THEN]

S" lib\kernel\misc.f"         INCLUDED
S" lib\kernel\file.f"         INCLUDED
S" lib\ansi\see.f"            INCLUDED

S" lib\~ik\macro.f"           INCLUDED
S" lib\~ik\loop.f"            INCLUDED
S" lib\~ik\class.f"           INCLUDED
S" lib\~ik\486asm.f"          INCLUDED
S" lib\~ik\float.f"           INCLUDED
S" lib\~ik\S$.f"              INCLUDED
