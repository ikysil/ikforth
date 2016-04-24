;******************************************************************************
;
;  search.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Words search
;******************************************************************************

;  16.6.1.1595 FORTH-WORDLIST
                $CREATE     'FORTH-WORDLIST',$FORTH_WORDLIST
FORTH_WORDLIST_EQU:
                DD          LATEST_WORD             ; last word in a list
                CC          0                       ; wordlist name
                CC          0                       ; wordlist link
FORTH_WORDLIST_VT:
                PW          $WORDLIST_VT            ; wordlist VT

;  WID>VT
;  D: ( wid -- wid-vt-addr )
                $CODE       'WID>VT',$WID_TO_VT
                POPDS       EAX
                ADD         EAX,FORTH_WORDLIST_VT - FORTH_WORDLIST_EQU
                PUSHDS      EAX
                $NEXT

;  WID>XT-SEARCH
;  D: ( wid -- xt-search )
                $COLON      'WID>XT-SEARCH',$WID_TO_XT_SEARCH
                CW          $WID_TO_VT, $FETCH, $FETCH
                $END_COLON

;  16.6.1.2192 SEARCH-WORDLIST
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'SEARCH-WORDLIST',$SEARCH_WORDLIST
                CW          $DUP, $WID_TO_XT_SEARCH, $EXECUTE
                $END_COLON

;  SEARCH-FORTH-WORDLIST
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                $COLON      'SEARCH-FORTH-WORDLIST',$SEARCH_FORTH_WORDLIST
                CW          $FETCH, $SEARCH_HEADERS
                $END_COLON

                $CREATE     'WORDLIST-VT',$WORDLIST_VT
                CW          $SEARCH_FORTH_WORDLIST

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
                CW          $DUP, $TOR, $COUNT, $SEARCH_NAME, $DUP, $ZERONOEQ
                _IF         FF_FOUND
                CW          $RFROM, $DROP
                _ELSE       FF_FOUND
                CW          $RFROM, $SWAP
                _THEN       FF_FOUND
                $END_COLON
