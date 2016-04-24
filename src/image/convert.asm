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

;  6.1.0570 >NUMBER
                        $CODE   '>NUMBER',$TONUMBER

                        PUSHRS  EDI
                        MOV     EBX,DWORD [EDI + VAR_BASE]
                        POPDS   ECX                     ; u1
                        POPDS   EDI                     ; c-addr1
                        POPDS   EDX                     ; ud1
                        POPDS   EAX
TN_LOOP:
                        OR      ECX,ECX
                        JZ      SHORT TN_STOP
                        PUSHRS  EAX
                        MOV     AL,BYTE [EDI]
                        CMP     AL,'a'
                        JB      SHORT TN_CONT           ; jump if AL < 'a'
                        CMP     AL,'z'
                        JA      SHORT TN_CONT           ; jump if AL > 'z'
                        SUB     AL,'a' - 'A'            ; convert to uppercase
TN_CONT:
                        PUSHDS  EDI
                        PUSHDS  ECX
                        MOV     EDI,DIGITS_TABLE + IMAGE_BASE
                        MOV     ECX,EBX
                        INC     ECX
                  REPNE SCASB
                        JNZ     SHORT TN_CONT2
                        DEC     EDI
                        DEC     EDI
                        SUB     EDI,DIGITS_TABLE + IMAGE_BASE
                        CMP     EDI,EBX
                        JGE     SHORT TN_CONT2
                        CMP     ECX,0
                        JG      SHORT TN_CONT1
TN_CONT2:
                        POPDS   ECX
                        POPDS   EDI
                        POPRS   EAX
                        JMP     SHORT TN_STOP
TN_CONT1:
                        PUSHDS  EBX
                        SUB     EBX,ECX
                        MOV     ECX,EBX
                        POPDS   EBX
                        MOV     EAX,EDX
                        MUL     EBX
                        PUSHDS  EAX
                        POPRS   EAX
                        MUL     EBX
                        ADD     EAX,ECX
                        POPDS   ECX
                        ADC     EDX,ECX
                        POPDS   ECX
                        DEC     ECX
                        POPDS   EDI
                        INC     EDI
                        JMP     SHORT TN_LOOP
TN_STOP:
                        PUSHDS  EAX
                        PUSHDS  EDX
                        PUSHDS  EDI
                        PUSHDS  ECX
                        POPRS   EDI
                        $NEXT

;  DIGITS
                        $CREATE 'DIGITS',$DIGITS
DIGITS_TABLE:
                        DB      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',0

;  6.1.2170 S>D
;  Convert single cell value to double cell value
;  D: a -- aa
                        $CODE   'S>D',$STOD

                        POPDS   EAX
                        CDQ
                        PUSHDS  EAX
                        PUSHDS  EDX
                        $NEXT

;  Convert a byte to hex characters so that B>H EMIT EMIT sequence
;  will print the representation of the value.
;  S: a -- ca cb
                        $CODE   'B>H',$BTOH
                        LEA     EDX,[DIGITS_TABLE + IMAGE_BASE]
                        POPDS   EAX
                        XOR     ECX,ECX
                        MOV     EBX,EAX
                        AND     EBX,0x0F
                        MOV     CL,BYTE [EDX + EBX]
                        PUSHDS  ECX
                        SHR     EAX,4
                        MOV     EBX,EAX
                        AND     EBX,0x0F
                        MOV     CL,BYTE [EDX + EBX]
                        PUSHDS  ECX
                        $NEXT

;  Split TOS into 4 bytes with most significant byte at TOS.
;  S: a -- e d c b
                        $CODE   'SPLIT-8',$SPLIT8
                        POPDS   EAX
                        XOR     ECX,ECX
                        MOV     CL,AL
                        PUSH    ECX
                        MOV     CL,AH
                        PUSH    ECX
                        SHR     EAX,16
                        MOV     CL,AL
                        PUSH    ECX
                        MOV     CL,AH
                        PUSH    ECX
                        $NEXT

;  Output the byte on the top of the data stack in hexadecimal representation.
;  S: a --
                        $COLON  'H.2',$HOUT2
                        XT_$BTOH
                        XT_$EMIT
                        XT_$EMIT
                        $END_COLON

;  Output the value on the top of the data stack in hexadecimal representation.
;  S: a --
                        $COLON  'H.8',$HOUT8
                        XT_$SPLIT8
                        XT_$HOUT2
                        XT_$HOUT2
                        XT_$HOUT2
                        XT_$HOUT2
                        $END_COLON
