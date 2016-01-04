;******************************************************************************
;
;  string.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  String words
;******************************************************************************

;  17.6.1.0910 CMOVE
;  D: c-addr1 c-addr2 u --
;  If u is greater than zero, copy u consecutive characters from the data space
;  starting at c-addr1 to that starting at c-addr2, proceeding character-by-character
;  from lower addresses to higher addresses. 
                        $DEF    'CMOVE',$CMOVE
                        PUSHRS  EDI
                        PUSHRS  ESI
                        POPDS   ECX
                        POPDS   EDI
                        POPDS   ESI
                        OR      ECX,ECX
                        JZ      SHORT CMOVE_EXIT
                        CLD
                    REP MOVSB
CMOVE_EXIT:
                        POPRS   ESI
                        POPRS   EDI
                        $NEXT

;  17.6.1.0920 CMOVE>
;  D: c-addr1 c-addr2 u --
;  If u is greater than zero, copy u consecutive characters from the data space
;  starting at c-addr1 to that starting at c-addr2, proceeding character-by-character
;  from higher addresses to lower addresses. 
                        $DEF    'CMOVE>',$CMOVEGR
                        PUSHRS  EDI
                        PUSHRS  ESI
                        POPDS   ECX
                        POPDS   EDI
                        ADD     EDI,ECX
                        DEC     EDI
                        POPDS   ESI
                        ADD     ESI,ECX
                        DEC     ESI
                        OR      ECX,ECX
                        JBE     SHORT CMOVEGR_EXIT
                        STD
                    REP MOVSB
                        CLD
CMOVEGR_EXIT:
                        POPRS   ESI
                        POPRS   EDI
                        $NEXT

;  17.6.1.0935 COMPARE
                        $DEF    'COMPARE',$COMPARE
                        $CALL   COMPARE_FUNC
                        PUSHDS  EAX
                        $NEXT

;  6.1.0980 COUNT
                        $DEF    'COUNT',$COUNT
                        POPDS   EBX
                        MOVZX   EAX,[BYTE PTR EBX]
                        INC     EBX
                        PUSHDS  EBX
                        PUSHDS  EAX
                        $NEXT

