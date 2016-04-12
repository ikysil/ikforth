\
\  _kernel0.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

S" src/kernel.0/primitives.4th"   INCLUDED
S" src/kernel/const.4th"          INCLUDED
S" src/kernel/core.4th"           INCLUDED
S" src/kernel/core-tools.4th"     INCLUDED
S" src/kernel/string.4th"         INCLUDED
S" src/kernel/string-escape.4th"  INCLUDED
S" src/kernel/zchar.4th"          INCLUDED
S" src/kernel/args.4th"           INCLUDED
S" src/kernel/chain.4th"          INCLUDED

:NONAME INIT-USER ;
CHAIN STARTUP-CHAIN

:NONAME ;
CHAIN SHUTDOWN-CHAIN

S" src/kernel/literal-ext.4th"    INCLUDED
S" src/kernel/source.4th"         INCLUDED
S" src/kernel/double.4th"         INCLUDED
S" src/kernel/format.4th"         INCLUDED
S" src/kernel/exception.4th"      INCLUDED
S" src/kernel/exception-ext.4th"  INCLUDED
S" src/kernel/search-order.4th"   INCLUDED
S" src/kernel/required.4th"       INCLUDED
S" src/kernel/environment.4th"    INCLUDED
S" src/kernel/platform.4th"       INCLUDED
S" src/kernel/hostenv.4th"        INCLUDED

S" src/kernel/fetchstore-ext.4th" INCLUDED
S" src/kernel/tools.4th"          INCLUDED
S" src/kernel/misc.4th"           INCLUDED
S" src/kernel/file.4th"           INCLUDED
S" src/kernel/struct.4th"         INCLUDED

S" lib/ansi/case.4th"             INCLUDED
S" lib/ansi/value.4th"            INCLUDED
S" lib/ansi/block.4th"            INCLUDED
REQUIRES" lib/~ik/quotations.4th"
S" lib/ansi/see.4th"              INCLUDED

REQUIRES" lib/~ik/dynlib.4th"
REQUIRES" src/kernel.0/win32.4th"
REQUIRES" src/kernel.0/linux.4th"

S" lib/term/ansiterm.4th"         INCLUDED

REQUIRES" lib/~ik/locate.4th"
REQUIRES" lib/~ik/locals.4th"
REQUIRES" lib/ansi/locals.4th"

S" lib/~ik/macro.4th"             INCLUDED
S" lib/~ik/loop.4th"              INCLUDED
REQUIRES" lib/~ik/486asm.4th"
S" lib/~ik/class.4th"             INCLUDED
\ S" lib/~ik/float.4th"           INCLUDED
S" lib/~ik/S$.4th"                INCLUDED
REQUIRES" src/kernel/quit.4th"
REQUIRES" src/kernel/main.4th"
