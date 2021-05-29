;******************************************************************************
;
;  search.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Words search
;******************************************************************************

                $VAR        'LAST-WORDLIST',,LATEST_WL

;  WID>XT-SEARCH
;  D: ( wid -- xt-search )
                $COLON      'WID>XT-SEARCH',$WID_TO_XT_SEARCH
                CW          $WID_TO_VT, $FETCH, $FETCH
                $END_COLON

;  WID>XT-TRAVERSE
;  D: ( wid -- xt-traverse )
                $COLON      'WID>XT-TRAVERSE',$WID_TO_XT_TRAVERSE
                CW          $WID_TO_VT, $FETCH, $CELL_PLUS, $FETCH
                $END_COLON

;  16.6.1.2192 SEARCH-WORDLIST
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'SEARCH-WORDLIST',$SEARCH_WORDLIST
                CW          $DUPE, $WID_TO_XT_SEARCH, $EXECUTE
                $END_COLON

; 15.6.2.2297 TRAVERSE-WORDLIST
; ( i * x xt wid -- j * x )
                $COLON      'TRAVERSE-WORDLIST',$TRAVERSE_WORDLIST
                CW          $DUPE, $WID_TO_XT_TRAVERSE, $EXECUTE
                $END_COLON

                $CREATE     'WORDLIST-VT',$WORDLIST_VT
                CW          $STDWL_SEARCH_ASM
                CW          $STDWL_TRAVERSE

;  D: ( c-addr u -- 0 | xt 1 | xt -1 )
                $COLON      '(SEARCH-NAME)',$PSEARCH_NAME
                CW          $FORTH_WORDLIST, $SEARCH_WORDLIST
                $END_COLON

;  SEARCH-NAME
;  D: ( c-addr u -- 0 | xt 1 | xt -1 )
                $DEFER      'SEARCH-NAME',$SEARCH_NAME,$PSEARCH_NAME

;  6.1.1550 FIND
;  D: ( c-addr -- c-addr 0 | xt 1 | xt -1 )
                $COLON      'FIND',$FIND
                CW          $DUPE, $TO_R, $COUNT, $SEARCH_NAME, $DUPE, $ZERO_NOT_EQUALS
                _IF         FF_FOUND
                CW          $R_FROM, $DROP
                _ELSE       FF_FOUND
                CW          $R_FROM, $SWAP
                _THEN       FF_FOUND
                $END_COLON
