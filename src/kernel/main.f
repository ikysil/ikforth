\
\  main.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading MAIN definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: .COMPILED
  ." Compiled: "
  [
    TIME&DATE DECIMAL
    <# 5 ROLL S>D # # 2DROP CHAR : HOLD
       4 ROLL S>D # # 2DROP CHAR : HOLD
       3 ROLL S>D #S  2DROP
       BL HOLD CHAR , HOLD
       S>D #S 2DROP CHAR / HOLD MONTH>STR S"HOLD CHAR / HOLD S>D #S #>
  ] SLITERAL TYPE
;

: .VERSION
  ." IKForth v1.0" CR
  ." Copyright (C) 1999-2016 Illya Kysil" CR
;

: .PLATFORM
  ." Platform: " PLATFORM? TYPE
;

:NONAME
  .VERSION .COMPILED CR .PLATFORM CR CR .ENV-INFO
; STARTUP-CHAIN CHAIN.ADD

:NONAME
  ." Bye..." CR
; SHUTDOWN-CHAIN CHAIN.ADD

0 VALUE GLOBAL-INIT-FLAG 

:NONAME
  INIT-USER
  DECIMAL
  GLOBAL-INIT-FLAG 0=
  IF
    1 TO GLOBAL-INIT-FLAG
    STARTUP-CHAIN CHAIN.EXECUTE>
    CR ." Loading startup include" CR
    CATCH( SF @ #SF @ INCLUDED )CATCH
    CASE
      0 OF
\ no errors
      ENDOF
\      2 OF
\ ignore file not found exception
\      ENDOF
      DUP .EXCEPTION 
    ENDCASE
  THEN
  DECIMAL
  QUIT
; IS MAIN

REPORT-NEW-NAME !
