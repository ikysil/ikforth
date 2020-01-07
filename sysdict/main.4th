\
\  main.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REQUIRES" sysdict/quit.4th"
REQUIRES" sysdict/sformat.4th"

CR .( Loading MAIN definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: .COMPILED
   [
      TIME&DATE DECIMAL
      <%
         %S" Compiled: "
         4 %U0R   \ year
         CHAR - %C
         2 %U0R   \ month
         CHAR - %C
         2 %U0R   \ day
         BL %C
         2 %U0R   \ hour
         CHAR : %C
         2 %U0R   \ minute
         CHAR : %C
         2 %U0R   \ second
      %>
   ] SLITERAL
   CR TYPE
;

: .VERSION
   CR ." IKForth 20.NEXT"
   CR ." Unlicense since 1999 by Illya Kysil"
;

: .PLATFORM
   CR ." Platform: " PLATFORM? TYPE
;

:NONAME
   .VERSION .COMPILED CR .PLATFORM CR .ENV-INFO
; STARTUP-CHAIN CHAIN.ADD

:NONAME
   CR ." Bye..." CR
; SHUTDOWN-CHAIN CHAIN.ADD

0 VALUE GLOBAL-INIT-FLAG

: STARTUP-INCLUDED
  CR ." Loading startup include" CR
  CATCH( SF @ #SF @ 2DUP TYPE CR INCLUDED )CATCH
  CASE
    0 OF
\ no errors
    ENDOF
\    2 OF
\ ignore file not found exception
\    ENDOF
    DUP
    CR .EXCEPTION
    CR REPORT-SOURCE
  ENDCASE
;

: PROCESS-ARGS
  ARGC 1 =
  IF
    STARTUP-INCLUDED
  ELSE
    BEGIN
      SHIFT-ARG
      NEXT-ARG
    WHILE
      CR ." Evaluating argument: " CR 2DUP TYPE CR
      CATCH( EVALUATE )CATCH
      CASE
        0 OF
\ no errors
        ENDOF
\        2 OF
\ ignore file not found exception
\        ENDOF
        DUP .EXCEPTION
      ENDCASE
    REPEAT
  THEN
;

:NONAME
   INIT-USER
   DECIMAL
   GLOBAL-INIT-FLAG 0=
   IF
      1 TO GLOBAL-INIT-FLAG
      STARTUP-CHAIN CHAIN.EXECUTE>
      PROCESS-ARGS
   THEN
   DECIMAL
   QUIT
; IS MAIN

REPORT-NEW-NAME !
