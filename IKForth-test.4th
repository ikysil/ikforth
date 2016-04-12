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
