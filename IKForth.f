REPORT-NEW-NAME OFF

: marker create does> drop ;

: debugger s" lib\~jp\debugger.f" included ;

: load_chess s" app\~ik\chess.f" included ;

: WT S" lib\test\wordstest.f" INCLUDED ;

\ : a1 >r rp@ 1 type r> drop ;

\ USER TYPE-RESULT 1 CELLS USER-ALLOC

\ : type (s c-addr len - )
\   >R >R
\   0
\   TYPE-RESULT
\   R> R> SWAP
\   STDOUT
\   WriteConsole \ ( hOut, PChar( S ), Length( S ), Result, nil );
\ ;

: test REPORT-NEW-NAME @ >R REPORT-NEW-NAME off
       S" lib\test\ANSITest.f" ['] included catch
       R> REPORT-NEW-NAME ! throw ;

: NTHROW (S exc-id -- )
  >R 0 0 0 R> RaiseException ;

: .RS RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ DUP >HEAD DUP HERE U< IF SWAP ." 0x" H.8 SPACE H>#NAME TYPE CR
                                            ELSE 2DROP THEN 1 CELLS +LOOP ;

: .RSV RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - ." 0x" H.8 CR 1 CELLS +LOOP ;

: .RSVC RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ ." 0x" H.8 CR 1 CELLS +LOOP ;

: .RS-DAB RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ DUP >HEAD DUP DATA-AREA-BASE HERE ROT WITHIN IF SWAP ." 0x" H.8 SPACE H>#NAME TYPE CR
                                            ELSE 2DROP THEN 1 CELLS +LOOP ;

: st1 s" 123" s" 123" compare . ;
: st2 s" 231" s" 123" compare . ;
: st3 s" 123" s" 213" compare . ;
: st4 s" " s" " compare . ;
: st5 s" " s" 1" compare . ;
: st6 s" 1" s" " compare . ;
: st st1 st2 st3 st4 st5 st6 ;

\ st

requires" lib\~ik\open-interpreter.f"
requires" lib\~ik\peimage.f"

\ : a ['] ST RUSH ." test" ;

\ : a create , does> ? ;
\ 123 a b
