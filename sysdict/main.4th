PURPOSE: MAIN definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REQUIRES" sysdict/hostenv.4th"
REQUIRES" sysdict/sformat.4th"
REQUIRES" sysdict/quit.4th"

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

: VERSION-STRING?
   (S -- c-addr count )
   (G Seach host environment for version string variable )
   (G and return value as counted string )
   S" BUILD_TAG"      ENVP? IF   EXIT   THEN
   S" VERSION_STRING" ENVP? IF   EXIT   THEN
   S" VERSION-STRING" ENVP? IF   EXIT   THEN
   S" HEAD"
;

: VERSION-STRING
   (S -- c-addr count )
   (G Return version string )
   [
      VERSION-STRING?
      <%
         %S" IKForth "
         %S
      %>
   ] SLITERAL
;

: .VERSION
   CR VERSION-STRING TYPE
   CR ." Unlicense since 1999 by Illya Kysil"
;

: .PLATFORM
   CR ." Platform: " PLATFORM? TYPE
;

: INIT-MAIN
   .VERSION .COMPILED CR .PLATFORM CR .ENV-INFO
;
' INIT-MAIN STARTUP-CHAIN CHAIN.ADD

: DONE-MAIN
   CR ." Bye..." CR
;
' DONE-MAIN SHUTDOWN-CHAIN CHAIN.ADD

0 VALUE GLOBAL-INIT-FLAG

: STARTUP-INCLUDED
   CR ." Loading startup include" CR
   CATCH( SF @ #SF @ 2DUP TYPE CR INCLUDED )CATCH
   CASE
      0 OF
      \ no errors
      ENDOF
\     2 OF
\ ignore file not found exception
\     ENDOF
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
