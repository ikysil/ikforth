;  (TYPE)
;  Type counted string compiled just after XT of this word
;  and continue execution with the next XT after the string.
                $COLON      '(TYPE)',$PTYPE
                CW          $R_FROM                  ; a
                CW          $COUNT                  ; a+1 b
                CW          $OVER                   ; a+1 b a+1
                CW          $OVER                   ; a+1 b a+1 b
                CW          $PLUS                    ; a+1 b a+1+b
                CW          $TO_R                    ; a+1 b
                CW          $TYPE
                $END_COLON
