\ ANS Forth tests - run all tests

\ Adjust the file paths as appropriate to your system
\ Select the appropriate test harness, either the simple tester.fr
\ or the more complex ttester.fs

CR .( Running ANS Forth and Forth 2012 test programs, version 0.13) CR

: MARKER CREATE DOES> DROP ;

DEFER TEST-ROOT (S  -- c-addr count )

: DEFAULT-TEST-ROOT
   S" test/forth2012-test-suite/src/"
;

' DEFAULT-TEST-ROOT IS TEST-ROOT

: TEST-BLOCK-ROOT
   S" build/forth2012-test-blocks/"
;

' TEST-BLOCK-ROOT IS BLOCK-ROOT

: APPEND-TEST-ROOT (S c-addr1 u1 -- c-addr2 u2 )
   TEST-ROOT >S"BUFFER   \ S: f-addr f-u r-addr r-u
   2SWAP 2OVER + SWAP    \ S: r-addr r-u f-addr r-addr' f-u
   DUP >R MOVE R> +      \ S: r-addr r-u'
;

:NONAME
   APPEND-TEST-ROOT
   2DUP CR ." INCLUDED-PATH: " TYPE CR
; IS INCLUDED-PATH

REPORT-NEW-NAME OFF

S" prelimtest.fth" INCLUDED
\ S" tester.fr" INCLUDED
S" ttester.fs" INCLUDED

S" core.fr" INCLUDED
S" coreplustest.fth" INCLUDED
S" utilities.fth" INCLUDED
S" errorreport.fth" INCLUDED
S" coreexttest.fth" INCLUDED
S" blocktest.fth" INCLUDED
S" doubletest.fth" INCLUDED
S" exceptiontest.fth" INCLUDED
S" facilitytest.fth" INCLUDED
S" filetest.fth" INCLUDED
S" localstest.fth" INCLUDED
S" memorytest.fth" INCLUDED
S" toolstest.fth" INCLUDED
S" searchordertest.fth" INCLUDED
S" stringtest.fth" INCLUDED
REPORT-ERRORS

CR .( Forth tests completed ) CR CR

.( Press any key to exit... ) KEY DROP

BYE
