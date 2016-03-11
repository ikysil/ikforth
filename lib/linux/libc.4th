\
\  libc.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" lib/win32/dllintf.f"

CR .( Loading libc definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DLLImport LIBC.SO "libc.so.6"

REPORT-NEW-NAME !
