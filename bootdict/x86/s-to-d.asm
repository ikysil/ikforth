;  6.1.2170 S>D
;  Convert single cell value to double cell value
;  D: a -- aa
                $CODE       'S>D',$STOD
                POPDS       EAX
                CDQ
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT
