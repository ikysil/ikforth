;  >DIGIT
;  ( c base -- n | -1 )
;  Convert symbol c to number n using specified base.
;  Return -1 if symbol c is not a correct digit in the specified base.
                $CODE       '>DIGIT',$TODIGIT
                POPDS       EBX
                POPDS       EAX
                CALL        TODIGIT
                MOVSX       EBX,AL
                PUSHDS      EBX
                $NEXT

;  In:  AL - symbol to convert
;       BL - base
;  Out: AL - digit or FFh if not recognized
                LABEL       TODIGIT
                PUSHDS      ECX
                PUSHDS      EDX
                XOR         EDX,EDX
                DEC         EDX
                MOV         CL,10                       ; correction is needed if symbol is not a decimal digit
                MOV         AH,AL
                CMP         AH,'z'
                CMOVA       EAX,EDX
                SUB         AH,'a'
                JAE         SHORT TD_DONE               ; jump if AL >= 'a'
                MOV         AH,AL
                CMP         AH,'Z'
                CMOVA       EAX,EDX
                SUB         AH,'A'
                JAE         SHORT TD_DONE               ; jump if AL >= 'A'
                XOR         CL,CL                       ; no correction is needed for decimal digits
                MOV         AH,AL
                CMP         AH,'9'
                CMOVA       EAX,EDX
                SUB         AH,'0'
TD_DONE:
                ADD         AH,CL                       ; apply correction
                MOV         AL,AH
                OR          AL,AL
                CMOVS       EAX,EDX
                CMP         AL,BL
                CMOVAE      EAX,EDX
                AND         EAX,0FFh
                POPDS       EDX
                POPDS       ECX
                RET
