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
                        $CREATE 'FORTH-WORDLIST',$FORTH_WORDLIST
FORTH_WORDLIST_EQU:
                        DD      LATEST_WORD             ; last word in a list
                        CC      0                       ; wordlist name
                        CC      0                       ; wordlist link
FORTH_WORDLIST_VT:
                        PW      $WORDLIST_VT            ; wordlist VT

;  WID>VT
;  D: ( wid -- wid-vt-addr )
                        $CODE   'WID>VT',$WID_TO_VT
                        POPDS    EAX
                        ADD      EAX,FORTH_WORDLIST_VT - FORTH_WORDLIST_EQU
                        PUSHDS   EAX
                        $NEXT

;  WID>XT-SEARCH
;  D: ( wid -- xt-search )
                        $COLON  'WID>XT-SEARCH',$WID_TO_XT_SEARCH
                        XT_$WID_TO_VT
                        XT_$FETCH
                        XT_$FETCH
                        XT_$EXIT

;  16.6.1.2192 SEARCH-WORDLIST
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                        $COLON  'SEARCH-WORDLIST',$SEARCH_WORDLIST
                        XT_$DUP
                        XT_$WID_TO_XT_SEARCH
                        XT_$EXECUTE
                        XT_$EXIT

;  SEARCH-FORTH-WORDLIST
;  D: ( c-addr u wid -- 0 | xt 1 | xt -1 )
                        $COLON  'SEARCH-FORTH-WORDLIST',$SEARCH_FORTH_WORDLIST
                        XT_$FETCH
                        CW      $SEARCH_HEADERS
                        XT_$EXIT

                        $CREATE 'WORDLIST-VT',$WORDLIST_VT
                        CW      $SEARCH_FORTH_WORDLIST

;  D: ( c-addr u -- 0 | xt 1 | xt -1 )
                        $COLON  '(SEARCH-NAME)',$PSEARCH_NAME
                        XT_$FORTH_WORDLIST
                        XT_$SEARCH_WORDLIST
                        XT_$EXIT

;  SEARCH-NAME
;  D: ( c-addr u -- 0 | xt 1 | xt -1 )
                        $DEFER  'SEARCH-NAME',$SEARCH_NAME,$PSEARCH_NAME

;  6.1.1550 FIND
;  D: ( c-addr -- c-addr 0 | xt 1 | xt -1 )
                        $COLON  'FIND',$FIND
                        XT_$DUP
                        XT_$TOR
                        XT_$COUNT
                        XT_$SEARCH_NAME
                        XT_$DUP
                        XT_$ZEROEQ
                        CQBR    FF_FOUND
                          XT_$RFROM
                          XT_$SWAP
                        CBR     FF_EXIT
FF_FOUND:
                          XT_$RFROM
                          XT_$DROP
FF_EXIT:
                        XT_$EXIT
