;******************************************************************************
;
;  varconst.inc
;  IKForth
;
;  Copyright (C) 1999-2004 Illya Kysil
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

                        CC      VAR_CASE_SENSITIVE

;  CURRENT-FILE-POSITION
                        $USER   'CURRENT-FILE-POSITION',$CURRENT_FILE_POSITION

                        CC      VAR_CURR_FILE_POS

;  FILE-LINE
;  Line address for INCLUDED
                        $USER   'FILE-LINE',$FILE_LINE

                        CC      VAR_FILE_LINE

;  #FILE-LINE
;  Line length for INCLUDED
                        $USER   '#FILE-LINE',$HASH_FILE_LINE

                        CC      VAR_HASH_FILE_LINE

                        $CONST  'MAX-FILE-LINE-LENGTH'

                        CC      MAX_FILE_LINE_LENGTH

;  USER-SIZE-VAR
                        $VAR    'USER-SIZE-VAR'

                        CC      USER_AREA_SIZE

;  EXCEPTION-HANDLER
                        $USER   'EXCEPTION-HANDLER',$EXCEPTION_HANDLER

                        CC      VAR_EXCEPTION_HANDLER

;  S"-BUFFER
                        $USER   'S"-BUFFER',$SQUOTE_BUFFER

                        CC      VAR_SQUOTE_BUFFER

;  S"-BUFFER-SIZE
                        $CONST  'S"-BUFFER-SIZE'

                        CC      SQUOTE_BUFFER_SIZE

;  POCKET
                        $USER   'POCKET',$POCKET

                        CC      VAR_POCKET

;  CURRENT
                        $USER   'CURRENT',$CURRENT

                        CC      VAR_CURRENT

;  Start file name
;  #SF
                        $VAR    '#SF',$HASH_SF

HASH_SF_VAR:
                        CC      0

;  SF
                        $VAR    'SF',$SF

SF_VAR:
                        CC      0

                        $CONST  'ARGC'
ARGC_VAR:
                        CC      0

                        $CONST  'ARGV'
ARGV_VAR:
                        CC      0

                        $CONST  'ENVP'
ENVP_VAR:
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

VAR_DP:
                        CW      HERE

;  6.1.2250 STATE
;  D: -- a-addr
;  a-addr is the address of a cell containing the compilation-state flag.
;  STATE is true when in compilation state, false otherwise.
;  The true value in STATE is non-zero, but is otherwise implementation-defined.
                        $VAR    'STATE',$STATE

VAR_STATE:
                        CC      F_FALSE

;  6.1.0750 BASE
;  a-addr is the address of a cell containing the current number-conversion
;  radix {{2...36}}.
;  D: -- a-addr
                        $USER   'BASE',$BASE

                        CC      VAR_BASE

;  6.1.0770 BL
;  Push space character on stack
;  D: -- char
                        $CONST  'BL',$BL

                        CC      ' '

;  MAIN
;  First Forth word to EXECUTE
                        $DEFER  'MAIN'

MAIN_PROC_VAR:
                        CW      $DO_FORTH

