;  Output the value on the top of the data stack in hexadecimal representation.
;  S: a --
                $COLON      'H.8',$HOUT8
                CW          $SPLIT8, $HOUT2, $HOUT2, $HOUT2, $HOUT2
                $END_COLON
