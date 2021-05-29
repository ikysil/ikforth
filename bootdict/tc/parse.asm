;******************************************************************************
;
;  parse.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Parsing
;******************************************************************************

;  6.1.0560 >IN
                $USER       '>IN',$TOIN,VAR_TOIN

;  6.2.2008 PARSE
;  ( char "ccc<char>" -- c-addr u )
;  Parse ccc delimited by the delimiter char.
;
;  c-addr is the address (within the input buffer) and u is the length of the parsed string.
;  If the parse area was empty, the resulting string has a zero length.
                $COLON      'PARSE',$PARSE
                CW          $SOURCE             ; c c-addr u
                CFETCH      $TOIN
                CW          $SLASH_STRING
                CW          $PPARSE             ; c-addr u
                CW          $DUPE, $CHAR_PLUS, $TOINADD
                $END_COLON

;  17.6.1.0245 /STRING
;  Adjust the character string at c-addr1 by n characters.
;  The resulting character string, specified by c-addr2 u2,
;  begins at c-addr1 plus n characters and is u1 minus n characters long.
;  : /STRING ( c-addr1 u1 n -- c-addr2 u2 )
;     2DUP < IF DROP DUP THEN ROT OVER + -ROT -
;  ;
                $COLON      '/STRING',$SLASH_STRING
                CW          $TWO_DUPE, $LESS_THAN
                _IF         SLS_SHORT
                CW          $DROP, $DUPE
                _THEN       SLS_SHORT
                CW          $ROT, $OVER, $PLUS, $MROT, $MINUS
                $END_COLON

;  SKIP-BLANK
;  c-addr u -- c-addr' u'
                $COLON      'SKIP-BLANK',$SKIP_BLANK
                _BEGIN      SKBL_LOOP
                CW          $DUPE, $ZERO_GREATER
                _WHILE      SKBL_LOOP
                CW          $OVER, $C_FETCH, $BL, $ONE_PLUS, $U_LESS_THAN
                _WHILE      SKBL_LOOP
                CCLIT       1
                CW          $SLASH_STRING
                _REPEAT     SKBL_LOOP
                $END_COLON

;  SKIP-NON-BLANK
;  c-addr u -- c-addr' u'
                $COLON      'SKIP-NON-BLANK',$SKIP_NON_BLANK
                _BEGIN      SKNBL_LOOP
                CW          $DUPE, $ZERO_GREATER
                _WHILE      SKNBL_LOOP
                CW          $OVER, $C_FETCH, $BL, $U_GREATER_THAN
                _WHILE      SKNBL_LOOP
                CCLIT       1
                CW          $SLASH_STRING
                _REPEAT     SKNBL_LOOP
                $END_COLON

;  >IN+
;  S: n --
;  Add n to the value of >IN
                $COLON      '>IN+',$TOINADD
                CW          $TOIN, $FETCH, $PLUS, $TOIN, $STORE
                $END_COLON

;  (PARSE-NAME)
;  ( c-addr1 u1 -- c-addr2 u2 )
;  Skip leading space delimiters. Parse the rest of the string c-addr1 u1 delimited by a space.
                $COLON      '(PARSE-NAME)',$PPARSE_NAME

                MATCH       =TRUE, DEBUG {
                $TRACE_STACK '(PARSE-NAME)-A:',3
                }

                CW          $OVER, $TO_R         ; S: c-addr u R: c-addr
                CW          $SKIP_BLANK         ; S: c-addr' u' R: c-addr
                CW          $OVER, $R_FROM, $MINUS, $TOINADD ; fix >IN over skipped spaces

                MATCH       =TRUE, DEBUG {
                $TRACE_STACK '(PARSE-NAME)-B:',2
                $CR
                $WRITE      '(PARSE-NAME)-C: '
                CW          $TWO_DUPE, $TYPE
                }

                CW          $OVER, $TO_R         ; S: c-addr' u' R: c-addr'
                CW          $SKIP_NON_BLANK     ; S: c-addr" u" R: c-addr'
                CW          $DROP, $R_FROM, $TUCK, $MINUS
                CW          $DUPE, $CHAR_PLUS, $TOINADD ; fix >IN over parsed name and delimiter

                MATCH       =TRUE, DEBUG {
                $TRACE_STACK '(PARSE-NAME)-D:',2
                $CR
                $WRITE      '(PARSE-NAME)-E: '
                CW          $TWO_DUPE, $TYPE
                }

                $END_COLON

;  6.2.2020 PARSE-NAME
;  ( "<spaces>name<space>" -- c-addr u )
;  Skip leading space delimiters. Parse name delimited by a space.
;
;  c-addr is the address of the selected string within the input buffer and u is its length in characters.
;  If the parse area is empty or contains only white space, the resulting string has length zero.
                $COLON      'PARSE-NAME',$PARSE_NAME
                CW          $SOURCE             ; S: c-addr u
                CFETCH      $TOIN
                CW          $SLASH_STRING       ; S: c-addr* u*
                CW          $PPARSE_NAME
                $END_COLON

;  S">POCKET
;  ( c-addr1 u1 -- c-addr2 )
;  Copy string from c-addr1 to POCKET as counted string and return its address.
;  Trim to maximum length of POCKET if needed.
                $COLON      'S">POCKET',$SQTOPOCKET
                CW          $DUPE
                CCLIT       SLPOCKET - 1
                CW          $U_GREATER_THAN
                _IF         SQTOPOCKET_TOO_LONG
                CW          $DROP
                CCLIT       SLPOCKET - 1
                _THEN       SQTOPOCKET_TOO_LONG
                CW          $DUPE, $POCKET, $DUPE, $TO_R, $C_STORE
                CW          $R_FETCH, $ONE_PLUS, $SWAP
                CW          $TWO_DUPE, $TWO_TO_R, $CMOVE, $TWO_R_FROM
                CW          $CHARS, $PLUS, $BL, $SWAP, $STORE
                CW          $R_FROM
                $END_COLON

;  ,S"
;  S: c-addr count --
                $COLON      ',S"',$COMMA_SQUOTE
                CW          $DUPE, $COMMA, $HERE, $OVER, $ALLOT, $SWAP, $CMOVE
                $END_COLON

;  (S")
;  S: -- c-addr count
                $COLON      '(S")',$PSQUOTE
                CW          $R_FROM, $DUPE, $FETCH, $SWAP, $CELL_PLUS, $TWO_DUPE, $PLUS, $TO_R, $SWAP
                $END_COLON

;  S"-COMP
                $COLON      'S"-COMP',$SQ_COMP
                CCLIT       '"'
                CW          $PARSE

                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'S"-COMP-A:',2
                $CR
                $WRITE      'S"-COMP-B: '
                CW          $TWO_DUPE, $TYPE
                }

                CWLIT       $PSQUOTE
                CW          $COMPILEC
                CW          $COMMA_SQUOTE
                $END_COLON

;  +S"BUFFER
;  S: -- c-addr
;  Return address of next buffer to use by S" and family.
;  Size of the buffer is provided by /S"BUFFER
                $COLON      '+S"BUFFER',$PLSQBUFFER
                CFETCH      $SQINDEX
                CW          $ONE_PLUS, $SQINDEX_MASK, $AND, $DUPE
                CSTORE      $SQINDEX
                CW          $SLSQBUFFER, $STAR, $SQBUFFER, $PLUS
                $END_COLON

;  >S"BUFFER
;  S: c-addr1 u1 -- c-addr2 u2
;  Copy string from c-addr1 to a temporary buffer and return it's address c-addr2.
;  u2 is the actual number of characters copied.
                $COLON      '>S"BUFFER',$TOSQBUFFER
                CW          $PLSQBUFFER, $SWAP, $TWO_DUPE, $TWO_TO_R, $CMOVE, $TWO_R_FROM
                $END_COLON

;  S"-INT
                $COLON      'S"-INT',$SQ_INT
                CCLIT       '"'
                CW          $PARSE

                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'S"-INT-A:',2
                $CR
                $WRITE      'S"-INT-B: '
                CW          $TWO_DUPE, $TYPE
                }

                CW          $TOSQBUFFER
                $END_COLON

;     6.1.2165 S"
;  11.6.1.2165 S"
                $DEF        'S"',$SQUOTE,$PDO_INT_COMP,VEF_IMMEDIATE
                CW          $SQ_INT
                CW          $SQ_COMP

;  \ (filler text)
                $COLON      '(\)',$PBSLASH
                CW          $ZERO, $PARSE, $TWO_DROP
                $END_COLON

                $DEFER      '\',,$PBSLASH,VEF_IMMEDIATE

                $COLON      'NOOP',$NOOP,VEF_IMMEDIATE
                $END_COLON

                MATCH       =TRUE, DEBUG {
                $DEFER      '\DEBUG',$SLDEBUG,$NOOP,VEF_IMMEDIATE
                }

                IF          ~ DEFINED CFA_$SLDEBUG
                $DEFER      '\DEBUG',,$PBSLASH,VEF_IMMEDIATE
                END IF
