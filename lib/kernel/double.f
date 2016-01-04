\
\  double.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading DOUBLE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

: 2CONSTANT CREATE , , DOES> 2@ ;

: 2VARIABLE CREATE 0. , , DOES> ;

: D0< NIP 0< ;

: D< D- D0< ;

: D0= OR 0= ;

: D= D- D0= ;

: DU< D- D0< ;

: D>S DROP ;

: TNEGATE   (S t1lo t1mid t1hi -- t2lo t2mid t2hi )
  invert >r
  invert >r
  invert 0 -1. d+ s>d r> 0 d+
  r> + ;

: UT*   (S ulo uhi u -- utlo utmid uthi )
  swap >r dup >r
  um* 0 r> r> um* d+ ;

: MT*   (S lo hi n -- tlo tmid thi )
  dup 0<
  IF
    abs over 0<
    IF
      >r dabs r> ut*
    ELSE
      ut* tnegate
    THEN
  ELSE
    over 0<
    IF
      >r dabs r> ut* tnegate
    ELSE
      ut*
    THEN
  THEN ;

: UT/ (S utlo utmid uthi n -- d1 )
  dup >r um/mod -rot r> um/mod
  nip swap ;

: M*/ (S d1 n1 +n2 -- d2 )
  >R MT* DUP 0<
  IF
    TNEGATE R> UT/ DNEGATE
  ELSE
    R> UT/
  THEN
;

CREATE-REPORT !
