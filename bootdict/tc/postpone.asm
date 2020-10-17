;  6.1.2033 POSTPONE
;  Interpretation:
;  Interpretation semantics for this word are undefined.
;  Compilation:
;  ( "<spaces>name" -- )
;  Skip leading space delimiters. Parse name delimited by a space. Find name.
;  Append the compilation semantics of name to the current definition.
;  An ambiguous condition exists if name is not found.
                $COLON      'POSTPONE',,VEF_IMMEDIATE
                CW          $PARSE_NAME
                CW          $FORTH_RECOGNIZER, $DO_RECOGNIZER
                CW          $DUP, $TOR, $R2POST, $EXECUTE, $RFROM, $R2COMP, $COMPILEC
                $END_COLON
