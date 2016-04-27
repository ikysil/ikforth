; Convert character in AL to upper case, only ASCII a-z characters are supported
                LABEL       UPCASE
                CMP         AL,'a'
                JB          SHORT @@UC              ; jump if AH < 'a'
                CMP         AL,'z'
                JA          SHORT @@UC              ; jump if AH > 'z'
                SUB         AL,'a' - 'A'            ; convert to uppercase
@@UC:
                RET
