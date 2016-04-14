\
\  libreadline.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" lib/~ik/dynlib.4th"

CR .( Loading libreadline definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

S" libreadline.so.6" DYNLIB LIBREADLINE.SO

(S z-prompt -- z-addr )
\ readline will read a line from the terminal and return it,
\ using prompt as a prompt.
\ If prompt is NULL or the empty string, no prompt is issued.
\ The line returned is allocated with malloc; the caller must free it when finished.
\ The line returned has the final newline removed, so only the text of the line remains.
LIBREADLINE.SO S" readline" DYNLIB-SYMBOL 1 CDECL-C1 libc-readline

REPORT-NEW-NAME !
