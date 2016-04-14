REPORT-NEW-NAME OFF

: debugger s" lib/~jp/debugger.f" included ;

: load_chess s" app/~ik/chess.4th" included ;

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

[DEFINED] RaiseException [IF]
: NTHROW (S exc-id -- )
  >R 0 0 0 R> RaiseException ;
[THEN]

: .RS RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - DUP HERE U< IF @ DUP >HEAD SWAP ." 0x" H.8 SPACE H>#NAME TYPE CR
                                            ELSE DROP THEN 1 CELLS +LOOP ;

: .RSV RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - ." 0x" H.8 CR 1 CELLS +LOOP ;

: .RSVC RP@ DUP RDEPTH CELLS + SWAP
  ?DO I @ 1 CELLS - @ ." 0x" H.8 CR 1 CELLS +LOOP ;

: .RS-DAB RP@ DUP RDEPTH CELLS+ SWAP
   ?DO I
      DUP ." @ 0x" H.8 SPACE
      @ CELL-
      DUP DATA-AREA-BASE HERE ROT WITHIN
      IF
         @ DUP >HEAD SWAP ." 0x" H.8 SPACE H>#NAME TYPE CR
      ELSE
         ." 0x" H.8 CR
      THEN
      1 CELLS
   +LOOP
;

: t.rs2 .rs-dab ;
: t.rs1 123 >r t.rs2 r> drop ;

: st1 s" 123" s" 123" compare . ;
: st2 s" 231" s" 123" compare . ;
: st3 s" 123" s" 213" compare . ;
: st4 s" " s" " compare . ;
: st5 s" " s" 1" compare . ;
: st6 s" 1" s" " compare . ;
: st st1 st2 st3 st4 st5 st6 ;

\ st

requires" lib/~ik/open-interpreter.4th"
requires" lib/~ik/peimage.4th"

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

: test-ekey begin ekey h.8 cr cr again ;

\ test-ekey
