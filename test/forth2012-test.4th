\ ANS Forth tests - run all tests

\ Adjust the file paths as appropriate to your system
\ Select the appropriate test harness, either the simple tester.fr
\ or the more complex ttester.fs

CR .( Running ANS Forth and Forth 2012 test programs, version 0.13) CR

: MARKER CREATE DOES> DROP ;

S" test/forth2012-test-suite/src/prelimtest.fth" INCLUDED
\ S" test/forth2012-test-suite/src/tester.fr" INCLUDED
S" test/forth2012-test-suite/src/ttester.fs" INCLUDED

S" test/forth2012-test-suite/src/core.fr" INCLUDED
S" test/forth2012-test-suite/src/coreplustest.fth" INCLUDED
S" test/forth2012-test-suite/src/utilities.fth" INCLUDED
S" test/forth2012-test-suite/src/errorreport.fth" INCLUDED
S" test/forth2012-test-suite/src/coreexttest.fth" INCLUDED
S" test/forth2012-test-suite/src/blocktest.fth" INCLUDED
S" test/forth2012-test-suite/src/doubletest.fth" INCLUDED
S" test/forth2012-test-suite/src/exceptiontest.fth" INCLUDED
S" test/forth2012-test-suite/src/facilitytest.fth" INCLUDED
S" test/forth2012-test-suite/src/filetest.fth" INCLUDED
S" test/forth2012-test-suite/src/localstest.fth" INCLUDED
S" test/forth2012-test-suite/src/memorytest.fth" INCLUDED
S" test/forth2012-test-suite/src/toolstest.fth" INCLUDED
S" test/forth2012-test-suite/src/searchordertest.fth" INCLUDED
S" test/forth2012-test-suite/src/stringtest.fth" INCLUDED
REPORT-ERRORS

CR .( Forth tests completed ) CR CR


