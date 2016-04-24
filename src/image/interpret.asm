;******************************************************************************
;
;  interpret.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  INTERPRET support
;******************************************************************************

;  6.1.2033 POSTPONE
;  Interpretation:
;  Interpretation semantics for this word are undefined.
;  Compilation:
;  ( "<spaces>name" -- )
;  Skip leading space delimiters. Parse name delimited by a space. Find name.
;  Append the compilation semantics of name to the current definition.
;  An ambiguous condition exists if name is not found.
                $COLON      'POSTPONE',,VEF_IMMEDIATE
                CW          $BL, $WORD, $COUNT
                CW          FORTH_RECOGNIZER, DO_RECOGNIZER
                CW          $DUP, $TOR, R2POST, $EXECUTE, $RFROM, R2COMP, $COMPILEC
                $END_COLON

;  D: c-addr u --
                $NONAME     $PINTERPRET_WORD_NOT_FOUND
                CW          $2DROP
                CTHROW      -13
                $END_COLON

;  INTERPRET-WORD-NOT-FOUND
;  D: c-addr u --
                $DEFER      'INTERPRET-WORD-NOT-FOUND',$INTERPRET_WORD_NOT_FOUND,$PINTERPRET_WORD_NOT_FOUND

;  INTERPRET-WORD
;  ( c-addr u -- )
                $COLON      'INTERPRET-WORD',$INTERPRET_WORD
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'INTERPRET-WORD'
                $TRACE_STACK 'INTERPRET-WORD-A:',4
                }
                CW          FORTH_RECOGNIZER, DO_RECOGNIZER
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'INTERPRET-WORD'
                $TRACE_STACK 'INTERPRET-WORD-B:',4
                }
                CFETCH      $STATE
                _IF         IW_COMPILE
                CW          R2COMP
                _ELSE       IW_COMPILE
                CW          R2INT
                _THEN       IW_COMPILE
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'INTERPRET-WORD'
                $TRACE_STACK 'INTERPRET-WORD-C:',4
                }
                CW          $EXECUTE
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'INTERPRET-WORD'
                $TRACE_STACK 'INTERPRET-WORD-D:',4
                }
                $END_COLON

;  INTERPRET-TEXT!
;  Save current SOURCE for error reporting purposes
                $COLON      'INTERPRET-TEXT!',$INTERPRET_TEXT_STORE
                CW          $SOURCE, $DUP
                CSTORE      $HASH_INTERPRET_TEXT
                CW          $INTERPRET_TEXT, $SWAP, $CMOVE
                CW          $INTERPRET_TEXT, $HASH_INTERPRET_TEXT, $REFILL_SOURCE, $2STORE
                CFETCH      $INCLUDE_LINE_NUM
                CSTORE      $ERROR_LINE_NUM
                $END_COLON

;  INTERPRET
                $COLON      'INTERPRET',$INTERPRET
                CW          $INTERPRET_TEXT_STORE
INT_LOOP:
                CW          $BL, $WORD, $COUNT, $DUP
                CQBR        INT_EXIT                ; exit loop if parse area is exhausted
                CW          $INTERPRET_WORD
                CBR         INT_LOOP
INT_EXIT:
                CW          $2DROP
                $END_COLON
