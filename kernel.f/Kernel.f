\
\  Kernel.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\
\  IKForth kernel
\

CR .( Loading IKForth KERNEL definitions )

BASE @

WORDLIST CONSTANT TARGET-WL

TARGET-WL (VOCABULARY) TARGET

: PATCH (S executor "name" -- )
  ' ! ;

: GET-BASE-ADDR (S current-base-addr -- base-addr )
  [HEX] 000F0000 + F0040000 AND [DECIMAL] ;

HEX
DATA-AREA-BASE GET-BASE-ADDR CONSTANT T-DATA-AREA-BASE
00800000 CONSTANT T-DATA-AREA-SIZE
00010000 CONSTANT T-USER-AREA-SIZE0
00004000 CONSTANT T-DATA-STACK-SIZE
00004000 CONSTANT T-RETURN-STACK-SIZE
DECIMAL

VARIABLE T-DATA-AREA-SIZE-ADDR
VARIABLE T-START-ADDR
VARIABLE T-THREAD-START-ADDR
VARIABLE T-FUNC-TABLE-ADDR
VARIABLE T-USER-AREA-SIZE-ADDR

VARIABLE T-USER-AREA-SIZE

: PARA-ALIGN 16 HERE T-DATA-AREA-BASE - 16 MOD - ALLOT ;

FALSE VALUE IN-TARGET?
VARIABLE T-DP
T-DATA-AREA-BASE T-DP !         \ set initial TARGET DP
VARIABLE H-DP

: IN-TARGET IN-TARGET? IF EXIT THEN
  TRUE TO IN-TARGET?
  ALSO TARGET DEFINITIONS
  DP @ H-DP !                   \ save HOST DP
  T-DP @ DP ! ;                 \ set TARGET DP

: IN-HOST IN-TARGET? INVERT IF EXIT THEN
  FALSE TO IN-TARGET?
  PREVIOUS DEFINITIONS
  DP @ T-DP !                   \ save TARGET DP
  H-DP @ DP ! ;                 \ set HOST DP

HERE H-DP !                     \ set initial HOST DP

IN-TARGET

\ -----------------------------------------------------------------------------
\  Header
\ -----------------------------------------------------------------------------

," IKFI"
PARA-ALIGN
T-DATA-AREA-BASE ,              \ image base address
HERE T-DATA-AREA-SIZE-ADDR !    \ address which will be returned by DATA-AREA-SIZE
T-DATA-AREA-SIZE ,              \ data area size
HERE T-START-ADDR !                   
0 ,                             \ address of FORTH enter proc
HERE T-THREAD-START-ADDR !
0 ,                             \ address of THREAD enter proc
HERE T-FUNC-TABLE-ADDR !
0 ,                             \ address of wrapper functions table
HERE T-USER-AREA-SIZE-ADDR !
0 ,                             \ user area size
T-DATA-STACK-SIZE ,             \ data stack size in bytes
PARA-ALIGN


\
\  Register usage:
\    EDI - UDP user data area pointer (NEVER change it!)
\    ESI - IP  instruction pointer
\    ESP - DSP data stack pointer
\    EBP - RSP return stack pointer
\
\    EBX - W pointer
\
\  All other registers have no special meaning.
\

\ -----------------------------------------------------------------------------
\  Primitives
\ -----------------------------------------------------------------------------

CODE (DO-VARIABLE)
                        ADD     EAX , # 1 CELLS
                        PUSH    EAX
                        NEXT
END-CODE

CODE (DO-CREATE)
                        ADD     EAX , # 1 CELLS
                        PUSH    EAX
                        NEXT
END-CODE

(DO-VARIABLE) PATCH (DO-CREATE)

CODE (DO-CONSTANT)
                        ADD     EAX , # 1 CELLS
                        PUSH    [EAX]
                        NEXT
END-CODE

(DO-VARIABLE) PATCH (DO-CONSTANT)

CODE (DO-USER)
                        ADD     EAX , # 1 CELLS
                        MOV     EBX , [EAX]
                        ADD     EBX , EDI
                        PUSH    EBX
                        NEXT
END-CODE

(DO-VARIABLE) PATCH (DO-USER)

CODE (DO-DEFER)
                        ADD     EAX , # 1 CELLS
                        MOV     EAX , [EAX]
                        JMP-NEXT
END-CODE

(DO-VARIABLE) PATCH (DO-DEFER)

CODE (DO-:)
                        SUB     EBP , # 1 CELLS         \ PUSH ESI to return stack
                        MOV     [EBP] , ESI             \
                        ADD     EAX , # 1 CELLS
                        MOV     ESI , EAX
                        NEXT
END-CODE

(DO-VARIABLE) PATCH (DO-:)

\ ;  (DO-INT/COMP)
\                         $DEF    '(DO-INT/COMP)',,$DOVAR
\                         LABEL   $PDO_INT_COMP FAR
\                         ADD     EAX,CELL_SIZE
\                         CMP     [DWORD PTR EDI + STATE_VAR],FALSE
\                         JZ      PDIC_INT
\                         ADD     EAX,CELL_SIZE
\ PDIC_INT:
\                         MOV     EAX,[DWORD PTR EAX]
\                         $JMP

\  ?BRANCH
\  Branch to address compiled next if flag on stack is zero
\  D: flag --
CODE ?BRANCH
                        POP     EAX
                        OR      EAX , EAX
                        LODSD
                        JNZ     SHORT @@1
                        MOV     ESI , EAX
@@1:
                        NEXT
END-CODE

\  BRANCH
\  Branch to address compiled next
CODE BRANCH
                        LODSD
                        MOV     ESI , EAX
                        NEXT
END-CODE

\  LIT
\  Compiled by LITERAL
CODE LIT
                        LODSD
                        PUSH    EAX
                        NEXT
END-CODE

\  2LIT
\  Compiled by 2LITERAL
CODE 2LIT
                        LODSD
                        PUSH    EAX
                        LODSD
                        PUSH    EAX
                        NEXT
END-CODE

\ -----------------------------------------------------------------------------
\  Stack
\ -----------------------------------------------------------------------------

\  6.1.1260 DROP
\  Remove top cell from the stack
\  D: a --
CODE DROP
                        ADD     ESP , # 1 CELLS
                        NEXT
END-CODE

\  6.1.1290 DUP
\  D: a -- a a
CODE DUP
                        MOV     EAX , [ESP]
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.0630 ?DUP
\  Duplicate top stack cell if it is not equal to zero
\  D: a -- a | a a
CODE ?DUP
                        MOV     EAX , [ESP]
                        OR      EAX , EAX
                        JZ      SHORT @@1
                        PUSH    EAX
@@1:
                        NEXT
END-CODE

\  6.2.1930 NIP
\  Drop the first item below the top of stack.
\  D: x1 x2 -- x2
CODE NIP
                        POP     EAX
                        POP     EBX
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.1990 OVER
\  D: a b -- a b a
CODE OVER
                        MOV     EAX , 1 CELLS [ESP]
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.2160 ROT
\  D: a b c -- b c a
CODE ROT
                        POP     ECX
                        POP     EBX
                        POP     EAX
                        PUSH    EBX
                        PUSH    ECX
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.2260 SWAP
\  D: a b -- b a
CODE SWAP
                        POP     EAX
                        POP     EBX
                        PUSH    EAX
                        PUSH    EBX
                        NEXT
END-CODE

\  6.2.2030 PICK
\  D: xu ... x1 x0 u -- xu ... x1 x0 xu
\  Remove u. Copy the xu to the top of the stack. An ambiguous condition exists
\  if there are less than u+2 items on the stack before PICK is executed.
CODE PICK
                        POP     EBX
                        MOV     EAX , [ESP] [EBX*4]
                        PUSH    EAX
                        NEXT
END-CODE

\  6.2.2300 TUCK
\  D: x1 x2 -- x2 x1 x2
\  Copy the first (top) stack item below the second stack item.
CODE TUCK
                        POP     EAX
                        POP     EBX
                        PUSH    EAX
                        PUSH    EBX
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.0370 2DROP
\  D: a b --
CODE 2DROP
                        ADD     ESP , # 2 CELLS
                        NEXT
END-CODE

\  6.1.0380 2DUP
\  D: a b -- a b a b
CODE 2DUP
                        MOV     EAX , 1 CELLS [ESP]
                        MOV     EBX , [ESP]
                        PUSH    EAX
                        PUSH    EBX
                        NEXT
END-CODE

\  6.1.0400 2OVER
\  D: a b c d -- a b c d a b
CODE 2OVER
                        MOV     EAX , 3 CELLS [ESP]
                        MOV     EBX , 2 CELLS [ESP]
                        PUSH    EAX
                        PUSH    EBX
                        NEXT
END-CODE

\  6.1.0430 2SWAP
\  D: a b c d -- c d a b
CODE 2SWAP
                        POP     EDX
                        POP     ECX
                        POP     EBX
                        POP     EAX
                        PUSH    ECX
                        PUSH    EDX
                        PUSH    EAX
                        PUSH    EBX
                        NEXT
END-CODE

\ -----------------------------------------------------------------------------
\  Return stack
\ -----------------------------------------------------------------------------

\  6.1.0580 >R
\  Move value from the data stack to return stack
\  D: a --
\  R:   -- a
CODE >R
                        POP     EAX
                        SUB     EBP , # 1 CELLS
                        MOV     [EBP] , EAX    
                        NEXT
END-CODE COMPILE-ONLY

\  6.1.2060 R>
\  Interpretation: Interpretation semantics for this word are undefined.
\  Execution: ( -- x ) ( R:  x -- )
\    Move x from the return stack to the data stack.
CODE R>
                        MOV     EAX , [EBP]
                        ADD     EBP , # 1 CELLS
                        PUSH    EAX
                        NEXT
END-CODE COMPILE-ONLY

\  6.1.2070 R@
\  Copy value from the return stack to data stack
\  R: a -- a
\  D:   -- a
CODE R@
                        MOV     EAX , [EBP]
                        PUSH    EAX
                        NEXT
END-CODE

\  6.2.0340 2>R
\  D: a b --
\  R:     -- a b
CODE 2>R
                        POP     EBX
                        POP     EAX
                        SUB     EBP , # 1 CELLS
                        MOV     [EBP] , EAX
                        SUB     EBP , # 1 CELLS
                        MOV     [EBP] , EBX
                        NEXT
END-CODE COMPILE-ONLY

\  6.2.0410 2R>
\  D:     -- a b
\  R: a b --
CODE 2R>
                        MOV     EBX , [EBP]
                        ADD     EBP , # 1 CELLS
                        MOV     EAX , [EBP]
                        ADD     EBP , # 1 CELLS
                        PUSH    EAX
                        PUSH    EBX
                        NEXT
END-CODE COMPILE-ONLY

\  6.2.0415 2R@
\  D:     -- a b
\  R: a b -- a b
CODE 2R@
                        MOV     EBX , [EBP]
                        MOV     EAX , 1 CELLS [EBP]
                        PUSH    EAX
                        PUSH    EBX
                        NEXT
END-CODE

\  R-PICK
CODE R-PICK
                        POP     EAX
                        SHL     EAX , # 1
                        MOV     EAX , EBP
                        PUSH    [EAX]
                        NEXT
END-CODE

\ -----------------------------------------------------------------------------
\  Memory
\ -----------------------------------------------------------------------------

\  6.1.0850 C!
\  Store char value
\  D: char addr --
CODE C!
                        POP     EBX
                        POP     EAX
                        MOV     [EBX] , AL
                        NEXT
END-CODE

\  6.1.0870 C@
\  Fetch char value
\  D: addr -- char
CODE C@
                        POP     EBX
                        XOR     EAX , EAX
                        MOV     AL  , [EBX]
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.0010 !
\  Store x to the specified memory address
\  D: x addr --
CODE !
                        POP     EBX
                        POP     EAX
                        MOV     [EBX] , EAX
                        NEXT
END-CODE

\  6.1.0650 @
\  Fetch a value from the specified address
\  D: addr -- x
CODE @
                        POP     EBX
                        PUSH    [EBX]
                        NEXT
END-CODE

\  6.1.0310 2!
\  Store two top cells from the stack to the memory
\  D: x1 x2 addr --
CODE 2!
                        POP     EBX
                        POP     [EBX]
                        ADD     EBX , # 1 CELLS
                        POP     [EBX]
                        NEXT
END-CODE

\  6.1.0350 2@
\  Fetch two cells from the memory and put them on stack
\  D: addr -- x1 x2
CODE 2@
                        POP     EBX
                        MOV     ECX , [EBX]
                        ADD     EBX , # 1 CELLS
                        PUSH    [EBX]
                        PUSH    ECX
                        NEXT
END-CODE

\ -----------------------------------------------------------------------------
\  Address math
\ -----------------------------------------------------------------------------

\  6.1.0880 CELL+
\  D: addr - addr+cellsize
CODE CELL+
                        POP     EAX
                        ADD     EAX , # 1 CELLS
                        PUSH    EAX
                        NEXT
END-CODE

\  CELL-
\  D: addr - addr-cellsize
CODE CELL-
                        POP     EAX
                        SUB     EAX , # 1 CELLS
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.0890 CELLS
\  D: a - a*cellsize
CODE CELLS
                        POP     EAX
                        SHL     EAX , # 1
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.0897 CHAR+
\  D: addr - addr+charsize
CODE CHAR+
                        POP     EAX
                        INC     EAX
                        PUSH    EAX
                        NEXT
END-CODE

\  CHAR-
\  D: addr - addr-charsize
CODE CHAR-
                        POP     EAX
                        DEC     EAX
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.0898 CHARS
CODE CHARS
                        NEXT
END-CODE

\ -----------------------------------------------------------------------------
\  Flow control
\ -----------------------------------------------------------------------------

\  6.1.1760 LEAVE
CODE LEAVE
                        ADD     EBP , # 2 CELLS
                        MOV     ESI , [EBP]
                        ADD     EBP , # 1 CELLS
                        NEXT
END-CODE COMPILE-ONLY

\  6.1.1680 I
\  D: ( -- loop-index )
CODE I
                        PUSH    [EBP]
                        NEXT
END-CODE COMPILE-ONLY

\  I'
\  D: -- loop-limit
CODE I'
                        PUSH    1 CELLS [EBP]
                        NEXT
END-CODE COMPILE-ONLY

\  6.1.1730 J
\  D: -- outer-loop-index
CODE J
                        PUSH    3 CELLS [EBP]
                        NEXT
END-CODE COMPILE-ONLY

\  J'
\  D: -- outer-loop-limit
CODE J'
                        PUSH    4 CELLS [EBP]
                        NEXT
END-CODE COMPILE-ONLY

\  K
\  D: -- outer-outer-loop-index
CODE K
                        PUSH    6 CELLS [EBP]
                        NEXT
END-CODE COMPILE-ONLY

\  K'
\  D: -- outer-outer-loop-limit
CODE K'
                        PUSH    7 CELLS [EBP]
                        NEXT
END-CODE COMPILE-ONLY

\  6.1.1370 EXECUTE
\  D: ( i*x xt -- j*y )
CODE EXECUTE
                        POP     EAX
                        JMP-NEXT
END-CODE

\ -----------------------------------------------------------------------------
\  Convert
\ -----------------------------------------------------------------------------

\  >NAME
\  D: xt -- name-addr
CODE >NAME
                        POP     EAX
                        SUB     EAX , # 5       \ skip link field and second counter
                        XOR     EBX , EBX
                        MOV     BL  , [EAX]
                        SUB     EAX , EBX
                        INC     EAX
                        PUSH    EAX
                        NEXT
END-CODE

\  NAME>
\  D: name-addr -- xt
CODE NAME>
                        POP     EAX
                        XOR     EBX , EBX
                        MOV     BL  , [EAX]
                        ADD     EAX , EBX
                        ADD     EAX , # 6
                        PUSH    EAX
                        NEXT
END-CODE

\  6.1.2170 S>D
\  Convert single cell value to double cell value
\  D: a -- aa
CODE S>D
                        POP     EAX
                        CDQ
                        PUSH    EAX
                        PUSH    EDX
                        NEXT
END-CODE

CR .( Writing Kernel.img )
S" Kernel.f\Kernel.img" W/O CREATE-FILE THROW
T-DATA-AREA-BASE HERE OVER - 4096 / 1+ 4096 * 2 PICK WRITE-FILE THROW
CLOSE-FILE THROW

IN-HOST

BASE !