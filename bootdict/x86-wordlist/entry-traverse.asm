;   PURPOSE: Traverse through the wordlist entry
;   LICENSE: Unlicense since 1999 by Illya Kysil

; A wordlist is a linked list of words. The link offset at the end of the list is zero.
; The offset is the positive number of bytes to the previous entry.
; The offset is used instead of a pointer to avoid address relocation.
;
;                                               ^
;                                               |
; +-----------+------+-----------+-------+------+------+-----+------+
; | Name Len1 | Name | Name Len2 | Flags | Link offset | CFA | Body |
; +-----------+------+-----------+-------+------+------+-----+------+
;                                               ^
;                                               |
;                                            LATEST
;
; Flags: 1 byte
; Name Len1: 1 byte, length of Name
; Name: 0-255 bytes
; Name Len2: 1 byte, length of Name + 1
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
                CW          $DUP, $ZEROEQ
                _IF         NTNEXT_LAST
                CW          $EXIT
                _THEN       NTNEXT_LAST
                CW          $NAME_TO_LINK, $DUP, $FETCH, $DUP
                _IF         NTNEXT_HASNEXT
                CW          $SUB
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
                CW          $SUB, $DUP, $CFETCH, $SUB, $COUNT
                $END_COLON

;  6.1.0550 >BODY
;  Convert CFA to PFA
;  D: CFA -- PFA
                $COLON      '>BODY',$TOBODY
                CCLIT       CFA_SIZE
                CW          $ADD
                $END_COLON
