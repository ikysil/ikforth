;   PURPOSE: Traverse through the wordlist entry
;   LICENSE: Unlicense since 1999 by Illya Kysil

; A wordlist is a linked list of words. The link offset at the end of the list is zero.
; The offset is the positive number of bytes to the previous entry.
; The offset is used instead of a pointer to avoid address relocation.
;
;                                              ^
;                                              |
; +-------+-----------+------+-----------+-------------+-----+------+
; | Flags | Name Len1 | Name | Name Len2 | Link offset | CFA | Body |
; +-------+-----------+------+-----------+-------------+-----+------+
;     ^
;     |
;  LATEST
;
; Flags: 1 byte
; Name Len1: 1 byte, length of Name
; Name: 0-255 bytes
; Name Len2: 1 byte, length of Name + 2
; Link Offset: CELL
; CFA: CELL in ITC, size of JMP instruction in DTC
; Body: any number of bytes

;  HEAD>FLAGS
;  D: h-id -- flags-addr
                $CODE       'HEAD>FLAGS',$HEAD_TO_FLAGS
                $NEXT

;  FLAGS>HEAD
;  D: flags-addr -- h-id
                $CODE       'FLAGS>HEAD',$FLAGS_TO_HEAD
                $NEXT

;  HEAD>
;  D: h-id -- xt
;  h-id is the address of vocabulary entry flags
                $CODE       'HEAD>',$HEAD_FROM
                POPDS       EAX
                INC         EAX
                XOR         EBX,EBX
                MOV         BL,BYTE [EAX]
                ADD         EAX,EBX
                ADD         EAX,6
                PUSHDS      EAX
                $NEXT

;  >HEAD
;  D: xt -- h-id
;  h-id is the address of vocabulary entry flags
                $CODE       '>HEAD',$TO_HEAD
                POPDS       EAX
                SUB         EAX,5
                XOR         EBX,EBX
                MOV         BL,BYTE [EAX]
                SUB         EAX,EBX
                PUSHDS      EAX
                $NEXT

;  FIXME - remove HEAD>NAME
                $COLON      'HEAD>NAME',$HEAD_TO_NAME
                CW          $1ADD
                $END_COLON

;  FIXME - remove NAME>HEAD
                $COLON      'NAME>HEAD',$NAME_TO_HEAD
                CW          $1SUB
                $END_COLON

;  FIXME - remove >NAME
;  D: xt -- name-addr
                $COLON      '>NAME',$TO_NAME
                CW          $TO_HEAD, $HEAD_TO_NAME
                $END_COLON

;  FIXME - remove NAME>
;  D: name-addr -- xt
                $COLON      'NAME>',$NAME_FROM
                CW          $NAME_TO_HEAD, $HEAD_FROM
                $END_COLON

;  >LINK
;  D: CFA -- LFA
                $COLON      '>LINK',$TO_LINK
                CCLIT       CELL_SIZE
                CW          $SUB
                $END_COLON

;  LINK>
;  D: LFA -- CFA
                $COLON      'LINK>',$LINK_FROM
                CCLIT       CELL_SIZE
                CW          $ADD
                $END_COLON

;   NAME>NEXT
;   D: nt -- nt-next | 0
;   Fetch nt of the previous word.
                $COLON      'NAME>NEXT',$NAME_TO_NEXT
                CW          $DUP, $ZEROEQ
                _IF         NTNEXT_LAST
                CW          $EXIT
                _THEN       NTNEXT_LAST
                CW          $HEAD_FROM, $TO_LINK, $DUP, $FETCH, $DUP
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
                CW          $HEAD_TO_NAME, $COUNT
                $END_COLON

;  6.1.0550 >BODY
;  Convert CFA to PFA
;  D: CFA -- PFA
                $COLON      '>BODY',$TOBODY
                CCLIT       CFA_SIZE
                CW          $ADD
                $END_COLON
