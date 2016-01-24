\
\  hostenv.4th
\
\  Copyright (C) 2016 Illya Kysil
\

CR .( Loading HOSTENV definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: ENVP? (S c-addr1 count1 -- c-addr2 count2 true | false ) \ seach host environment variable and return value as counted string
  ENVP >R
  BEGIN
    R@ @ ?DUP
  WHILE
    ZCOUNT
    \ S: c-addr1 count1 c-addr-envp count-envp
    2OVER 2OVER 2 PICK MIN 
    \ S: c-addr1 count1 c-addr-envp count-envp c-addr1 count1 c-addr-env MIN(count1, count-env)
    COMPARE
    0= IF
      2 PICK 2 PICK + C@
      [CHAR] = = IF
        \ S: c-addr1 count1 c-addr-envp count-envp
        DROP
        + CHAR+ NIP
        ZCOUNT
        TRUE
        R> DROP
        EXIT
      ELSE
        2DROP
      THEN
    ELSE
      2DROP
    THEN
    R> CELL+ >R
  REPEAT
  2DROP
  R> DROP
  FALSE
;

REPORT-NEW-NAME !
