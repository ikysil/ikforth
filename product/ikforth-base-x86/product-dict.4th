\
\  product-dict.4th
\
\  Unlicense since 1999 by Illya Kysil
\

S" sysdict/primitives.4th"     INCLUDED
S" sysdict/int-slash-comp-colon.4th" INCLUDED
S" sysdict/x86/paren-do-paren.4th" INCLUDED
S" sysdict/x86/i.4th"          INCLUDED
S" sysdict/x86/i-tick.4th"     INCLUDED
S" sysdict/x86/j.4th"          INCLUDED
S" sysdict/x86/leave.4th"      INCLUDED
S" sysdict/x86/exit.4th"       INCLUDED
S" sysdict/const.4th"          INCLUDED
S" sysdict/core.4th"           INCLUDED
S" sysdict/core-tools.4th"     INCLUDED
S" sysdict/trace.4th"          INCLUDED
S" sysdict/value.4th"          INCLUDED
S" sysdict/recognizer.4th"     INCLUDED
S" sysdict/string.4th"         INCLUDED
S" sysdict/string-escape.4th"  INCLUDED
S" sysdict/zchar.4th"          INCLUDED
S" sysdict/args.4th"           INCLUDED
S" sysdict/chain.4th"          INCLUDED

' INIT-USER CHAIN STARTUP-CHAIN

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

REQUIRES" sysdict/environment.4th"
REQUIRES" sysdict/platform.4th"
REQUIRES" sysdict/hostenv.4th"

REQUIRES" sysdict/fetchstore-ext.4th"
REQUIRES" sysdict/tools.4th"
REQUIRES" sysdict/misc.4th"
REQUIRES" sysdict/file.4th"
REQUIRES" sysdict/struct.4th"
REQUIRES" sysdict/word.4th"

REQUIRES" sysdict/case.4th"
REQUIRES" sysdict/block.4th"
REQUIRES" sysdict/quotations.4th"

REQUIRES" sysdict/sformat.4th"
REQUIRES" sysdict/locate.4th"

REQUIRES" sysdict/locals-stack.4th"
REQUIRES" sysdict/locals.4th"
REQUIRES" sysdict/locals-ext.4th"

REQUIRES" sysdict/dynlib.4th"
REQUIRES" sysdict/x86-windows.4th"
REQUIRES" sysdict/x86-linux.4th"

REQUIRES" sysdict/term/ansiterm.4th"


REQUIRES" sysdict/macro.4th"
REQUIRES" sysdict/loop.4th"
REQUIRES" sysdict/S$.4th"
REQUIRES" sysdict/quit.4th"
REQUIRES" sysdict/main.4th"
