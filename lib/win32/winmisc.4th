\
\  winmisc.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading WINMISC definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

USER TIME&DATE-STRUC 16 USER-ALLOC

:NONAME (S -- +n1 +n2 +n3 +n4 +n5 +n6 )
  TIME&DATE-STRUC
  DUP GetLocalTime
  DUP 6 WORDS+ W@ SWAP
  DUP 5 WORDS+ W@ SWAP
  DUP 4 WORDS+ W@ SWAP
  DUP 3 WORDS+ W@ SWAP
  DUP 1 WORDS+ W@ SWAP
  DUP 0 WORDS+ W@ SWAP
  DROP
; IS TIME&DATE

:NONAME (S c-addr u char -- )
  SWAP ROT FillMemory
; IS FILL

REPORT-NEW-NAME !
