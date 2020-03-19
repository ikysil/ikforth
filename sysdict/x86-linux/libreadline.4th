\
\  libreadline.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REQUIRES" sysdict/dynlib.4th"

CR .( Loading libreadline definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

(S z-prompt -- z-addr )
\ readline will read a line from the terminal and return it,
\ using prompt as a prompt.
\ If prompt is NULL or the empty string, no prompt is issued.
\ The line returned is allocated with malloc; the caller must free it when finished.
\ The line returned has the final newline removed, so only the text of the line remains.
DEFER libc-readline

:NONAME
   -1 ABORT" FATAL: Can not initialize libreadline"
; IS libc-readline

0 VALUE LIBREADLINE.SO-ID

0 VALUE DS-libc-readline

: (LIBREADLINE-FIND) (S -- library-id )
   S" libreadline.so.8" (LoadLibrary) ?DUP ?EXIT
   S" libreadline.so.7" (LoadLibrary) ?DUP ?EXIT
   S" libreadline.so.6" (LoadLibrary) ?DUP ?EXIT
   0
;

: (LIBREADLINE-CALL-DS) (S z-prompt -- z-addr )
   DS-libc-readline
   ?DUP 0= IF
      CR ." FATAL: Can not initialize libreadline" CR
      0
   THEN
   1 SWAP CALL-CDECL-C1
;

: (LIBREADLINE-INIT) (S -- )
   0 TO LIBREADLINE.SO-ID
   0 TO DS-libc-readline
   (LIBREADLINE-FIND) TO LIBREADLINE.SO-ID
   LIBREADLINE.SO-ID 0= IF   EXIT   THEN
   S" readline" LIBREADLINE.SO-ID (GetProcAddress)
   GetLastError THROW
   TO DS-libc-readline
   ['] (LIBREADLINE-CALL-DS) IS libc-readline
;

:NONAME
   (LIBREADLINE-INIT)
; DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

:NONAME
   LIBREADLINE.SO-ID 0= IF   EXIT   THEN
   LIBREADLINE.SO-ID FreeLibrary
; DUP SHUTDOWN-CHAIN CHAIN.ADD EXECUTE

REPORT-NEW-NAME !
