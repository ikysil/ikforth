\ Floating point tests - run all tests

\ Adjust the file paths as appropriate to your system
\ Select the appropriate test harness, either the simple tester.fr
\ or the more complex ttester.fs

cr .( Running FP Tests) cr

requires" lib/~ik/float.4th"
requires" lib/~ik/fpout.4th"

DEFER TEST-ROOT (S  -- c-addr count )

: DEFAULT-TEST-ROOT
   S" test/forth2012-test-suite/src/fp/"
;

' DEFAULT-TEST-ROOT IS TEST-ROOT

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

s" [undefined]" pad c! pad char+ pad c@ move
pad find nip 0=
[if]
   : [undefined]  ( "name" -- flag )
      bl word find nip 0=
   ; immediate
[then]

s" ttester.fs"         included
s" ak-fp-test.fth"     included
\ s" fatan2-test.fs"     included
\ s" ieee-arith-test.fs" included
\ s" ieee-fprox-test.fs" included
s" fpzero-test.4th"    included
\ s" fpio-test.4th"      included
s" to-float-test.4th"  included
123 SET-PRECISION
s" paranoia.4th"       included

cr cr
.( FP tests finished) cr cr

.( Press any key to exit... ) KEY DROP

BYE
