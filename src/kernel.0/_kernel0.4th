\
\  _kernel0.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

S" sysdict/primitives.4th"   INCLUDED
S" sysdict/const.4th"          INCLUDED
S" sysdict/core.4th"           INCLUDED
S" sysdict/core-tools.4th"     INCLUDED
S" sysdict/value.4th"            INCLUDED
S" sysdict/recognizer.4th"     INCLUDED
S" sysdict/string.4th"         INCLUDED
S" sysdict/string-escape.4th"  INCLUDED
S" sysdict/zchar.4th"          INCLUDED
S" sysdict/args.4th"           INCLUDED
S" sysdict/chain.4th"          INCLUDED

:NONAME INIT-USER ;
CHAIN STARTUP-CHAIN

:NONAME ;
CHAIN SHUTDOWN-CHAIN

S" sysdict/literal-ext.4th"    INCLUDED
S" sysdict/source.4th"         INCLUDED
S" sysdict/double.4th"         INCLUDED
S" sysdict/format.4th"         INCLUDED
S" sysdict/exception.4th"      INCLUDED
S" sysdict/exception-ext.4th"  INCLUDED
S" sysdict/search-order.4th"   INCLUDED
S" sysdict/required.4th"       INCLUDED
S" sysdict/environment.4th"    INCLUDED
S" sysdict/platform.4th"       INCLUDED
S" sysdict/hostenv.4th"        INCLUDED

S" sysdict/fetchstore-ext.4th" INCLUDED
S" sysdict/tools.4th"          INCLUDED
S" sysdict/misc.4th"           INCLUDED
S" sysdict/file.4th"           INCLUDED
S" sysdict/struct.4th"         INCLUDED

REQUIRES" sysdict/case.4th"
REQUIRES" sysdict/block.4th"
REQUIRES" sysdict/quotations.4th"
REQUIRES" sysdict/see.4th"

REQUIRES" sysdict/dynlib.4th"
REQUIRES" sysdict/x86-windows.4th"
REQUIRES" sysdict/x86-linux.4th"

REQUIRES" sysdict/term/ansiterm.4th"

REQUIRES" sysdict/locate.4th"
REQUIRES" sysdict/locals-stack.4th"
REQUIRES" sysdict/locals.4th"
REQUIRES" sysdict/locals-ext.4th"

REQUIRES" sysdict/macro.4th"
REQUIRES" sysdict/loop.4th"
REQUIRES" sysdict/x86/486asm.4th"
REQUIRES" sysdict/class.4th"
\ REQUIRES" sysdict/float.4th"
REQUIRES" sysdict/S$.4th"
REQUIRES" sysdict/quit.4th"
REQUIRES" sysdict/main.4th"
