;  6.1.0150 ,
;  Reserve one cell of data space and store x in the cell
;  D: x --
                $CODE       ',',$COMMA
                POPDS       EAX
                MOV         EBX,DWORD [VAR_DP + IMAGE_BASE]
                MOV         DWORD [EBX],EAX
                ADD         DWORD [VAR_DP + IMAGE_BASE],CELL_SIZE
                $NEXT
