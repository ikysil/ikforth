;******************************************************************************
;
;  recognizer-word.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  Word recognizer
;******************************************************************************

;  R:WORD-INT - word INTERPRET action
;  ( i*x XT flags -- j*y )
                $COLON      'R:WORD-INT',$R_WORD_INT
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'R:WORD-INT'
                $TRACE_STACK 'R:WORD-INT-A:',2
                }
                CW          $AMPCOMPILE_ONLY, $AND, $ZERO_NOT_EQUALS
                _IF         R_WORD_INT_COMPILE_ONLY
                CW          $CODE_TO_NAME, $NAME_TO_STRING
                CW          $SQTOPOCKET, $DROP
                CTHROW      -14
                _THEN       R_WORD_INT_COMPILE_ONLY
                CW          $EXECUTE
                $END_COLON

;  R:WORD-COMP - word COMPILE action
;  ( XT flags -- )
                $COLON      'R:WORD-COMP',$R_WORD_COMP
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'R:WORD-COMP'
                $TRACE_STACK 'R:WORD-COMP-A:',2
                }
                CW          $AMPIMMEDIATE, $AND, $ZERO_NOT_EQUALS
                _IF         R_WORD_COMP_IMMEDIATE
                CW          $EXECUTE
                _ELSE       R_WORD_COMP_IMMEDIATE
                CW          $COMPILEC
                _THEN       R_WORD_COMP_IMMEDIATE
                $END_COLON

;  R:WORD-POST - word POSTPONE action
;  ( XT flags -- )
                $COLON      'R:WORD-POST',$R_WORD_POST
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'R:WORD-POST'
                $TRACE_STACK 'R:WORD-POST-A:',2
                }
                CW          $SWAP, $LITERAL, $LITERAL
                $END_COLON

                $RTABLE     'R:WORD',$R_WORD,$R_WORD_INT,$R_WORD_COMP,$R_WORD_POST

;  REC:WORD
;  ( addr len -- XT flags R:WORD | R:FAIL )
                $COLON      'REC:WORD',$REC_WORD
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:WORD'
                $TRACE_STACK 'REC:WORD-A:',2
                }
                CW          $DUPE, $ZERO_EQUALS
                _IF         REC_WORD_EMPTY_NAME
                CW          $DROP, $R_FAIL
                CW          $EXIT
                _THEN       REC_WORD_EMPTY_NAME
                CW          $SEARCH_NAME     ; ( XT imm-flag | 0 )
                CW          $QUESTION_DUPE
                _IF         REC_WORD_SUCCESS
                CW          $DROP, $DUPE, $CODE_TO_NAME, $HFLAGS_FETCH
                CW          $R_WORD
                _ELSE       REC_WORD_SUCCESS
                CW          $R_FAIL
                _THEN       REC_WORD_SUCCESS
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:WORD'
                $TRACE_STACK 'REC:WORD-B:',3
                }
                $END_COLON
