\
\  winexception.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading WINEXCEPTION definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

1024 CONSTANT Win32ErrorBufferSize
USER Win32ErrorBuffer Win32ErrorBufferSize USER-ALLOC

VARIABLE REPORT-WIN32-EXCEPTION-CONTEXT
TRUE REPORT-WIN32-EXCEPTION-CONTEXT !

: .WIN32-EXCEPTION-CONTEXT (S -- )
  WIN32-EXCEPTION-CONTEXT
  ." ORDINARY REGISTERS" CR
  DUP H# B0 + @ ."  EAX=" H.8
  DUP H# A4 + @ ."  EBX=" H.8
  DUP H# AC + @ ."  ECX=" H.8
  CR
  DUP H# A8 + @ ."  EDX=" H.8
  DUP H# 9C + @ ."  EDI=" H.8
  DUP H# A0 + @ ."  ESI=" H.8
  CR
  ." CONTROL REGISTERS" CR
  DUP H# C4 + @ ."  ESP=" H.8
  DUP H# B4 + @ ."  EBP=" H.8
  DUP H# B8 + @ ."  EIP=" H.8
  CR
  DUP H# C0 + @ ."  EFL=" H.8
  CR
  ." SEGMENT REGISTERS" CR
  DUP H# BC + @ ."  CS=" H.8
  DUP H# 98 + @ ."  DS=" H.8
  DUP H# 94 + @ ."  ES=" H.8
  CR
  DUP H# C8 + @ ."  SS=" H.8
  DUP H# 90 + @ ."  FS=" H.8
  DUP H# 8C + @ ."  GS=" H.8
  DROP
; 

: .WIN32-EXCEPTION (S exc-id -- )
  >R 0
  Win32ErrorBufferSize
  Win32ErrorBuffer
  0 
  R@ 0 
  H# 1000 \ FORMAT_MESSAGE_FROM_SYSTEM
  H# FF   \ FORMAT_MESSAGE_MAX_WIDTH_MASK
  OR
  FormatMessage Win32ErrorBuffer SWAP
  ." Win32 exception (H# " R@ H.8 ." )"
  ?DUP IF
         ." : " TYPE
       ELSE
         DROP
       THEN
  REPORT-WIN32-EXCEPTION-CONTEXT @
  R> H# C0000000 SWAP OVER AND = AND
  IF CR .WIN32-EXCEPTION-CONTEXT THEN
;

:NONAME (S exc-id -- )
  DUP H# 10000000 AND 0=
  IF
    .WIN32-EXCEPTION
  ELSE
    DEFER@-EXECUTE .EXCEPTION
  THEN
; IS .EXCEPTION

\ Map Win32 SEH exceptions to Forth exceptions
:NONAME (S win32-exc-id -- exc-id )
  CASE
    H# C0000005 OF
      EXC-INVALID-ADDRESS
    ENDOF
    H# C0000094 OF
      EXC-DIVISION-BY-ZERO
    ENDOF
    DUP
  ENDCASE
; IS SEH-HANDLER

REPORT-NEW-NAME !
