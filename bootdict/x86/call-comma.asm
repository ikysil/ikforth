;  CALL,
;  ( addr -- )
;  Compile CPU specific CALL instruction to call a procedure at specified address.
                $COLON      'CALL,'
                CCLIT       0E8h
                CW          $BCOMMA,$HERE,$SUB
                CCLIT       4
                CW          $SUB,$COMMA
                $END_COLON
