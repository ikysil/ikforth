;******************************************************************************
;
;  memory.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Memory
;******************************************************************************

;  6.1.0010 !
;  Store x to the specified memory address
;  D: x addr --
                        $CODE   '!',$STORE
                        POPDS   EBX
                        POPDS   EAX
                        MOV     [DWORD PTR EBX],EAX
                        $NEXT

;  6.1.0650 @
;  Fetch a value from the specified address
;  D: addr -- x
                        $CODE   '@',$FETCH
                        POPDS   EBX
                        PUSHDS  <[DWORD PTR EBX]>
                        $NEXT

;  6.1.0310 2!
;  Store two top cells from the stack to the memory
;  D: x1 x2 addr --
                        $CODE   '2!',$2STORE
                        POPDS   EBX
                        POPDS   <[DWORD PTR EBX]>
                        POPDS   <[DWORD PTR EBX + CELL_SIZE]>
                        $NEXT

;  6.1.0350 2@
;  Fetch two cells from the memory and put them on stack
;  D: addr -- x1 x2
                        $CODE   '2@',$2FETCH
                        POPDS   EBX
                        PUSHDS  <[DWORD PTR EBX + CELL_SIZE]>
                        PUSHDS  <[DWORD PTR EBX]>
                        $NEXT

;  6.1.0850 C!
;  Store char value
;  D: char addr --
                        $CODE   'C!',$CSTORE
                        POPDS   EBX
                        POPDS   EAX
                        MOV     [BYTE PTR EBX],AL
                        $NEXT

;  6.1.0870 C@
;  Fetch char value
;  D: addr -- char
                        $CODE   'C@',$CFETCH
                        POPDS   EBX
                        XOR     EAX,EAX
                        MOV     AL,[BYTE PTR EBX]
                        PUSHDS  EAX
                        $NEXT

;  6.1.0880 CELL+
;  D: addr - addr+cellsize
                        $CODE   'CELL+',$CELLADD
                        POPDS   EAX
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  6.1.0890 CELLS
;  D: a - a*cellsize
                        $CODE   'CELLS',$CELLS
                        POPDS   EAX
                        ADD     EAX,EAX
                        ADD     EAX,EAX
                        PUSHDS  EAX
                        $NEXT

;  6.1.0897 CHAR+
;  D: addr - addr+charsize
                        $CODE   'CHAR+',$CHARADD
                        POPDS   EAX
                        INC     EAX
                        PUSHDS  EAX
                        $NEXT

