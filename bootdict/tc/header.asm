;******************************************************************************
;
;  header.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  HEADER & support words
;******************************************************************************

;  REPORT-NEW-NAME
                $VAR        'REPORT-NEW-NAME',$REPORT_NEW_NAME,F_FALSE

;  REPORT-NEW-NAME-DUPLICATE
                $VAR        'REPORT-NEW-NAME-DUPLICATE',$REPORT_NEW_NAME_DUPLICATE,F_FALSE

;  MAX-NAME-LENGTH
                $VAR        'MAX-NAME-LENGTH',$MAX_NAME_LENGTH,64

;  USE-LOCATE
                $VAR        'USE-LOCATE',$USE_LOCATE,F_TRUE

;  &USUAL
;  D: -- VEF-USUAL
                $CONST      '&USUAL',,VEF_USUAL

;  &IMMEDIATE
;  D: -- VEF-IMMEDIATE
                $CONST      '&IMMEDIATE',$AMPIMMEDIATE,VEF_IMMEDIATE

;  &HIDDEN
;  D: -- VEF-HIDDEN
                $CONST      '&HIDDEN',$AMPHIDDEN,VEF_HIDDEN

;  &COMPILE-ONLY
;  D: -- VEF-COMPILE-ONLY
                $CONST      '&COMPILE-ONLY',HF_COMPILE_ONLY,VEF_COMPILE_ONLY

;  &LOCATE
;  D: -- VEF-LOCATE
                $CONST      '&LOCATE',$AMPLOCATE,VEF_LOCATE

;  &IMMEDIATE/COMPILE-ONLY
;  D: -- VEF-IMMEDIATE or VEF-COMPILE-ONLY
                $CONST      '&IMMEDIATE/COMPILE-ONLY',,VEF_IMMEDIATE_COMPILE_ONLY

;  CFA-SIZE
;  Size of CFA field
;  D: -- n
                $CONST      'CFA-SIZE',$CFA_SIZE,CFA_SIZE

;  $NEXT-CODE-SIZE
                $CREATE     '$NEXT-CODE',$NEXT_CODE
NEXT_CODE_START:
                $NEXT
NEXT_CODE_END:

NEXT_CODE_SIZE  EQU         NEXT_CODE_END - NEXT_CODE_START

;  $NEXT-CODE-SIZE
;  Size of CFA field
;  D: -- n
                $CONST      '$NEXT-CODE-SIZE',$NEXT_CODE_SIZE,NEXT_CODE_SIZE

;  $NEXT!
;  Compile the machine code for $NEXT primitive of inner interpreter at addr address.
;  D: addr --
                $COLON      '$NEXT!',$NEXTSTORE
                CW          $NEXT_CODE, $SWAP, $NEXT_CODE_SIZE, $CMOVE
                $END_COLON

;  CHECK-NAME
;  D: c-addr count -- c-addr count
                $COLON      'CHECK-NAME',$CHECK_NAME
                CW          $DUP, $ZEROEQ
                _IF         CHECK_NAME_TOO_SHORT
                CTHROW  -16
                _THEN       CHECK_NAME_TOO_SHORT
                CW          $DUP
                CFETCH      $MAX_NAME_LENGTH
                CW          $GR
                _IF         CHECK_NAME_TOO_LONG
                CTHROW  -19
                _THEN       CHECK_NAME_TOO_LONG
                $END_COLON

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                $COLON      '(REPORT-NAME)',$PREPORT_NAME
                CFETCH      $REPORT_NEW_NAME
                _IF         PREPORT_NAME_NEW
                CW          $2DUP, $TYPE
                $WRITE      ' '
                _THEN       PREPORT_NAME_NEW
                CFETCH      $REPORT_NEW_NAME_DUPLICATE
                _IF         PREPORT_NAME_DUPLICATE
                CW          $2DUP
                CFETCH      $CURRENT
                CW          $SEARCH_WORDLIST        ; c-addr u 0 | c-addr u xt +/-1
                CW          $ZERONOEQ
                _IF         PREPORT_NAME_HAS_DUPLICATE
                CW          $DROP
                $WRITE  'Redefinition of '
                CW          $2DUP, $TYPE
                $WRITE  ' '
                _THEN       PREPORT_NAME_HAS_DUPLICATE
                _THEN       PREPORT_NAME_DUPLICATE
                $END_COLON

;  REPORT-NAME
;  D: c-addr count -- c-addr count
                $DEFER      'REPORT-NAME',$REPORT_NAME,$PREPORT_NAME

;  (LOCATE,)
;  S: flags1 count -- flags2
;  Compile information for LOCATE and set &LOCATE in flags if enabled.
                $COLON      '(LOCATE,)',$PLOCATEC
                CFETCH      $USE_LOCATE
                _IF         USE_LOCATE
                CFETCH      $INCLUDE_MARK
                CW          $COMMA
                CFETCH      $TOIN
                CW          $SWAP, $SUB
                CW          $COMMA
                CFETCH      $INCLUDE_LINE_NUM
                CW          $COMMA, $AMPLOCATE, $OR
                _ELSE       USE_LOCATE
                CW          $DROP
                _THEN       USE_LOCATE
                $END_COLON

;  (HEADER,)
;  Compile header without CFA
;  D: [ 0 0 | c-addr count ] flags --
                $COLON      '(HEADER,)',$PHEADERC
                CW          $OVER, $PLOCATEC
                CW          $HERE
                CW          $TOR
                CW          $CCOMMA                 ; compile flags
                CW          $SWAP                   ; count c-addr
                CW          $OVER                   ; count c-addr count
                CW          $DUP
                CW          $CCOMMA                 ; compile length
                CW          $QDUP
                _IF         PHEADERC_HAS_NAME
                CW          $HERE                   ; count c-addr count here
                CW          $SWAP                   ; count c-addr here count
                CW          $DUP
                CW          $ALLOT
                CW          $CMOVE                  ; put name
                _ELSE       PHEADERC_HAS_NAME
                CW          $DROP
                _THEN       PHEADERC_HAS_NAME
                CCLIT       2
                CW          $ADD
                CW          $CCOMMA                 ; compile (length + 2)
                CW          $LATEST_HEAD_FETCH, $COMMA, $RFROM, $LATEST_HEAD_STORE
                $END_COLON

;  (CFA,)
;  Compile CFA after (HEADER,)
;  D: [ code-addr | 0 ] -- xt
                $COLON      '(CFA,)',$PCFA_C
                MATCH       =TRUE, DEBUG {
                $WRITE      '  XT='
                CW          $HERE, $HOUT8
                $WRITE      '  '
                }
                CW          $DUP
                ;  D: [ code-addr | 0 ] [ code-addr | 0 ]
                CW          $ZEROEQ
                ;  D: [ code-addr | 0 ] eq-zero-flag
                _IF         PCFA_C_HAS_CODE_ADDR
                CW          $DROP, $HERE
                ;   D: xt
                CCLIT       CFA_SIZE
                CW          $ADD
                ;   D: code-addr
                _THEN       PCFA_C_HAS_CODE_ADDR
                CW          $HERE
                ;   D: code-addr xt
                CCLIT       CFA_SIZE
                CW          $ALLOT
                ;   D: code-addr xt
                CW          $SWAP, $OVER
                ;   D: xt code-addr xt
                CW          $CODE_ADDRESS_STORE
                ;   D: xt
                $END_COLON

;  HEADER,
;  D: [ code-addr | 0 ] [ 0 0 | c-addr count ] flags -- xt
                $COLON      'HEADER,',$HEADERC
                CW          $PHEADERC, $PCFA_C
                $END_COLON

;  CHECK-HEADER,
;  D: [ executor-xt | 0 ] [ 0 0 | c-addr count ] flags -- xt
                $COLON      'CHECK-HEADER,',$CHECK_HEADERC
                CW          $TOR, $CHECK_NAME, $REPORT_NAME, $RFROM, $HEADERC
                $END_COLON

;  PARSE-CHECK-HEADER,
;  D: [ executor-xt | 0 ] flags "name" -- xt
                $COLON      'PARSE-CHECK-HEADER,',$PARSE_CHECK_HEADERC
                CW          $TOR, $PARSE_NAME, $RFROM, $CHECK_HEADERC
                $END_COLON

;  HFLAGS!
;  D: x h-id --
;  Store flags specified by x to the flags field of the header
                $COLON      'HFLAGS!',$HFLAGS_STORE
                CW          $CSTORE
                $END_COLON

;  HFLAGS@
;  D: h-id -- x
;  Get flags from the flags field of the header
                $COLON      'HFLAGS@',$HFLAGS_FETCH
                CW          $CFETCH
                $END_COLON

;  SET-HFLAGS!
;  D: flags --
                $COLON      'SET-HFLAGS!'
                CW          $LATEST_HEAD_FETCH, $DUP, $HFLAGS_FETCH, $ROT, $OR, $SWAP, $HFLAGS_STORE
                $END_COLON

;  RESET-HFLAGS!
;  D: flags --
                $COLON      'RESET-HFLAGS!'
                CW          $LATEST_HEAD_FETCH, $DUP, $HFLAGS_FETCH, $ROT, $INVERT, $AND, $SWAP, $HFLAGS_STORE
                $END_COLON

;  INVERT-HFLAGS!
;  D: flags --
                $COLON      'INVERT-HFLAGS!'
                CW          $LATEST_HEAD_FETCH, $DUP, $HFLAGS_FETCH, $ROT, $XOR, $SWAP, $HFLAGS_STORE
                $END_COLON

;  HEAD>NAME
                $COLON      'HEAD>NAME',$HEAD_TO_NAME
                CW          $1ADD
                $END_COLON

;  NAME>HEAD
                $COLON      'NAME>HEAD',$NAME_TO_HEAD
                CW          $1SUB
                $END_COLON

;  >NAME
;  D: xt -- name-addr
                $COLON      '>NAME',$TO_NAME
                CW          $TO_HEAD, $HEAD_TO_NAME
                $END_COLON

;  NAME>
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

;  H>NEXT>H
;  D: h-id -- prev_h-id | 0
                $COLON      'H>NEXT>H',$H_TO_NEXT_TO_H
                CW          $HEAD_FROM, $TO_LINK, $FETCH
                $END_COLON

;  H>#NAME
;  D: h-id -- addr len
                $COLON      'H>#NAME',$H_TO_HASH_NAME
                CW          $HEAD_TO_NAME, $DUP, $1ADD, $SWAP, $CFETCH
                $END_COLON

;  NAME=
;  S: c-addr1 u1 c-addr2 u2 -- flag
;  Compare names, return true if same, false otherwise.
;  Case sensitivity is determined by CASE-SENSITIVE variable.
                $COLON      'NAME=',$NAMEEQ
                CW          $CASE_SENSITIVE, $FETCH, $PNAMEEQ
                $END_COLON

;  : WL>LATEST (S wordlist-id -- latest-word-addr )
;  ;
                $COLON      'WL>LATEST',$WLTOLATEST
                $END_COLON

; : TRAVERSE-WORDLIST
;    (S i * x xt wid -- j * x )
;    (G Remove wid and xt from the stack. Execute xt once for every word in the wordlist wid,
;       passing the name token nt of the word to xt, until the wordlist is exhausted or until xt returns false.
;
;       The invoked xt has the stack effect [ k * x nt -- l * x flag ].
;
;       If flag is true, TRAVERSE-WORDLIST will continue with the next name, otherwise it will return.
;       TRAVERSE-WORDLIST does not put any items other than nt on the stack when calling xt,
;       so that xt can access and modify the rest of the stack.
;
;       TRAVERSE-WORDLIST may visit words in any order, with one exception:
;       words with the same name are called in the order newest-to-oldest, possibly with other words in between.
;
;       An ambiguous condition exists if words are added to or deleted from the wordlist wid
;       during the execution of TRAVERSE-WORDLIST. )
;    SWAP >R
;    WL>LATEST @
;    BEGIN
;       DUP 0<>
;    WHILE
;       R@ OVER >R EXECUTE R> SWAP
;       IF  H>NEXT>H  ELSE  DROP 0  THEN
;    REPEAT
;    DROP R> DROP
; ;

; STDWL-TRAVERSE
; ( i * x xt wid -- j * x )
                $COLON      'STDWL-TRAVERSE',$STDWL_TRAVERSE
                CW          $WLTOLATEST, $FETCH
                CW          $SWAP, $TOR
STDWLTW_LOOP:
                CW          $DUP, $ZERONOEQ
                _IF         STDWLTW_HAS_WORD
                CW          $RFETCH, $OVER, $TOR, $EXECUTE, $RFROM, $SWAP
                _IF         STDWLTW_CONTINUE
                CW          $H_TO_NEXT_TO_H
                _ELSE       STDWLTW_CONTINUE
                CW          $DROP, $ZERO
                _THEN       STDWLTW_CONTINUE
                CBR         STDWLTW_LOOP
                _THEN       STDWLTW_HAS_WORD
                CW          $DROP, $RFROM, $DROP
                $END_COLON

;  STDWL-SEARCH-NAME
;  ( c-addr u 0 nt -- c-addr u false true | xt 1 true false | xt -1 true false )
;  If flag is true, STDWL-TRAVERSE will continue with the next name, otherwise it will return.
;  nt is the address of vocabulary entry flags.
;  If the definition is found, return its execution token xt and one (1) if the definition is immediate, minus-one (-1) otherwise.
                $COLON      'STDWL-SEARCH-NAME',$STDWL_SEARCH_NAME
                CW          $DUP, $CFETCH, $AMPHIDDEN, $AND
                _IF         STDWL_SEARCH_NAME_HIDDEN
                CW          $2DROP, $FALSE, $TRUE, $EXIT
                _THEN       STDWL_SEARCH_NAME_HIDDEN
                CW          $2OVER
                CCLIT       2
                CW          $PICK
                ; S: c-addr u 0 nt c-addr u nt
                CW          $H_TO_HASH_NAME
                ; S: c-addr u 0 nt c-addr u nt-addr nt-u
                CW          $NAMEEQ
                _IF         STDWL_SEARCH_NAME_FOUND
                ; S: c-addr u 0 nt
                CW          $2SWAP, $2DROP, $NIP
                ; S: nt
                CW          $DUP, $HEAD_FROM, $SWAP
                CW          $CFETCH, $AMPIMMEDIATE, $AND
                _IF         STDWL_SEARCH_NAME_IMM
                CCLIT       1
                _ELSE       STDWL_SEARCH_NAME_IMM
                CCLIT       -1
                _THEN       STDWL_SEARCH_NAME_IMM
                CW          $TRUE, $FALSE
                _ELSE       STDWL_SEARCH_NAME_FOUND
                ; S: c-addr u 0 nt
                CW          $2DROP, $FALSE, $TRUE
                _THEN       STDWL_SEARCH_NAME_FOUND
                $END_COLON

;  STDWL-SEARCH
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'STDWL-SEARCH',$STDWL_SEARCH
                CCLIT       0
                CWLIT       $STDWL_SEARCH_NAME
                CW          $ROT, $STDWL_TRAVERSE, $INVERT
                _IF         STDWL_SEARCH_NOT_FOUND
                CW          $2DROP
                CCLIT       0
                _THEN       STDWL_SEARCH_NOT_FOUND
                $END_COLON

;  STDWL-SEARCH-ASM
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'STDWL-SEARCH-ASM',$STDWL_SEARCH_ASM
                CW          $WLTOLATEST, $FETCH
                CW          $SEARCH_HEADERS
                $END_COLON
