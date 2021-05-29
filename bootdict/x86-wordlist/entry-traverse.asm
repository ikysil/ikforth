;   PURPOSE: Traverse through the wordlist entry
;   LICENSE: Unlicense since 1999 by Illya Kysil

; A wordlist is a linked list of words. The link offset at the end of the list is zero.
; The offset is the positive number of bytes to the previous entry.
; The offset is used instead of a pointer to avoid address relocation.
;
;                                           ^
;                                           |
; +--------+------+----------+-------+------+------+-----+------+
; | Locate | Name | Name Len | Flags | Link offset | CFA | Body |
; +--------+------+----------+-------+------+------+-----+------+
;                                           ^
;                                           |
;                                        LATEST
;
; Locate: 0 or 3 CELLS
; Name: 0-255 bytes
; Name Len: 1 byte
; Flags: 1 byte
; Link Offset: CELL
; CFA: address of inner interpreter in ITC, machine code in DTC
; Body: any number of bytes

;  NAME>FLAGS
;  D: nt -- flags-addr
                $CODE       'NAME>FLAGS',$NAME_TO_FLAGS
                POPDS       EAX
                DEC         EAX
                PUSHDS      EAX
                $NEXT

;  FLAGS>NAME
;  D: flags-addr -- nt
                $CODE       'FLAGS>NAME',$FLAGS_TO_NAME
                POPDS       EAX
                INC         EAX
                PUSHDS      EAX
                $NEXT

;  NAME>CODE
;  D: nt -- xt
                $CODE       'NAME>CODE',$NAME_TO_CODE
                POPDS       EAX
                ADD         EAX,CELL_SIZE
                PUSHDS      EAX
                $NEXT

;  CODE>NAME
;  D: xt -- nt
                $CODE       'CODE>NAME',$CODE_TO_NAME
                POPDS       EAX
                SUB         EAX,CELL_SIZE
                PUSHDS      EAX
                $NEXT

;   NAME>LINK
;   D: nt -- nt-addr
;   Fetch address of the field storing the link to the nt of the previous word.
                $COLON      'NAME>LINK',$NAME_TO_LINK
                $END_COLON

;   NAME>NEXT
;   D: nt -- nt-next | 0
;   Fetch nt of the previous word.
                $COLON      'NAME>NEXT',$NAME_TO_NEXT
                CW          $DUPE, $ZERO_EQUALS
                _IF         NTNEXT_LAST
                CW          $EXIT
                _THEN       NTNEXT_LAST
                CW          $NAME_TO_LINK, $DUPE, $FETCH, $DUPE
                _IF         NTNEXT_HASNEXT
                CW          $MINUS
                _ELSE       NTNEXT_HASNEXT
                CW          $NIP
                _THEN       NTNEXT_HASNEXT
                $END_COLON

;   15.6.2.1909.40 NAME>STRING
;   (S nt -- c-addr u )
;   (G NAME>STRING returns the name of the word nt in the character string c-addr u.
;       The case of the characters in the string is implementation-dependent.
;       The buffer containing c-addr u may be transient and valid until the next invocation of NAME>STRING.
;       A program shall not write into the buffer containing the resulting string. )
                $COLON      'NAME>STRING',$NAME_TO_STRING
                CCLIT       2
                CW          $MINUS
                CW          $DUPE                    ; S: name-len-addr name-len-addr
                CW          $C_FETCH                 ; S: name-len-addr name-len
                CW          $SWAP, $OVER            ; S: name-len name-len-addr name-len
                CW          $MINUS
                CW          $SWAP
                $END_COLON

;   NAME>LOCATE
;   (S nt -- addr | 0 )
;   (G NAME>LOCATE returns the address of the locate information of the word nt or 0 if it is not recorded. )
                $COLON      'NAME>LOCATE',$NAME_TO_LOCATE
                CW          $DUPE, $HFLAGS_FETCH
                CW          $AMPLOCATE, $AND
                _IF         NTL_HAS_LOCATE
                CW          $NAME_TO_STRING, $DROP
                CCLIT       LOCATE_SIZE
                CW          $MINUS
                _ELSE       NTL_HAS_LOCATE
                CW          $DROP
                CW          $ZERO
                _THEN       NTL_HAS_LOCATE
                $END_COLON

;  6.1.0550 >BODY
;  Convert CFA to PFA
;  D: CFA -- PFA
                $COLON      '>BODY',$TO_BODY
                CCLIT       CFA_SIZE
                CW          $PLUS
                $END_COLON
