;******************************************************************************
;
;  interpret.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  INTERPRET support
;******************************************************************************

;  D: c-addr u --
                $NONAME     $PINTERPRET_WORD_NOT_FOUND
                CW          $SQTOPOCKET, $DROP
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
                CW          $FORTH_RECOGNIZER, $DO_RECOGNIZER
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'INTERPRET-WORD'
                $TRACE_STACK 'INTERPRET-WORD-B:',4
                }
                CFETCH      $STATE
                _IF         IW_COMPILE
                CW          $R2COMP
                _ELSE       IW_COMPILE
                CW          $R2INT
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
                CW          $SOURCE, $DUPE
                CSTORE      $HASH_INTERPRET_TEXT
                CW          $INTERPRET_TEXT, $SWAP, $C_MOVE
                CW          $INTERPRET_TEXT, $HASH_INTERPRET_TEXT, $REFILL_SOURCE, $TWO_STORE
                CFETCH      $INCLUDE_LINE_NUM
                CSTORE      $ERROR_LINE_NUM
                $END_COLON

;  INTERPRET
                $COLON      'INTERPRET',$INTERPRET
                CW          $INTERPRET_TEXT_STORE
                _BEGIN      INT_LOOP
                CW          $PARSE_NAME, $DUPE
                _WHILE      INT_LOOP                    ; exit loop if parse area is exhausted
                CW          $INTERPRET_WORD
                _REPEAT     INT_LOOP
                CW          $TWO_DROP
                $END_COLON
