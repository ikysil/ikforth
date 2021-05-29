;   PURPOSE: Create a wordlist entry
;   LICENSE: Unlicense since 1999 by Illya Kysil

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
                $CONST      '&COMPILE-ONLY',$AMPCOMPILE_ONLY,VEF_COMPILE_ONLY

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

;  $NEXT-CODE
                $CREATE     '$NEXT-CODE',$NEXT_CODE
NEXT_CODE_START:
                $NEXT
NEXT_CODE_END:

NEXT_CODE_SIZE  EQU         NEXT_CODE_END - NEXT_CODE_START

;  $NEXT-CODE-SIZE
;  Size of $NEXT code fragment
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

;  CREATE-LINK,
;  Compile link to the previous definition
                $COLON      'CREATE-LINK,',$CREATE_LINK_C
                CW          $HERE, $DUP, $LATEST_NAME_FETCH
                MATCH       =TRUE, DEBUG {
                $TRACE_STACK 'CREATE-LINK,-A:',2
                }
                CW          $SUB, $COMMA
                CW          $LATEST_NAME_STORE
                $END_COLON

;  (HEADER,)
;  Compile header without CFA
;  D: [ 0 0 | c-addr count ] flags --
                $COLON      '(HEADER,)',$PHEADERC
                CW          $TOR
                CW          $SWAP                   ; count c-addr
                CW          $OVER                   ; count c-addr count
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
                CW          $C_COMMA                 ; compile length
                CW          $RFROM
                CW          $C_COMMA                 ; compile flags
                CW          $CREATE_LINK_C
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
                CW          $OVER, $PLOCATEC
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

