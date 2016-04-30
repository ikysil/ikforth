BASE @
16 BASE !

\ 6.1.1730 J
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- n|u ) ( R: loop-sys1 loop-sys2 -- loop-sys1 loop-sys2 )
\ n|u is a copy of the next-outer loop index.
\ An ambiguous condition exists if the loop control parameters of the next-outer loop, loop-sys1, are unavailable.
CODE J
   8B B, 45 B, 3 CELLS B,   \ MOV     EAX,[DWORD PTR EBP + 3 * CELL_SIZE]
   50 B,                    \ PUSH    EAX
   $NEXT
END-CODE COMPILE-ONLY

BASE !
