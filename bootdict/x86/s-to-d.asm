;  6.1.2170 S>D
;  Convert single cell value to double cell value
;  D: a -- aa
                $CODE       'S>D',$S_TO_D
                POPDS       EAX
                CDQ
                PUSHDS      EAX
                PUSHDS      EDX
                $NEXT
