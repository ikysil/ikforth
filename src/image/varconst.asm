;******************************************************************************
;
;  varconst.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  Variables & constants
;******************************************************************************

;  D: -- 0
                        $CONST  '0',$ZERO,0

;  CASE-SENSITIVE
;  If CASE-SENSITIVE is true, then FIND is case sensitive
                        $USER   'CASE-SENSITIVE',$CASE_SENSITIVE,VAR_CASE_SENSITIVE

;  CURRENT-FILE-POSITION
                        $USER   'CURRENT-FILE-POSITION',$CURRENT_FILE_POSITION,VAR_CURR_FILE_POS

;  c-addr and length of last REFILL
                        $USER   'REFILL-SOURCE',$REFILL_SOURCE,VAR_REFILL_SOURCE

                        $USER   'INCLUDE-LINE#',$INCLUDE_LINE_NUM,VAR_INCLUDE_LINE_NUM

                        $USER   'ERROR-LINE#',$ERROR_LINE_NUM,VAR_ERROR_LINE_NUM

;  addr of the latest INCLUDE mark
;  INCLUDE mark is an xt of the word whose name provides included file name
                        $USER   'INCLUDE-MARK',$INCLUDE_MARK,VAR_INCLUDE_MARK

;  FILE-LINE
;  Line address for INCLUDED
                        $USER   'FILE-LINE',$FILE_LINE,VAR_FILE_LINE

;  #FILE-LINE
;  Line length for INCLUDED
                        $USER   '#FILE-LINE',$HASH_FILE_LINE,VAR_HASH_FILE_LINE

                        $CONST  'MAX-FILE-LINE-LENGTH',,MAX_FILE_LINE_LENGTH

;  USER-SIZE-VAR
                        $VAR    'USER-SIZE-VAR',,USER_AREA_SIZE

;  EXCEPTION-HANDLER
                        $USER   'EXCEPTION-HANDLER',$EXCEPTION_HANDLER,VAR_EXCEPTION_HANDLER

;  S"INDEX
                        $VAR    'S"INDEX',$SQINDEX,0

;  /S"INDEX
                        $CONST  '/S"INDEX',$SLSQINDEX,SLSQINDEX

;  S"INDEX-MASK
                        $CONST  'S"INDEX-MASK',$SQINDEX_MASK,SLSQINDEX - 1

;  S"BUFFER
                        $USER   'S"BUFFER',$SQBUFFER,VAR_SQBUFFER

;  /S"BUFFER
                        $CONST  '/S"BUFFER',$SLSQBUFFER,SLSQBUFFER

;  POCKET
                        $USER   'POCKET',$POCKET,VAR_POCKET

;  CURRENT
                        $USER   'CURRENT',$CURRENT,VAR_CURRENT

;  RECURSE-XT
;  Stores the xt of the word to be compiled by RECURSE
                        $USER   'RECURSE-XT',,VAR_RECURSE_XT

;  Start file name
;  #SF
                        $VAR    '#SF',$HASH_SF,0
HASH_SF_VAR EQU PFA_$HASH_SF

;  SF
                        $VAR    'SF',$SF,0
SF_VAR EQU PFA_$SF

                        $CONST  'EXIT-CODE',$EXIT_CODE,0
EXIT_CODE_VAR EQU PFA_$EXIT_CODE

                        $CONST  'ARGC',$ARGC,0
ARGC_VAR EQU PFA_$ARGC

                        $CONST  'ARGV',$ARGV,0
ARGV_VAR EQU PFA_$ARGV

                        $CONST  'ENVP',$ENVP,0
ENVP_VAR EQU PFA_$ENVP

;  DATA-AREA-BASE
                        $CONST  'DATA-AREA-BASE',,DESIRED_BASE_EQU

;  DATA-AREA-SIZE
                        $CONST  'DATA-AREA-SIZE',,DESIRED_SIZE_VAR + IMAGE_BASE

;  DP
;  HERE = DP @
                        $VAR    'DP',$DP,HERE + IMAGE_BASE
VAR_DP EQU PFA_$DP

;  6.1.2250 STATE
;  D: -- a-addr
;  a-addr is the address of a cell containing the compilation-state flag.
;  STATE is true when in compilation state, false otherwise.
;  The true value in STATE is non-zero, but is otherwise implementation-defined.
                        $VAR    'STATE',$STATE,F_FALSE
VAR_STATE EQU PFA_$STATE

;  6.1.0750 BASE
;  a-addr is the address of a cell containing the current number-conversion
;  radix {{2...36}}.
;  D: -- a-addr
                        $USER   'BASE',$BASE,VAR_BASE

;  6.1.0770 BL
;  Push space character on stack
;  D: -- char
                        $CONST  'BL',$BL,' '

;  MAIN
;  First Forth word to EXECUTE
                        $DEFER  'MAIN',$MAIN,$DO_FORTH
MAIN_PROC_VAR EQU PFA_$MAIN

