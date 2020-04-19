PURPOSE: Linux specific definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REQUIRES" sysdict/dynlib.4th"
REQUIRES" sysdict/x86-linux/linconst.4th"

CR .( Probing for Linux host )

S" libc.so.6" (LoadLibrary) [IF]

<ENV

: PLATFORM S" Linux" ;

ENV>

REQUIRES" sysdict/x86-linux/lindynlib.4th"
REQUIRES" sysdict/x86-linux/libc.4th"
REQUIRES" sysdict/x86-linux/libreadline.4th"
REQUIRES" sysdict/x86-linux/linfile.4th"
REQUIRES" sysdict/term/linconsole.4th"

:NONAME
   S" ANSITERM-INIT"
; IS TERMINIT-DEFAULT

[THEN]
