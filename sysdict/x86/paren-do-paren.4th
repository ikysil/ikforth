BASE @
16 BASE !

\ (DO)
\ Run-time: ( n1|u1 n2|u2 -- ) ( R: -- loop-sys )
\ Set up loop control parameters with index n2|u2 and limit n1|u1.
\ An ambiguous condition exists if n1|u1 and n2|u2 are not both the same type.
\ Anything already on the return stack becomes unavailable until the loop-control parameters are discarded.
\ loop-sys: leave-addr limit index
CODE (DO)
   AD B,                    \ LODSD
   83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
   89 B, 45 B, 00 B,        \ MOV     [DWORD PTR EBP],EAX
   58 B,                    \ POP     EAX
   5B B,                    \ POP     EBX
   83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
   89 B, 5D B, 00 B,        \ MOV     [DWORD PTR EBP],EBX
   83 B, ED B, 1 CELLS B,   \ SUB     EBP,CELL_SIZE
   89 B, 45 B, 00 B,        \ MOV     [DWORD PTR EBP],EAX
   $NEXT
END-CODE

BASE !
