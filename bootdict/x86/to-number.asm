;  6.1.0570 >NUMBER
;  ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 )
;  ud2 is the unsigned result of converting the characters within the string
;  specified by c-addr1 u1 into digits, using the number in BASE, and adding
;  each into ud1 after multiplying ud1 by the number in BASE.
;  Conversion continues left-to-right until a character that is not convertible,
;  including any "+" or "-", is encountered or the string is entirely converted.
;  c-addr2 is the location of the first unconverted character or the first
;  character past the end of the string if the string was entirely converted.
;  u2 is the number of unconverted characters in the string.
;  An ambiguous condition exists if ud2 overflows during the conversion.
                $CODE       '>NUMBER',$TO_NUMBER
                PUSHRS      ESI
                POPDS       ECX                         ; ECX - u1
                POPDS       ESI                         ; ESI - c-addr1
TN_LOOP:
                OR          ECX,ECX
                JZ          SHORT TN_STOP
                MOV         AL,BYTE [ESI]               ; AL - symbol
                MOV         EBX,DWORD [EDI + VAR_BASE]  ; EBX - BASE
                CALL        TODIGIT
                OR          AL,AL
                JS          SHORT TN_STOP
TN_CONT1:
                PUSHRS      ECX
                MOVZX       ECX,AL
                POPDS       EAX
                MUL         DWORD [EDI + VAR_BASE]      ; EDX:EAX = highest significant cell of ud * BASE
                MOV         EBX,EAX                     ; save only the lowest part of that product
                POPDS       EAX
                MUL         DWORD [EDI + VAR_BASE]      ; EDX:EAX = lowest significant cell of ud * BASE
                ADD         EAX,ECX                     ; add digit to lowest part
                ADC         EDX,EBX                     ; add highest significant cell of ud * BASE and carry
                PUSHDS      EAX
                PUSHDS      EDX
                POPRS       ECX
                DEC         ECX
                INC         ESI
                JMP         SHORT TN_LOOP
TN_STOP:
                PUSHDS      ESI
                PUSHDS      ECX
                POPRS       ESI
                $NEXT
