;******************************************************************************
;
;  memory.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Memory
;******************************************************************************

;  6.1.0010 !
;  Store x to the specified memory address
;  D: x addr --
                $CODE       '!',$STORE,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                MOV         DWORD [EBX],EAX
                $NEXT

;  6.1.0650 @
;  Fetch a value from the specified address
;  D: addr -- x
                $CODE       '@',$FETCH,VEF_USUAL
                POPDS       EBX
                PUSHDS      <DWORD [EBX]>
                $NEXT

;  6.1.0310 2!
;  ( x1 x2 a-addr -- )
;  Store the cell pair x1 x2 at a-addr, with x2 at a-addr and x1 at the next consecutive cell.
;  It is equivalent to the sequence SWAP OVER ! CELL+ !.
                $CODE       '2!',$2STORE,VEF_USUAL
                POPDS       EBX
                POPDS       <DWORD [EBX]>
                POPDS       <DWORD [EBX + CELL_SIZE]>
                $NEXT

;  6.1.0350 2@
;  ( a-addr -- x1 x2 )
;  Fetch the cell pair x1 x2 stored at a-addr. x2 is stored at a-addr and x1 at the next consecutive cell.
;  It is equivalent to the sequence DUP CELL+ @ SWAP @.
                $CODE       '2@',$2FETCH,VEF_USUAL
                POPDS       EBX
                PUSHDS      <DWORD [EBX + CELL_SIZE]>
                PUSHDS      <DWORD [EBX]>
                $NEXT

;  6.1.0850 C!
;  Store char value
;  D: char addr --
                $CODE       'C!',$CSTORE,VEF_USUAL
                POPDS       EBX
                POPDS       EAX
                MOV         BYTE [EBX],AL
                $NEXT

;  6.1.0870 C@
;  Fetch char value
;  D: addr -- char
                $CODE       'C@',$CFETCH,VEF_USUAL
                POPDS       EBX
                XOR         EAX,EAX
                MOV         AL,BYTE [EBX]
                PUSHDS      EAX
                $NEXT

;  6.1.0880 CELL+
;  D: addr - addr+cellsize
                $CODE       'CELL+',$CELLADD,VEF_USUAL
                POPDS       EAX
                ADD         EAX,CELL_SIZE
                PUSHDS      EAX
                $NEXT

;  6.1.0890 CELLS
;  D: a - a*cellsize
                $CODE       'CELLS',$CELLS,VEF_USUAL
                POPDS       EAX
                ADD         EAX,EAX
                ADD         EAX,EAX
                PUSHDS      EAX
                $NEXT

;  6.1.0897 CHAR+
;  D: addr - addr+charsize
                $CODE       'CHAR+',$CHARADD,VEF_USUAL
                POPDS       EAX
                INC         EAX
                PUSHDS      EAX
                $NEXT

;  6.1.0898 CHARS
;  ( n1 -- n2 )
;  n2 is the size in address units of n1 characters.
                $CODE       'CHARS',$CHARS
                $NEXT
