\ ------------------------------------------------------------------------------
\  locals-test.4th
\
\  Copyright (C) 2016 Illya Kysil
\ ------------------------------------------------------------------------------

CR .( Loading LOCALS-TEST definitions )

REQUIRES" lib/~ik/locals.4th"

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS

ALSO LOCALS-HIDDEN

CR
H# ABCD >L
LP@ 8 DUMP

CR
H# 1234 >L
LP@ 8 DUMP

CR
L> H.8 CR
L> H.8 CR
LP@ 8 DUMP

H# ABCD >L
: TEST1 L0@ H# ABCD = IF ." OK" ELSE ." NOT OK" THEN CR ;

.( TEST1 )
TEST1

H# 1234 >L
: TEST2 L0@ H# 1234 = IF ." OK" ELSE ." NOT OK" THEN CR ;

.( TEST2 )
TEST2

: TEST3 H# ABCD >L H# 1234 >L
  L0@ H# 1234 = IF ." OK" ELSE ." NOT OK" THEN CR
  L1@ H# ABCD = IF ." OK" ELSE ." NOT OK" THEN CR
;

.( TEST3 )
TEST3

LP0 LP!

: TEST4
  4 LOCALS-ALLOC
  LDEPTH DUP . 4 = IF ."  OK" ELSE ."  NOT OK" THEN CR
  LOCALS-DEALLOC
;

.( TEST4 )
TEST4

LDEPTH . CR

: TEST5
  4 LOCALS-ALLOC
  EXCP0 H.8 CR
  EXCP@ EXCP0 OVER - CELL+ DUMP
  -1 THROW
;

.( TEST5 )
TEST4
LP@ 8 DUMP CR
' TEST5 CATCH . CR
LP@ 8 DUMP CR
TEST4
LP@ 8 DUMP CR

.( TEST6 )
: TEST6-INNER
  EXCP@ EXCP0 OVER - DUMP
  2 LOCALS-ALLOC
  LDEPTH . CR
  CATCH(
    3 LOCALS-ALLOC
    EXCP@ EXCP0 OVER - DUMP
    -1 THROW
    LOCALS-DEALLOC
  )CATCH
  . CR
  LDEPTH . CR
  LOCALS-DEALLOC
;
: TEST6
  1 LOCALS-ALLOC
  LDEPTH . CR
  TEST6-INNER
  LDEPTH . CR
  LOCALS-DEALLOC
;
.( Before TEST6 ) LDEPTH . CR
TEST6
.( After TEST6  ) LDEPTH . CR


REPORT-NEW-NAME !
