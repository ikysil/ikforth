BASE @
16 BASE !

\ 6.1.1760 LEAVE
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- ) ( R: loop-sys -- )
\ Discard the current loop control parameters. An ambiguous condition exists if they are unavailable.
\ Continue execution immediately following the innermost syntactically enclosing DO ... LOOP or DO ... +LOOP.
CODE LEAVE
   83 B, C5 B, 2 CELLS B,   \ ADD     EBP,CELL_SIZE*2
   8B B, 75 B, 00 B,        \ MOV     ESI,[DWORD PTR EBP]
   83 B, C5 B, 1 CELLS B,   \ ADD     EBP,CELL_SIZE
   $NEXT
END-CODE COMPILE-ONLY

BASE !
