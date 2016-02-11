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

: TEST-WORDS S" lib\test\wordstest.f" INCLUDED ;

: TEST-ANSI94 REPORT-NEW-NAME @ >R REPORT-NEW-NAME off
       S" lib\test\ANSITest.f" ['] included catch
       R> REPORT-NEW-NAME ! throw ;

: TEST-STRING requires" test/string-test.4th" ;

CODE A
    POP EAX
    INC EAX
    PUSH EAX
    NEXT
END-CODE
