;  CALL,
;  ( addr -- )
;  Compile CPU specific CALL instruction to call a procedure at specified address.
                $COLON      'CALL,'
                CCLIT       0E8h
                CW          $BCOMMA,$HERE,$MINUS
                CCLIT       4
                CW          $MINUS,$COMMA
                $END_COLON
