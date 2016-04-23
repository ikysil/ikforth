;******************************************************************************
;
;  recognizer-word.asm
;  IKForth
;
;  Copyright (C) 2016 Illya Kysil
;
;******************************************************************************
;  Word recognizer
;******************************************************************************

;  R:WORD-INT - word INTERPRET action
;  ( i*x XT flags -- j*y )
                $NONAME     R_WORD_INT
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'R:WORD-INT'
                $TRACE_STACK 'R:WORD-INT-A:',2
                }
                CW          HF_COMPILE_ONLY, $AND, $ZERONOEQ
                _IF         R_WORD_INT_COMPILE_ONLY
                CTHROW      -14
                _THEN       R_WORD_INT_COMPILE_ONLY
                CW          $EXECUTE
                CW          $EXIT

;  R:WORD-COMP - word COMPILE action
;  ( XT flags -- )
                $NONAME     R_WORD_COMP
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'R:WORD-COMP'
                $TRACE_STACK 'R:WORD-COMP-A:',2
                }
                CW          HF_IMMEDIATE, $AND, $ZERONOEQ
                _IF         R_WORD_COMP_IMMEDIATE
                CW          $EXECUTE
                _ELSE       R_WORD_COMP_IMMEDIATE
                CW          $COMPILEC
                _THEN       R_WORD_COMP_IMMEDIATE
                CW          $EXIT

;  R:WORD-POST - word POSTPONE action
;  ( XT flags -- )
                $NONAME     R_WORD_POST
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'R:WORD-POST'
                $TRACE_STACK 'R:WORD-POST-A:',2
                }
                CW          $2LITERAL
                CW          $EXIT

                $RTABLE     'R:WORD',R_WORD,R_WORD_INT,R_WORD_COMP,R_WORD_POST

;  REC:WORD
;  ( addr len -- XT flags R:WORD | R:FAIL )
                $COLON      'REC:WORD',REC_WORD
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:WORD'
                $TRACE_STACK 'REC:WORD-A:',2
                }
                CW          $SEARCH_NAME     ; ( XT imm-flag | 0 )
                CW          $QDUP
                _IF         REC_WORD_SUCCESS
                CW          $DROP, $DUP, $TO_HEAD, $HFLAGS_FETCH
                CW          R_WORD
                _ELSE       REC_WORD_SUCCESS
                CW          R_FAIL
                _THEN       REC_WORD_SUCCESS
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD  'REC:WORD'
                $TRACE_STACK 'REC:WORD-B:',3
                }
                CW          $EXIT
