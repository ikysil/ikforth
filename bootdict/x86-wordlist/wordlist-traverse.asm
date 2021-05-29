;   PURPOSE: Traverse wordlist - words and structure
;   LICENSE: Unlicense since 1999 by Illya Kysil

;  WID>VT
;  D: ( wid -- wid-vt-addr )
                $CODE       'WID>VT',$WID_TO_VT
                POPDS       EAX
                ADD         EAX,CELL_SIZE * 3
                PUSHDS      EAX
                $NEXT

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
                CW          $SWAP, $TO_R
                _BEGIN      STDWLTW_LOOP
                CW          $DUP, $ZERO_NOT_EQUALS
                _WHILE      STDWLTW_LOOP
                CW          $RFETCH, $OVER, $TO_R, $EXECUTE, $R_FROM, $SWAP
                _IF         STDWLTW_CONTINUE
                CW          $NAME_TO_NEXT
                _ELSE       STDWLTW_CONTINUE
                CW          $DROP, $ZERO
                _THEN       STDWLTW_CONTINUE
                _REPEAT     STDWLTW_LOOP
                CW          $DROP, $R_FROM, $DROP
                $END_COLON
