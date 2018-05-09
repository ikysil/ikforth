\
\  libreadline.4th
\
\  Copyright (C) 2016-2018 Illya Kysil
\

REQUIRES" sysdict/dynlib.4th"

CR .( Loading libreadline definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF


S" libreadline.so.6" DYNLIB LIBREADLINE.SO.6

0 VALUE DS-libc-readline.6

LIBREADLINE.SO.6 S" readline" DYNLIB-SYMBOL
DUP TO DS-libc-readline.6
1 CDECL-C1 libc-readline.6


S" libreadline.so.7" DYNLIB LIBREADLINE.SO.7

0 VALUE DS-libc-readline.7

LIBREADLINE.SO.7 S" readline" DYNLIB-SYMBOL
DUP TO DS-libc-readline.7
1 CDECL-C1 libc-readline.7


(S z-prompt -- z-addr )
\ readline will read a line from the terminal and return it,
\ using prompt as a prompt.
\ If prompt is NULL or the empty string, no prompt is issued.
\ The line returned is allocated with malloc; the caller must free it when finished.
\ The line returned has the final newline removed, so only the text of the line remains.
DEFER libc-readline

:NONAME
   CR ." Initializing libreadline" CR
   DS-libc-readline.6 @ 0<> IF
      ['] libc-readline.6
      IS libc-readline
      EXIT
   THEN
   DS-libc-readline.7 @ 0<> IF
       ['] libc-readline.7
       IS libc-readline
       EXIT
   THEN
   CR ." FATAL: Can not initialize libreadline" CR
; DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

REPORT-NEW-NAME !
