;  Output the byte on the top of the data stack in hexadecimal representation.
;  S: a --
                $COLON      'H.2',$HOUT2
                CW          $BTOH, $EMIT, $EMIT
                $END_COLON
