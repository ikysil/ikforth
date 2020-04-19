PURPOSE: QUADRUPLE definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS


S" ADDRESS-UNITS-BITS" ENVIRONMENT?  [IF]
CELLS 4 *  CONSTANT  QUADRUPLE-BITS
[THEN]


: Q2* (S q1 -- q2 )
   \G Multiply quadruple-cell value by 2 - shift left
   0 T2* 3>R
   0 T2* 0. 3R>
   T+ DROP
;


: Q2/ (S q1 -- q2 )
   \G Divide quadruple-cell value by 2 - shift right with sign extension
   0 ROT ROT T2/ 2>R >R
   0 T2/ DROP R> +
   2R>
;


: Q+C (S q1 q2 -- q3 n )
   \G Add quadruple-cell values q1 and q2 producing sum q3 and carry n.
   2>R 2SWAP 2>R
   2>R 0 2R> 0 T+
   0.
   2R> 0 T+
   2R> 0 T+
;


: Q+ (S q1 q2 -- q3 )
   \G Add quadruple-cell values q1 and q2 producing sum q3.
   Q+C DROP
;


: D>Q (S d -- q )
   \G Sign-extend double-cell value d to quadruple-cell value q.
   S>D S>D
;


: QNEGATE (S q1 -- q2 )
   \G Negate quadruple-cell value q1 producing q2.
   DINVERT 2SWAP
   DINVERT 2SWAP
   1. D>Q
   Q+
;


: UD* (S ud1 ud2 -- udlow udhigh )
   \G Perform exact multiplication of unsigned double values.
   2OVER ROT >R 2>R  \ S: ud1 udl2           R: ud1 udh2
   UT* 0             \ S: utl1 utm1 uth1 0   R: ud1 udh2
   2R> R> UT*        \ S: utl1 utm1 uth1 0 utl2 utm2 uth2
   T+
;


: QSWAP (S q1 q2 -- q2 q1 )
   2>R      \ S: q10 q11 q12 q13 q20 q21     R: q22 q23
   2SWAP    \ S: q10 q11 q20 q21 q12 q13     R: q22 q23
   2ROT     \ S: q20 q21 q12 q13 q10 q11     R: q22 q23
   2R>      \ S: q20 q21 q12 q13 q10 q11 q22 q23
   2SWAP    \ S: q20 q21 q12 q13 q22 q23 q10 q11
   2ROT     \ S: q20 q21 q22 q23 q10 q11 q12 q13
;


REPORT-NEW-NAME !
