BASE @
16 BASE !

\ 6.1.1680 I
\ Interpretation: Interpretation semantics for this word are undefined.
\ Execution: ( -- n|u ) ( R:  loop-sys -- loop-sys )
\ n|u is a copy of the current (innermost) loop index.
\ An ambiguous condition exists if the loop control parameters are unavailable.
CODE I
   8B B, 45 B, 00 B,        \ MOV     EAX,[DWORD PTR EBP]
   50 B,                    \ PUSH    EAX
   $NEXT
END-CODE COMPILE-ONLY

BASE !
