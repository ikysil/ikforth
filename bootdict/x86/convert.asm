;******************************************************************************
;
;  convert.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Misc convertion words
;******************************************************************************

;  6.1.2170 S>D
;  Convert single cell value to double cell value
;  D: a -- aa
                $CODE       'S>D',$STOD
                POPDS       EAX
                CDQ
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT

;  Convert a byte to hex characters so that B>H EMIT EMIT sequence
;  will print the representation of the value.
;  S: a -- ca cb
                $CODE       'B>H',$BTOH
                LEA         EDX,[DIGITS_TABLE + IMAGE_BASE]
                POPDS       EAX
                XOR         ECX,ECX
                MOV         EBX,EAX
                AND         EBX,0x0F
                MOV         CL,BYTE [EDX + EBX]
                PUSHDS      ECX
                SHR         EAX,4
                MOV         EBX,EAX
                AND         EBX,0x0F
                MOV         CL,BYTE [EDX + EBX]
                PUSHDS      ECX
                $NEXT

;  Split TOS into 4 bytes with most significant byte at TOS.
;  S: a -- e d c b
                $CODE       'SPLIT-8',$SPLIT8
                POPDS       EAX
                XOR         ECX,ECX
                MOV         CL,AL
                PUSH        ECX
                MOV         CL,AH
                PUSH        ECX
                SHR         EAX,16
                MOV         CL,AL
                PUSH        ECX
                MOV         CL,AH
                PUSH        ECX
                $NEXT
