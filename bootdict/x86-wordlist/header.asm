;******************************************************************************
;
;  header.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  HEADER & support words
;******************************************************************************

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
;       IF   NAME>NEXT   ELSE   DROP 0   THEN
;    REPEAT
;    DROP R> DROP
; ;

; STDWL-TRAVERSE
; ( i * x xt wid -- j * x )
                $COLON      'STDWL-TRAVERSE',$STDWL_TRAVERSE
                CW          $WLTOLATEST, $FETCH
                CW          $SWAP, $TOR
                _BEGIN      STDWLTW_LOOP
                CW          $DUP, $ZERONOEQ
                _WHILE      STDWLTW_LOOP
                CW          $RFETCH, $OVER, $TOR, $EXECUTE, $RFROM, $SWAP
                _IF         STDWLTW_CONTINUE
                CW          $NAME_TO_NEXT
                _ELSE       STDWLTW_CONTINUE
                CW          $DROP, $ZERO
                _THEN       STDWLTW_CONTINUE
                _REPEAT     STDWLTW_LOOP
                CW          $DROP, $RFROM, $DROP
                $END_COLON

;  STDWL-SEARCH-NAME
;  ( c-addr u 0 nt -- c-addr u false true | xt 1 true false | xt -1 true false )
;  If flag is true, STDWL-TRAVERSE will continue with the next name, otherwise it will return.
;  nt is the address of vocabulary entry flags.
;  If the definition is found, return its execution token xt and one (1) if the definition is immediate, minus-one (-1) otherwise.
                $COLON      'STDWL-SEARCH-NAME',$STDWL_SEARCH_NAME
                CW          $DUP, $HFLAGS_FETCH, $AMPHIDDEN, $AND
                _IF         STDWL_SEARCH_NAME_HIDDEN
                CW          $2DROP, $FALSE, $TRUE, $EXIT
                _THEN       STDWL_SEARCH_NAME_HIDDEN
                CW          $2OVER
                CCLIT       2
                CW          $PICK
                ; S: c-addr u 0 nt c-addr u nt
                CW          $NAME_TO_STRING
                ; S: c-addr u 0 nt c-addr u nt-addr nt-u
                CW          $NAMEEQ
                _IF         STDWL_SEARCH_NAME_FOUND
                ; S: c-addr u 0 nt
                CW          $2SWAP, $2DROP, $NIP
                ; S: nt
                CW          $DUP, $HEAD_FROM, $SWAP
                CW          $HFLAGS_FETCH, $AMPIMMEDIATE, $AND
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
