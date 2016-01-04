\ include" win\conio.f"

: WT S" lib\test\wordstest.f" INCLUDED ;

\ : a1 >r rp@ 1 type r> drop ;

USER TYPE-RESULT 1 CELLS USER-ALLOC

\ : type (s c-addr len - )
\   >R >R
\   0
\   TYPE-RESULT
\   R> R> SWAP
\   STDOUT
\   WriteConsole \ ( hOut, PChar( S ), Length( S ), Result, nil );
\ ;

: test create-report @ >R create-report off
       S" lib\test\ANSITest.f" ['] included catch
       R> create-report ! throw ;

\ requires" lib\win32\wincon.f"

\ requires" exception.f"
s" test" exception constant test-exception

: NTHROW (S exc-id -- )
  >R 0 0 0 R> RaiseException ;

:NONAME
 BASE @ >R DECIMAL DEPTH . ." [" R@ 2 .R ." ]> " R> BASE ! 
; IS .INPUT-PROMPT

: .RS RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ DUP >HEAD DUP HERE U< IF SWAP ." 0x" H. SPACE H>#NAME TYPE CR
                                            ELSE 2DROP THEN 1 CELLS +LOOP ;

: .RSV RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - ." 0x" H. CR 1 CELLS +LOOP ;

: .RSVC RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ ." 0x" H. CR 1 CELLS +LOOP ;

: .RS-DAB RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ DUP >HEAD DUP DATA-AREA-BASE HERE ROT WITHIN IF SWAP ." 0x" H. SPACE H>#NAME TYPE CR
                                            ELSE 2DROP THEN 1 CELLS +LOOP ;
