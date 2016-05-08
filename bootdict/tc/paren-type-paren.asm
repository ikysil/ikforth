;  (TYPE)
;  Type counted string compiled just after XT of this word
;  and continue execution with the next XT after the string.
                $COLON      '(TYPE)',$PTYPE
                CW          $RFROM                  ; a
                CW          $COUNT                  ; a+1 b
                CW          $OVER                   ; a+1 b a+1
                CW          $OVER                   ; a+1 b a+1 b
                CW          $ADD                    ; a+1 b a+1+b
                CW          $TOR                    ; a+1 b
                CW          $TYPE
                $END_COLON
