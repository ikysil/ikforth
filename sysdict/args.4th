\
\  args.4th
\
\  Copyright (C) 2016 Illya Kysil
\

CR .( Loading ARGS definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: ARGV? (S n -- c-addr count true | false ) \ retrieve n-th argument as counted string
  DUP 0< IF DROP FALSE EXIT THEN
  DUP ARGC < IF CELLS ARGV + @ ZCOUNT TRUE EXIT THEN
  DROP FALSE
;

USER CURRENT-ARG 1 CELLS USER-ALLOC

: RESET-ARGS (S -- )
  0 CURRENT-ARG !
;

: NEXT-ARG (S -- c-addr count true | false ) \ retrieve next argument as counted string
  CURRENT-ARG @ ARGV?
;

: SHIFT-ARG (S -- ) \ go to next argument
  1 CURRENT-ARG +!
;

REPORT-NEW-NAME !
