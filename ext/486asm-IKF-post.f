\
\  486asm-IKF-post.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

MACRO: JMP-NEXT
  MOV     EBX , [EAX]
  JMP     EBX
ENDM

\  Last word in CODE definitions
MACRO: NEXT
  LODSD
  JMP-NEXT
ENDM
