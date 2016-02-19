\
\  FKernel.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

HERE

REPORT-NEW-NAME-DUPLICATE @
REPORT-NEW-NAME @

TRUE REPORT-NEW-NAME-DUPLICATE !
FALSE REPORT-NEW-NAME !

S" src/kernel.0/_kernel0.f" INCLUDED

\ ' _READ-LINE     IS READ-LINE
\ ' _INCLUDED      IS INCLUDED
\ ' _INCLUDE-FILE  IS INCLUDE-FILE

REPORT-NEW-NAME !
REPORT-NEW-NAME-DUPLICATE !

DECIMAL

0x00800000 DATA-AREA-SIZE !

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
