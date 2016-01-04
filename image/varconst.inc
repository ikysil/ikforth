;******************************************************************************
;
;  varconst.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  Variables & constants
;******************************************************************************

;  D: -- 0
                        $CONST  '0',$ZERO
                        CC      0

;  CASE-SENSITIVE
;  If CASE-SENSITIVE is true, then FIND is case sensitive
                        $USER   'CASE-SENSITIVE',$CASE_SENSITIVE
                        CC      CASE_SENSITIVE_VAR

;  TIB
;  String address of Terminal Input Buffer
                        $USER   'TIB',$TIB
                        CC      TIB_VAR

;  #TIB
;  String length of Terminal Input Buffer
                        $USER   '#TIB',$#TIB
                        CC      #TIB_VAR

;  EVAL
;  String address for EVALUATE
                        $USER   'EVAL',$EVAL
                        CC      EVAL_VAR

;  #EVAL
;  String length for EVALUATE
                        $USER   '#EVAL',$#EVAL
                        CC      #EVAL_VAR

;  CURRENT-FILE-POSITION
                        $USER   'CURRENT-FILE-POSITION',$CURRENT_FILE_POSITION
                        CC      CURR_FILE_POS_VAR

;  LINE
;  Line address for INCLUDED
                        $USER   'LINE',$LINE
                        CC      LINE_VAR

;  #LINE
;  Line length for INCLUDED
                        $USER   '#LINE',$#LINE
                        CC      #LINE_VAR

;  USER-SIZE-VAR
                        $VAR    'USER-SIZE-VAR'
                        CC      USER_AREA_SIZE

;  EXCEPTION-HANDLER
                        $USER   'EXCEPTION-HANDLER',$EXCEPTION_HANDLER
                        CC      EXCEPTION_HANDLER_VAR

;  THROW-ADDRESS
                        $USER   'THROW-ADDRESS',$THROW_ADDRESS
                        CC      THROW_ADDRESS_VAR

;  THROW-WORD
                        $USER   'THROW-WORD',$THROW_WORD
                        CC      THROW_WORD_VAR

;  S"-BUFFER
                        $USER   'S"-BUFFER',$SQUOTE_BUFFER
                        CC      SQUOTE_BUFFER_VAR

;  POCKET
                        $USER   'POCKET',$POCKET
                        CC      POCKET_VAR

;  CURRENT
                        $USER   'CURRENT',$CURRENT
                        CC      CURRENT_VAR

;  Start file name
;  #SF
                        $VAR    '#SF',$#SF
#SF_VAR:
                        CC      0

;  SF
                        $VAR    'SF',$SF
SF_VAR:
                        CC      0

;  DATA-AREA-BASE
                        $CONST  'DATA-AREA-BASE'
                        CC      DESIRED_BASE_EQU

;  DATA-AREA-SIZE
                        $CONST  'DATA-AREA-SIZE'
                        CW      DESIRED_SIZE_VAR

;  DP
;  HERE = DP @
                        $VAR    'DP',$DP
DP_VAR:
                        CW      HERE

;  6.1.2250 STATE
;  D: -- a-addr
;  a-addr is the address of a cell containing the compilation-state flag.
;  STATE is true when in compilation state, false otherwise.
;  The true value in STATE is non-zero, but is otherwise implementation-defined.
                        $USER   'STATE',$STATE
                        CC      STATE_VAR

;  6.1.0750 BASE
;  a-addr is the address of a cell containing the current number-conversion
;  radix {{2...36}}.
;  D: -- a-addr
                        $USER   'BASE',$BASE
                        CC      BASE_VAR

;  6.1.0770 BL
;  Push space character on stack
;  D: -- char
                        $CONST  'BL',$BL
                        CC      ' '

;  MAIN
;  First Forth word to EXECUTE
                        $DEFER  'MAIN',$MAIN
MAIN_PROC:
                        CW      $DO_FORTH

;  MAX-ORDER-COUNT
MAX_ORDER_COUNT         EQU     16
                        $CONST  'MAX-ORDER-COUNT'
                        CC      MAX_ORDER_COUNT
