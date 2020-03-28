\
\  hostenv.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading HOSTENV definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

USER XT?-ENVP-XT 1 CELLS USER-ALLOC

: XT?-ENVP (S x*i xt -- x*j )
   \ execute xt for each entry in ENVP
   \ xt stack effect: S: x*i -- x*j flag
   \ return flag FALSE to stop enumeration
   XT?-ENVP-XT !
   ENVP >R
   BEGIN
      R@ @ DUP
      IF
         ZCOUNT
         XT?-ENVP-XT @ EXECUTE
      THEN
   WHILE
      R> CELL+ >R
   REPEAT
   R> DROP
;

: .S-HOSTENV (S c-addr count -- true )
   TYPE CR
   TRUE
;

: .HOSTENV
   (G Print host environment variables )
   ['] .S-HOSTENV XT?-ENVP
;

: ENVP?=VALUE?
   KEY=VALUE? INVERT
;

: ENVP? (S c-addr1 count1 -- c-addr2 count2 true | false )
   (G seach host environment variable and return value as counted string )
   ['] ENVP?=VALUE? XT?-ENVP
   2DROP
   KEY-VALUE?-RESULT 2@
   OVER
   \ S: c-addr count c-addr
   IF   TRUE   ELSE   2DROP FALSE   THEN
;

REPORT-NEW-NAME !
