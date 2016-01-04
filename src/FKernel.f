\
\  FKernel.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

HERE

REPORT-NEW-NAME-DUPLICATE @
REPORT-NEW-NAME @

TRUE REPORT-NEW-NAME-DUPLICATE !
FALSE REPORT-NEW-NAME !

S" src\words.f" INCLUDED

' READ-FILE-LINE IS READ-LINE

: .VERSION
  ." IKForth v1.0" CR
  ." Copyright (C) 1999-2003 Illya Kysil" CR
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

: .PLATFORM
  ." Platform: " PLATFORM? TYPE
;

:NONAME .VERSION CR .PLATFORM CR CR .ENV-INFO ;
STARTUP-CHAIN CHAIN.ADD

:NONAME ." Bye..." CR ;
SHUTDOWN-CHAIN CHAIN.ADD

0 VALUE GLOBAL-INIT-FLAG 

:NONAME
  INIT-USER
  DECIMAL
  GLOBAL-INIT-FLAG 0=
  IF
    1 TO GLOBAL-INIT-FLAG
    STARTUP-CHAIN CHAIN.EXECUTE>
    GetCommandLine DUP lstrlen CMD-LINE 2!
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
REPORT-NEW-NAME-DUPLICATE !

DECIMAL

H# 800000 DATA-AREA-SIZE !

CR .( Writing IKForth.img )
S" IKForth.img" W/O CREATE-FILE THROW
DATA-AREA-BASE HERE OVER - 256 ( Page size ) TUCK / 1+ * 2 PICK WRITE-FILE THROW
CLOSE-FILE THROW

.( OK ) CR

.( Total data area size  ) DATA-AREA-SIZE @       16 U.R .(  bytes ) CR
.( Unused data area size ) UNUSED                 16 U.R .(  bytes ) CR
.( Compiled              ) HERE SWAP -            16 U.R .(  bytes ) CR
.( New vocabulary size   ) HERE DATA-AREA-BASE -  16 U.R .(  bytes ) CR

BYE
