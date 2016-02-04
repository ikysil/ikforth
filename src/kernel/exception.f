\
\  exception.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading EXCEPTION definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DEFER (.EXCEPTION) (S exc-id -- )

:NONAME
  ." Exception H# " H.8
; IS (.EXCEPTION)

: .THROW-WORD
  THROW-WORD @ ?DUP
  IF CR 9 EMIT ." at '"
    H>#NAME DUP 0=
    IF
      2DROP S" (noname)"
    THEN
    TYPE
    ." '" 0 THROW-WORD !
  THEN
;

: .THROW-ADDRESS
  THROW-ADDRESS @ ?DUP IF ."  (H# " H.8 ." )" 0 THROW-ADDRESS ! THEN
;

: (.EXC-ADDR)
  .THROW-WORD .THROW-ADDRESS
;

DEFER .EXCEPTION (S exc-id -- )

:NONAME (S exc-id -- )
  (.EXCEPTION) (.EXC-ADDR)
; IS .EXCEPTION

: (DO-EXCEPTION)  (S exc-id-test exc-id c-addr count -- exc-id-test c-addr count flag )
  2>R OVER = 2R> ROT
;

: (."EXCEPTION") (S exc-id-test c-addr count -- )
  ." IKForth exception (H# "
  2 PICK H.8 ." ): "
;

: (EXCEPTION) (S c-addr count exc-id -- )
  :NONAME
  >R
  POSTPONE LITERAL
  POSTPONE SLITERAL
  POSTPONE (DO-EXCEPTION)
  POSTPONE IF
  POSTPONE (."EXCEPTION")
  POSTPONE TYPE
  POSTPONE DROP
  POSTPONE ELSE
  POSTPONE 2DROP
  ACTION-OF (.EXCEPTION)
  POSTPONE LITERAL
  POSTPONE EXECUTE
  POSTPONE THEN
  POSTPONE ;
  R>
  IS (.EXCEPTION) ;

: (DO-EXCEPTION-XT) (S exc-id-test exc-id xt -- exc-id-test xt flag )
  >R OVER = R> SWAP ;

: (EXCEPTION-XT) (S xt exc-id -- )
  :NONAME
  >R
  POSTPONE LITERAL
  POSTPONE LITERAL
  POSTPONE (DO-EXCEPTION-XT)
  POSTPONE IF
  POSTPONE EXECUTE
  POSTPONE DROP
  POSTPONE ELSE
  POSTPONE DROP
  ACTION-OF (.EXCEPTION)
  POSTPONE LITERAL
  POSTPONE EXECUTE
  POSTPONE THEN
  POSTPONE ;
  R>
  IS (.EXCEPTION) ;

VARIABLE FREE-EXCEPTION-ID
-256 FREE-EXCEPTION-ID !

: (GET-EXC-ID) (S -- exc-id )
  -1 FREE-EXCEPTION-ID DUP @ >R +! R> ;

: EXCEPTION (S c-addr count -- exc-id )
  (GET-EXC-ID) DUP >R (EXCEPTION) R> ;

: EXCEPTION-XT (S xt -- exc-id )
  (GET-EXC-ID) DUP >R (EXCEPTION-XT) R> ;

REPORT-NEW-NAME !
