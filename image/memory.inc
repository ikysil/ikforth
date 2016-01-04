;******************************************************************************
;
;  memory.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Memory
;******************************************************************************

;  6.1.0010 !
;  Store x to the specified memory address
;  D: x addr --
                        $DEF    '!',$STORE
                        POPDS   EBX
                        POPDS   EAX
                        MOV     [DWORD PTR EBX],EAX
                        $NEXT

;  6.1.0650 @
;  Fetch a value from the specified address
;  D: addr -- x
                        $DEF    '@',$FETCH
                        POPDS   EBX
                        PUSHDS  <[DWORD PTR EBX]>
                        $NEXT

;  6.1.0310 2!
;  Store two top cells from the stack to the memory
;  D: x1 x2 addr --
                        $DEF    '2!',$2STORE
                        POPDS   EBX
                        POPDS   <[DWORD PTR EBX]>
                        POPDS   <[DWORD PTR EBX + CELL_SIZE]>
                        $NEXT

;  6.1.0350 2@
;  Fetch two cells from the memory and put them on stack
;  D: addr -- x1 x2
                        $DEF    '2@',$2FETCH
                        POPDS   EBX
                        PUSHDS  <[DWORD PTR EBX + CELL_SIZE]>
                        PUSHDS  <[DWORD PTR EBX]>
                        $NEXT

;  6.1.0850 C!
;  Store char value
;  D: char addr --
                        $DEF    'C!',$CSTORE
                        POPDS   EBX
                        POPDS   EAX
                        MOV     [BYTE PTR EBX],AL
                        $NEXT

;  6.1.0870 C@
;  Fetch char value
;  D: addr -- char
                        $DEF    'C@',$CFETCH
                        POPDS   EBX
                        XOR     EAX,EAX
                        MOV     AL,[BYTE PTR EBX]
                        PUSHDS  EAX
                        $NEXT

;  6.1.0880 CELL+
;  D: addr - addr+cellsize
                        $DEF    'CELL+',$CELLADD
                        POPDS   EAX
                        ADD     EAX,CELL_SIZE
                        PUSHDS  EAX
                        $NEXT

;  6.1.0890 CELLS
;  D: a - a*cellsize
                        $DEF    'CELLS',$CELLS
                        POPDS   EAX
                        ADD     EAX,EAX
                        ADD     EAX,EAX
                        PUSHDS  EAX
                        $NEXT

;  6.1.0897 CHAR+
;  D: addr - addr+charsize
                        $DEF    'CHAR+',$CHARADD
                        POPDS   EAX
                        INC     EAX
                        PUSHDS  EAX
                        $NEXT

