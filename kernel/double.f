\
\  double.f
\
\  Copyright (C) 1999-2001 Illya Kysil
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

: 2ROT 5 ROLL 5 ROLL ;

CREATE-REPORT !
