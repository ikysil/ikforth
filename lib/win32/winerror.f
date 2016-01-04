\
\  winerror.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading WINERROR definitions )

CREATE-REPORT @
CREATE-REPORT OFF

1024 CONSTANT Win32ErrorBufferSize
USER Win32ErrorBuffer Win32ErrorBufferSize USER-ALLOC

VARIABLE REPORT-WIN32-EXCEPTION-CONTEXT
0 REPORT-WIN32-EXCEPTION-CONTEXT !

: .WIN32-EXCEPTION-CONTEXT (S -- )
  WIN32-EXCEPTION-CONTEXT
  ." ORDINARY REGISTERS" CR
  DUP $ B0 + @ ."  EAX=" H.8
  DUP $ A4 + @ ."  EBX=" H.8
  DUP $ AC + @ ."  ECX=" H.8
  CR
  DUP $ A8 + @ ."  EDX=" H.8
  DUP $ 9C + @ ."  EDI=" H.8
  DUP $ A0 + @ ."  ESI=" H.8
  CR
  ." CONTROL REGISTERS" CR
  DUP $ C4 + @ ."  ESP=" H.8
  DUP $ B4 + @ ."  EBP=" H.8
  DUP $ B8 + @ ."  EIP=" H.8
  CR
  DUP $ C0 + @ ."  EFL=" H.8
  CR
  ." SEGMENT REGISTERS" CR
  DUP $ BC + @ ."  CS=" H.8
  DUP $ 98 + @ ."  DS=" H.8
  DUP $ 94 + @ ."  ES=" H.8
  CR
  DUP $ C8 + @ ."  SS=" H.8
  DUP $ 90 + @ ."  FS=" H.8
  DUP $ 8C + @ ."  GS=" H.8
  DROP
; 

: .WIN32-EXCEPTION (S exc-id -- )
  DUP
  2>R 0
  Win32ErrorBufferSize
  Win32ErrorBuffer
  0 
  R> 0 
  $ 1000 \ FORMAT_MESSAGE_FROM_SYSTEM
  $ FF   \ FORMAT_MESSAGE_MAX_WIDTH_MASK
  OR
  FormatMessage Win32ErrorBuffer SWAP
  ." Win32 exception (0x" R> H.8 ." )"
  ?DUP IF
         ." : " TYPE
       ELSE
         DROP
       THEN
  REPORT-WIN32-EXCEPTION-CONTEXT @ IF CR .WIN32-EXCEPTION-CONTEXT THEN
;

:NONAME (S exc-id -- )
  $ FFFF0000 2DUP \ exc-id $FFFF0000 exc-id $FFFF0000
  AND = IF \ IKForth domain exceptions
          [ DEFER@ .EXCEPTION ] LITERAL EXECUTE
        ELSE
          .WIN32-EXCEPTION
        THEN
; IS .EXCEPTION

CREATE-REPORT !
