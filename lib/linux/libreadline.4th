\
\  libreadline.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" lib/win32/dllintf.f"

CR .( Loading libreadline definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DLLImport LIBREADLINE.SO "libreadline.so.6"

cdecl-import-c1 _readline LIBREADLINE.SO readline

: libc-readline
   (S z-prompt -- z-addr )
   \ readline will read a line from the terminal and return it,
   \ using prompt as a prompt.
   \ If prompt is NULL or the empty string, no prompt is issued.
   \ The line returned is allocated with malloc; the caller must free it when finished.
   \ The line returned has the final newline removed, so only the text of the line remains.
   1 _readline
;

: ACCEPT-READLINE
   (S c-addr +n1 -- +n2 )
   \ Receive a string of at most +n1 characters.
   DUP 0=
   OVER 0< OR
   OVER 32767 > OR
   IF   EXC-INVALID-NUM-ARGUMENT THROW   THEN
   0 libc-readline
   ?DUP IF
      DUP >R
      \ c-addr +n1 z-addr
      ZCOUNT
      \ c-addr +n1 z-addr z-count
      2SWAP ROT MIN
      DUP >R CMOVE R> R>
      \ +n2 z-addr
      libc-free
   ELSE
      2DROP 0
   THEN
;

REPORT-NEW-NAME !
