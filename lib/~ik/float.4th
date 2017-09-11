\
\  float.4th
\
\  Copyright (C) 2017 Illya Kysil
\

CR .( Loading FLOAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DEFER (F IMMEDIATE ' ( IS (F
   \G Floating-stack comment

DEFER ?INF (S -- flag ) (F r -- )
   \G Flag true only if r represents special value infinity

DEFER ?NAN (S -- flag ) (F r -- )
   \G Flag true only if r represents special value Not a Number

REQUIRES" lib/~ik/float-ieee-binary.4th"
REQUIRES" lib/~ik/float-output.4th"

REPORT-NEW-NAME !
