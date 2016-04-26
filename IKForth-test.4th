: TEST-LOCALS requires" lib/~ik/locals-test.4th" ;

: TEST-DUMP
  CR
  ['] DUMP >HEAD
  DUP 64 DUMP
  0 DUMP/LINE !
  DUP 64 DUMP
  32 DUMP/LINE !
  DUP 64 DUMP
  DROP
;

: TEST-STRING requires" test/string-test.4th" ;

: TEST-HOSTENV requires" test/hostenv-test.4th" ;

CODE A
    POP EAX
    INC EAX
    PUSH EAX
    NEXT
END-CODE

\ : a ['] ST RUSH ." test" ;

\ : a create , does> ? ;
\ 123 a b

: NOP : POSTPONE ; R> >R ;

: c3
   [ CR H.S ] [: [ CR H.S ] ;] DROP
;

: a 2 LOCALS-FRAME l0! l1! cr .s cr ." a " l1@ . l0@ . LOCALS-UNFRAME ;

: b 3 LOCALS-FRAME l0! l1! l2! 1 l1@ 10 + a cr ." b " l2@ . l1@ . l0@ . LOCALS-UNFRAME ;

1 2 3 b

: c {: local0 local1 :}
   local0 H.8 local1 H.8
   {: local2 local3 :}
;

: c1 {: local0 local1 :}
   123 TO LOCAL0
;

: c2 {: local0 local1 :}
   123 +TO LOCAL0
;

: c3 {: local0 :}
   [: {: local2 :} [: {: local3 :} ;] DROP ;] DROP
   123 +TO LOCAL0
;

\ CR CR
\ see c

\ CR CR
\ see c1

\ CR CR
\ see c2

\ CR CR
\ see c3

CR

KEY? .

CR 1 MAKE-BLOCK-FILE-NAME CR DUMP
CR 2 MAKE-BLOCK-FILE-NAME CR DUMP

HEX 8000000000000000. 7FFFFFFFFFFFFFFF. CR H.S 2OVER 2OVER CR H.S CR D- D. 2OVER 2OVER D< . DU< .

: SW LOCAL B LOCAL C BEGIN FALSE LOCAL D D WHILE REPEAT B C ;

1 2
CR .S
SW
CR .S

CR

SEE SW

DECIMAL

: test-ekey
   begin
      CR ." -------------------------------------------" CR
      ekey
      dup ekey>char swap 'q' = and if bye then
      cr h.8
   again
;

\ test-ekey

: t2 postpone throw ; immediate
: t3 t2 ;
: t4 exit ;

cr
see t2
cr
see t3
cr
see t4

DEPTH NDROP

CR .( 2PICK )
cr .s
1. 2. 3. 2 2pick
cr .s
1. d=
cr .

DEPTH NDROP

CR .( 2ROLL )
cr .s
1. 2. 3. 1 2ROLL
cr .s
CR
2. d= . 3. d= . 1. d= .

CR

S" test/literal-ext-test.4th" INCLUDED
