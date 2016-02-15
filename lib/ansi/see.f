\
\  see.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading SEE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @

     VARIABLE  V-PRI
0    CONSTANT  C-PRI

    2VARIABLE 2V-PRI
0 0 2CONSTANT 2C-PRI

       CREATE CREATE-PRI

USER USER-PRI 1 CELLS USER-ALLOC

VOCABULARY VOC-PRI

DEFER DEFER-PRI

0 VALUE VALUE-PRI

: WRITE-VALUE BASE @ >R DUP DECIMAL . ." , H# " H.8 R> BASE ! ;

: ?DOES> (S xt -- flag ) \ check if xt points to runtime semantics of DOES>
  DUP  CFA@ CELL- @ ['] (DOES) =
  SWAP CFA@ C@ H# E8 = AND
;

: .WORD-NAME
  \ S: xt --
  \ Print the name of the word or (noname)
  >HEAD H>#NAME ?DUP IF   TYPE   ELSE   DROP ." (noname)"   THEN
;

: CHECK-PRIMITIVE (S xt -- flag )
  DUP >R
  CFA@
  CASE
    OVER >BODY OF
      ." Low-level primitive" TRUE
    ENDOF
    [ ' CREATE-PRI CFA@ ] LITERAL OF
      ." CREATE " TRUE
    ENDOF
    [ ' V-PRI CFA@ ] LITERAL OF
      ." VARIABLE( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' C-PRI CFA@ ] LITERAL OF
      ." CONSTANT( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' 2V-PRI CFA@ ] LITERAL OF
      ." 2VARIABLE( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' 2C-PRI CFA@ ] LITERAL OF
      ." 2CONSTANT( " R@ EXECUTE D. ." )" TRUE
    ENDOF
    [ ' USER-PRI CFA@ ] LITERAL OF
      ." USER( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' VOC-PRI CFA@ ] LITERAL OF
      ." VOCABULARY( " R@ VOC>WL .WORDLIST-NAME ." )" TRUE
    ENDOF
    [ ' VALUE-PRI CFA@ ] LITERAL OF
      ." VALUE( " R@ EXECUTE WRITE-VALUE ." )" TRUE
    ENDOF
    [ ' DEFER-PRI CFA@ ] LITERAL OF
      ." DEFER " 
      R@ >HEAD H>#NAME TYPE SPACE
      ." XT=H# " R@ H.8 SPACE
      R@ >HEAD WORD-ATTR
      R@ >BODY @ NIP
      CR DUP RECURSE
    ENDOF
    [ ' : CFA@ ] LITERAL OF
      R@ .WORD-NAME SPACE
      ." XT=H# " R@ H.8 SPACE
      R@ >HEAD WORD-ATTR
      CR FALSE
    ENDOF
    R@ ?DOES>
    IF
      R@ .WORD-NAME SPACE
      ." XT=H# " R@ H.8 SPACE
      R@ >HEAD WORD-ATTR
      ." DOES> " CR
      FALSE
    ELSE
      ." Unknown executor XT=H# " DUP H.8 TRUE
    THEN
    SWAP
  ENDCASE R-DROP
;

: CHECK-EXIT (S body-addr -- flag )
  @
  CASE
    ['] (;)     OF ." ;"     TRUE ENDOF
    ['] (;CODE) OF ." ;CODE" TRUE ENDOF
    FALSE SWAP
  ENDCASE ;

: WRITE-NEXT-ADDR (S body-addr -- body-addr1 )
  ."  --> H# " DUP @ H.8 CELL+ ;

: WRITE-LIT (S body-addr -- body-addr1 )
  BASE @ >R
  ." LITERAL = " DUP @ WRITE-VALUE CELL+
  R> BASE ! ;

: WRITE-2LIT (S body-addr -- body-addr1 )
  BASE @ >R
  ." 2LITERAL = " DUP 2@ SWAP 2DUP DECIMAL D. ." , H# " HEX UD. 2 CELLS+
  R> BASE ! ;

: WRITE-STRING (S body-addr addr count -- body-addr1 )
  [CHAR] " EMIT SPACE TYPE [CHAR] " EMIT ;

: WRITE-S" (S body-addr -- body-addr1 )
  ." S" DUP @ SWAP CELL+ SWAP 2DUP + -ROT WRITE-STRING ;

: WRITE-C" (S body-addr -- body-addr1 )
  ." C" COUNT 2DUP + -ROT WRITE-STRING ;

: WRITE-(TYPE) (S body-addr -- body-addr1 )
  ." (TYPE)" COUNT 2DUP + -ROT WRITE-STRING ;

: WRITE-NAME (S body-addr -- body-addr1 )
  DUP CELL+ SWAP @
  CASE
    [']       LIT OF WRITE-LIT  ENDOF
    [']      2LIT OF WRITE-2LIT ENDOF
    [']   ?BRANCH OF ." ?BRANCH" WRITE-NEXT-ADDR ENDOF
    [']    BRANCH OF ." BRANCH " WRITE-NEXT-ADDR ENDOF
    [']      (DO) OF ." DO     " WRITE-NEXT-ADDR ENDOF
    [']     (?DO) OF ." ?DO    " WRITE-NEXT-ADDR ENDOF
    [']    (LOOP) OF ." LOOP   " WRITE-NEXT-ADDR ENDOF
    [']   (+LOOP) OF ." +LOOP  " WRITE-NEXT-ADDR ENDOF
    [']   (ENDOF) OF ." ENDOF  " WRITE-NEXT-ADDR ENDOF
    [']      (OF) OF ." OF     " WRITE-NEXT-ADDR ENDOF
    [']     (<OF) OF ." <OF    " WRITE-NEXT-ADDR ENDOF
    [']     (>OF) OF ." >OF    " WRITE-NEXT-ADDR ENDOF
    [']    (<OF<) OF ." <OF<   " WRITE-NEXT-ADDR ENDOF
    ['] (ENDCASE) OF ." ENDCASE" ENDOF
    [']      (C") OF WRITE-C" ENDOF
    [']      (S") OF WRITE-S" ENDOF
    [']    (DOES) OF ." DOES>" 5 + ENDOF
    [']    (TYPE) OF WRITE-(TYPE)  ENDOF
    [']      ([:) OF ." [: XT=H# " HEAD> DUP H.8 >BODY ENDOF
    [']      (;]) OF ." ;]" ENDOF
    DUP .WORD-NAME
  ENDCASE
;

: (XT>BODY) (S xt -- addr )
  (G convert xt to threaded code body address with special handling for CREATE ... DOES> )
  DUP ?DOES> IF CFA@ 5 + ELSE >BODY THEN
;

: (SEE) (S xt -- )
  DUP
  CHECK-PRIMITIVE IF DROP EXIT THEN
  (XT>BODY)
  0 >R
  BEGIN
    DUP
    DUP   H.8 SPACE SPACE
    DUP @ H.8 SPACE SPACE
    CHECK-EXIT INVERT
  WHILE
    WRITE-NAME SPACE CR
    R> 1+ DUP >R 20 MOD 0= IF ." Press any key to continue..." KEY DROP CR THEN
  REPEAT DROP R-DROP
;

: SEE (S 'name' -- )
  BL WORD DUP COUNT 0= IF EXC-EMPTY-NAME THROW THEN DROP
          DUP  FIND 0= IF EXC-UNDEFINED  THROW THEN NIP
  (SEE)
;

BASE !

REPORT-NEW-NAME !
