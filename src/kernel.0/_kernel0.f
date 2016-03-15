\
\  _kernel0.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

S" src/kernel.0/primitives.f"   INCLUDED
S" src/kernel/const.f"          INCLUDED
S" src/kernel/core.f"           INCLUDED
S" src/kernel/string.f"         INCLUDED
S" src/kernel/string-escape.4th"  INCLUDED
S" src/kernel/zchar.f"          INCLUDED
S" src/kernel/args.4th"         INCLUDED
S" src/kernel/chain.f"          INCLUDED

:NONAME INIT-USER ;
CHAIN STARTUP-CHAIN

:NONAME ;
CHAIN SHUTDOWN-CHAIN

S" src/kernel/literal-ext.f"    INCLUDED
S" src/kernel/source.f"         INCLUDED
S" src/kernel/double.f"         INCLUDED
S" src/kernel/format.f"         INCLUDED
S" src/kernel/exception.f"      INCLUDED
S" src/kernel/exception-ext.f"  INCLUDED
S" src/kernel/search-order.f"   INCLUDED
S" src/kernel/required.f"       INCLUDED
S" src/kernel/environment.f"    INCLUDED
S" src/kernel/platform.f"       INCLUDED
S" src/kernel/hostenv.4th"      INCLUDED

S" src/kernel/fetchstore-ext.f" INCLUDED
S" src/kernel/tools.f"          INCLUDED
S" src/kernel/misc.f"           INCLUDED
S" src/kernel/file.f"           INCLUDED
S" src/kernel/struct.f"         INCLUDED

S" lib/ansi/case.f"             INCLUDED
S" lib/ansi/value.f"            INCLUDED
S" lib/ansi/block.f"            INCLUDED
REQUIRES" lib/~ik/quotations.4th"
S" lib/ansi/see.f"              INCLUDED

REQUIRES" src/kernel.0/win32.f"
REQUIRES" src/kernel.0/linux.4th"

S" lib/term/ansiterm.4th"       INCLUDED

REQUIRES" lib/~ik/locate.4th"
S" lib/~ik/macro.f"             INCLUDED
S" lib/~ik/loop.f"              INCLUDED
REQUIRES" lib/~ik/486asm.f"
S" lib/~ik/class.f"             INCLUDED
\ S" lib/~ik/float.f"             INCLUDED
S" lib/~ik/S$.f"                INCLUDED
REQUIRES" src/kernel/quit.f"
REQUIRES" src/kernel/main.f"
